Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab0GINni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:43:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab0GINnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:43:37 -0400
Message-ID: <4C372743.6070003@redhat.com>
Date: Fri, 09 Jul 2010 09:42:27 -0400
From: Don Dutile <ddutile@redhat.com>
Reply-To: ddutile@redhat.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081113)
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "stefano@stabellini.net" <stefano@stabellini.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] Re: [PATCH 12/13] Unplug emulated disks and nics
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>  <1277136847-13266-12-git-send-email-stefano@stabellini.net>  <4C2CEF56.4050008@redhat.com>  <alpine.DEB.2.00.1007051255310.29110@kaball-desktop>  <4C34DD1B.3010601@redhat.com>  <alpine.DEB.2.00.1007081246440.21432@kaball-desktop>  <4C362DC3.7000101@redhat.com>  <1278624583.12109.15.camel@localhost.localdomain>  <4C364A3F.8020900@redhat.com> <1278662546.28432.602.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1007091150000.21432@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1007091150000.21432@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefano Stabellini wrote:
> On Fri, 9 Jul 2010, Ian Campbell wrote:
>>>> Any guest which uses xvda in its configuration file today will be using
>>>> emulated devices but I think that with Stefano's patch and your proposed
>>>> change in default on a Xen system without support for unplug will start
>>>> using PV devices without unplugging the emulated ones first.
>>>>
>>> Well, Stefano requires the admin to add unplug switch to kernel cmd line,
>> In the case where the host platform does not support the unplug protocol
>> this is correct and requiring explicit admin action to allow the PV
>> frontends to activate is the only safe option WRT the users data.
>>
>> However if the host platform does support the unplug protocol then this
>> is incorrect. In that case the default (in the absence of the command
>> line option) is to automatically unplug any device for which a PV driver
>> is available and so no command line option will be required in the
>> common case. (see xen_unplug_emulated_devices() under the comment "Set
>> the default value of xen_emul_unplug depending on...")
>>
> 
> that's right: on host platforms supporting unplug no command line options
> are required; on the other hand if the host platform does not support
> unplug then xen_emul_unplug=ignore is required to use PV drivers anyway.
> 
> 
I see by looking at xen_unplug_emulated_devices() closer, that the default
unplugs emulated ide & emulated nic:
	if (xen_platform_pci_enabled && !xen_emul_unplug)

I had to work around the fact that xen_platform_pci_enabled would
not be set on rhel5-dom0 (no emul-unplug), so I hadn't looked at this default
so closely.


>>> so I don't see the harm in defaulting to unplug... 
>> As I described in my previous mail this is unsafe on host platforms
>> which do not support unplug. As I describe above it is unnecessary on
>> host platforms which do support unplug
>>
> 
> yep, keep in mind the copy and paste example.
> 
> 
> 
> If you are happy about the patch, I'll include it in my next version.
> 

Yes, the patch seems like a reasonable solution for running on older qemu-dm's.

Thanks for the clarification(s).

- Don
