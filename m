Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1ATOtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:49:32 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:26956 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755731Ab1ATOtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:49:31 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 1mmrlJkVM1nnIEup0TpneKAYi6LMTnooVffteaPmeei0Qwf
 zTyZu0uvMRa5v.fTsMR.kExQ7RxPuWKekABjS75PXlNg2DfhaRSM9jdwCrOA
 F4OtJmgP1Ts8TKQFFE4WSj2GT8c8cx4dTO5q54FXXjeoHwQhccBXkflA2rBN
 8aORKXMjgzr_z_YQ9aopTXdqGxlIvFD8U8nGJXq682Tlk6TAL6xxPuwNHKW4
 CaR8e3hkzvlJ3q99fOJPOLcQUxltcnsKut9RJBWrMKdpP.Yo-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 20 Jan 2011 08:49:27 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [REPOST] [PATCH 1/3] Move zone_reclaim() outside of CONFIG_NUMA
 (v3)
In-Reply-To: <20110120123608.30481.63446.stgit@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.00.1101200847350.10695@router.home>
References: <20110120123039.30481.81151.stgit@localhost6.localdomain6> <20110120123608.30481.63446.stgit@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Balbir Singh wrote:

> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -253,11 +253,11 @@ extern int vm_swappiness;
>  extern int remove_mapping(struct address_space *mapping, struct page *page);
>  extern long vm_total_pages;
>
> +extern int sysctl_min_unmapped_ratio;
> +extern int zone_reclaim(struct zone *, gfp_t, unsigned int);
>  #ifdef CONFIG_NUMA
>  extern int zone_reclaim_mode;
> -extern int sysctl_min_unmapped_ratio;
>  extern int sysctl_min_slab_ratio;
> -extern int zone_reclaim(struct zone *, gfp_t, unsigned int);
>  #else
>  #define zone_reclaim_mode 0

So the end result of this patch is that zone reclaim is compiled
into vmscan.o even on !NUMA configurations but since zone_reclaim_mode ==
0 noone can ever call that code?

