Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2EXK3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:29:53 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34689 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577Ab2EXK3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:29:52 -0400
Date: Thu, 24 May 2012 12:30:23 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (v2)
Message-ID: <20120524103023.GA27063@aftab.osrc.amd.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:10:34AM +0000, Liu, Jinsong wrote:
> >> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> >> Signed-off-by: Ke, Liping <liping.ke@intel.com>
> >> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> >> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > 
> > If you're sending the patch, you need to be the last on the SOB-chain
> > and the SOB-chain has to show the proper path the patch took. See
> > <Documentation/SubmittingPatches>.

> Thanks! I will update it. But I'm not quite clear 'the SOB-chain has
> to show the proper path the patch took', would you elaborate more?

Section 12 in the SubmittingPatches readme has more or less an example
about it, here's what I mean:

Signed-off-by: Initial Patch Author <ipa@example.com>
Signed-off-by: Second Patch Author <spa@example.com>
Signed-off-by: Third Patch Author <tpa@example.com>
...
Signed-off-by: Patch Submitter <ps@example.com>

Some of the lines above may or may not be present depending on your
case. If you're sending the patch, you're the last in chain so your SOB
should be last.

That's what I mean with "proper path" the patch took, i.e. the SOB chain
should show how exactly this patch was created and who handled it on its
way upstream.


> >> -static struct miscdevice mce_chrdev_device = {
> >> +struct miscdevice mce_chrdev_device = {
> >>  	MISC_MCELOG_MINOR,
> >>  	"mcelog",
> >>  	&mce_chrdev_ops,
> > 
> > You're still reusing those - pls, define your own 'struct miscdevice
> > mce_chrdev_device' in drivers/xen/ or somewhere convenient and
> > your own mce_chrdev_ops. The only thing you should be touching in
> > arch/x86/.../mcheck/ is the export of MISC_MCELOG_MINOR.
> > 
> > Thanks.
> 
> I'm *not* reuse native code.
> I have defined 'struct miscdevice xen_mce_chrdev_device' in drivers/xen, and I also implement xen_mce_chrdev_ops, they are all xen-self-contained.
> 
> The patch just redirect native mce_chrdev_device to xen_mce_chrdev_device when running under xen environment.
> It didn't change any native code (except just cancel mce_chrdev_device 'static'), and will not break native logic.

Why are you doing that?

Why don't you do

	misc_register(&xen_mce_chrdev_device);

in xen_early_init_mcelog() ?

This way there'll be no arch/x86/ dependencies at all.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
