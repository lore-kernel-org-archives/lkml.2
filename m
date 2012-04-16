Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab2DPOCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:02:12 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:32132 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753431Ab2DPOCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:02:11 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 57NhGGQVM1m__aGYVftDQO83Mc0AvMFcVSNCld.VKXSp3f4
 MLLHGC4qdTmbXTVqN8jY_vGWhFIPAHTCjZDlpXh51q8IRfOYKOH6ranCcRtM
 x8sd1uoC8dlX9CghSqKd8d0UuEgqWIICDcyoRSfA9czc_Epw5uAbPyBQ2D32
 yuH8ct6wafZ.dSMb_Ilt0FRpt5vbEPvl_LbPN1U4GZ7dbvZybRpEpap2klRC
 FW5n9_1DxzEyPfdJmD7aztxzRJYR.56STXsgQG9SeGyCKdSdBLC870OWzTk_
 7cuK2Urmso.olmh_F5aV_kcaDRyWPFDbSi5JSK3jAeaYkqgwKI_fSM2veOIC
 VCRM93tSMv3X_2eEw9.tjYpvrMGD.VHF1dddWuO63EvfFMabQh8ihHI6itTI
 _6zyWDliZciW9T.tbp4WqrKJHDURfL8ZED6EN
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 16 Apr 2012 09:02:07 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>,
        devel@openvz.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slub: don't create a copy of the name string in
 kmem_cache_create
In-Reply-To: <1334351170-26672-1-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1204160900270.7795@router.home>
References: <1334351170-26672-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012, Glauber Costa wrote:

> When creating a cache, slub keeps a copy of the cache name through
> strdup. The slab however, doesn't do that. This means that everyone
> registering caches have to keep a copy themselves anyway, since code
> needs to work on all allocators.
>
> Having slab create a copy of it as well may very well be the right
> thing to do: but at this point, the callers are already there

What would break if we would add that to slab? I think this is more robust
because right now slab relies on the caller not freeing the string.
