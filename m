Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0IBCdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:33:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:40552 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab0IBCdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:33:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,307,1280732400"; 
   d="scan'208";a="319917497"
Subject: Re: [PATCH 1/2] [Patch-next -v2] ACPI, APEI Fix the return
 value(==NULL) of acpi_pre_map().
From: Huang Ying <ying.huang@intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: APEI-lenb <lenb@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <4C7F0C79.3060506@np.css.fujitsu.com>
References: <4C7F0C79.3060506@np.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 10:33:22 +0800
Message-ID: <1283394802.13175.47.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 10:31 +0800, Jin Dongming wrote:
> acpi_pre_map() is used for remapping the physical address of I/O, so
> it should be return NULL or remapped virtual address. The problem is
> that when (paddr - pg_off) equals 0, no matter whether I/O remapping is
> successful or not, the function returns NULL.
> 
> In acpi_pre_map(), after the physical address is remapped sucessfully,
> it will check whether the physical address has been added into acpi_iomaps
> list again.
>    - If the physical address has beed added into acpi_iomaps, the virtual
>      address will be saved in vaddr.
>    - Otherwise, NULL be saved in vaddr.
> 
> So if the physical address is the first time to be remapped, vaddr will be
> NULL always.
> 
> In many cases, (paddr - pg_off) may not equal 0. So the function could work
> well. In our machine, (paddr - pg_off) equals 0, so the return value of
> acpi_pre_map() is NULL.
> 
> This patch fixed it and I confirmed it on x86_64 next-tree.
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Acked-by: Huang Ying <ying.huang@intel.com>

Best Regards,
Huang Ying


