Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0GIKys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:54:48 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:58295 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab0GIKyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:54:47 -0400
X-IronPort-AV: E=Sophos;i="4.53,563,1272844800"; 
   d="scan'208";a="816299"
Date: Fri, 9 Jul 2010 11:54:24 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: "ddutile@redhat.com" <ddutile@redhat.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "stefano@stabellini.net" <stefano@stabellini.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] Re: [PATCH 12/13] Unplug emulated disks and nics
In-Reply-To: <1278662546.28432.602.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.00.1007091150000.21432@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>  <1277136847-13266-12-git-send-email-stefano@stabellini.net>  <4C2CEF56.4050008@redhat.com>  <alpine.DEB.2.00.1007051255310.29110@kaball-desktop>  <4C34DD1B.3010601@redhat.com> 
 <alpine.DEB.2.00.1007081246440.21432@kaball-desktop>  <4C362DC3.7000101@redhat.com>  <1278624583.12109.15.camel@localhost.localdomain>  <4C364A3F.8020900@redhat.com> <1278662546.28432.602.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010, Ian Campbell wrote:
> > 
> > > Any guest which uses xvda in its configuration file today will be using
> > > emulated devices but I think that with Stefano's patch and your proposed
> > > change in default on a Xen system without support for unplug will start
> > > using PV devices without unplugging the emulated ones first.
> > > 
> > Well, Stefano requires the admin to add unplug switch to kernel cmd line,
> 
> In the case where the host platform does not support the unplug protocol
> this is correct and requiring explicit admin action to allow the PV
> frontends to activate is the only safe option WRT the users data.
> 
> However if the host platform does support the unplug protocol then this
> is incorrect. In that case the default (in the absence of the command
> line option) is to automatically unplug any device for which a PV driver
> is available and so no command line option will be required in the
> common case. (see xen_unplug_emulated_devices() under the comment "Set
> the default value of xen_emul_unplug depending on...")
> 

that's right: on host platforms supporting unplug no command line options
are required; on the other hand if the host platform does not support
unplug then xen_emul_unplug=ignore is required to use PV drivers anyway.


> > so I don't see the harm in defaulting to unplug... 
> 
> As I described in my previous mail this is unsafe on host platforms
> which do not support unplug. As I describe above it is unnecessary on
> host platforms which do support unplug
> 

yep, keep in mind the copy and paste example.



If you are happy about the patch, I'll include it in my next version.

