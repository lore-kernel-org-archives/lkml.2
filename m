Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2EXQZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:25:36 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36609 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab2EXQZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:25:34 -0400
Date: Thu, 24 May 2012 18:26:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (v2)
Message-ID: <20120524162605.GK27063@aftab.osrc.amd.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 04:15:02PM +0000, Liu, Jinsong wrote:
> The reason is, if we do so, it would be covered by native misc_register(&mce_chrdev_device) later when native kernel init (xen init first and then start native kernel).
> Under such case, if linux running under xen platform, /dev/mcelog point to vcpu, that's pointless since it cannot get any mcelog from physical cpu (which owned by xen).
> 
> Yes, we can use another misc device like /dev/xen-mcelog, w/ another device minor like 226, but that's not good for userspace mcelog tools. As far as I know, Novell mcelog use unified /dev/mcelog interface for linux running under either bare metal or xen platform.

Maybe create a symlink in /dev/mcelog pointing to /dev/xen-mcelog?

That should solve it.

> This patch just do redirection at xen code path, and that would not
> hurt anything to native kernel.

My concern is that if we remove /dev/mcelog one day, xen people will
cry.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
