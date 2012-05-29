Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2E2Sqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 14:46:54 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42454 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab2E2Sqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 14:46:53 -0400
Date: Tue, 29 May 2012 14:39:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/3] xen/mce: Add mcelog support for Xen
 platform (v2)
Message-ID: <20120529183952.GA31237@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524184947.GA28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C4E@SHSMSX101.ccr.corp.intel.com>
 <20120525180102.GA27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0D53@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923351F4313@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351F4313@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> An approach which basically same as you suggested but w/ slightly update, is
> 1). at xen/mcelog.c, do misc_register(&xen_mce_chrdev_device) at xen_late_init_mcelog, define it as device_initcall(xen_late_init_mcelog) --> now linux dd ready, so xen mcelog divice would register successfully;

OK.
> 2). at native mce.c, change 1 line from device_initcall(mcheck_init_device) to device_initcall_sync(mcheck_init_device) --> so misc_register(&mce_chrdev_device) would be blocked by xen mcelog device;

You mean that the registration would be delayed to the next initcall level.
Ok, that sounds right.. but you also need to actually check the 'misc_register' return
value and if it fails (which it would in this case) unroll all the registration
that the generic code I think?

> 
> I have draft test it and works fine.
> Thought?
> 
> Thanks,
> Jinsong
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
