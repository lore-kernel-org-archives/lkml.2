Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2E3P3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:29:22 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36629 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2E3P3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:29:21 -0400
Date: Wed, 30 May 2012 17:29:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (RFC)
Message-ID: <20120530152948.GD4771@aftab.osrc.amd.com>
References: <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524184947.GA28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C4E@SHSMSX101.ccr.corp.intel.com>
 <20120525180102.GA27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0D53@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923351F44F3@SHSMSX101.ccr.corp.intel.com>
 <20120529133858.GD29157@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351FC452@SHSMSX101.ccr.corp.intel.com>
 <20120530150827.GA12109@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351FC523@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351FC523@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 03:20:03PM +0000, Liu, Jinsong wrote:
> >> IMO currently there are 2 options:
> >> 1). use the original approach (implicitly redirect /dev/mcelog to
> >> xen_mce_chrdev_device) --> what point of this approach do you think
> >> unreasonable? It just remove a 'static' from native mce code! 2).
> >> use another /dev/xen-mcelog interface, with another misc minor '226'
> > 
> > The 2) is no good.
> > 
> > 3) What about moving the corresponding other users (so
> > threshold_init_device), to be at late_initcall and the mce to be at
> > late_initcall_sync 
> 
> I can try, but only if Boris would not jump out.
> and it can only be tested by Boris at AMD platform :(

Sure, I'll test it.

However, it should be a separate patch, not merged with this one.

So, I don't see anything speaking against making threshold_init_device a
late_initcall leading to the following order:

device_initcall <- xen
device_initcall_sync <- arch/x86
fs_initcall <- threshold_init_device

and the "xen" line not happening on baremetal; which shouldn't change
anything noticeably in the init-order mce-wise.

Also, add a comment at the end of mce_amd.c saying why
threshold_init_device should be last.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
