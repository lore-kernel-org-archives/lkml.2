Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1CKLir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:38:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54627 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1CKLio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U3nMcc+GtVAYlhz29uKZ/xpwfNJna3kZgJ57RCPp2jDXwG223uqvoBKHTLXEEIulKK
         OZH8DdIilzEhbEsoLXoTEsN3V4ouCf7v0ztM3YT5BOJHI90Tr06aJbK+1Dapj93S4XvI
         Kfn62NTOuxwiemEBdmOkA2/WKZHoqo62DfHdU=
Date: Fri, 11 Mar 2011 12:38:39 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Wang Lei <f3d27b@gmail.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
Message-ID: <20110311113839.GA4717@alberich.amd.com>
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
 <201103092125.43950.rjw@sisk.pl>
 <4d780a2f.231a8f0a.3b01.ffffa228@mx.google.com>
 <201103100106.36678.rjw@sisk.pl>
 <4d796b47.20f98e0a.2695.fffff615@mx.google.com>
 <20110311074156.GD13156@alberich.amd.com>
 <4d79fdbd.43392b0a.0aae.0712@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d79fdbd.43392b0a.0aae.0712@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 06:47:34PM +0800, Wang Lei wrote:
> Hi Andreas,
> 
> Thanks for your reply.
> 
> Andreas Herrmann <andreas.herrmann3@amd.com> writes:
> 
> > Hi Lei,
> >
> > can you please provide information, which system you are using.  dmesg
> > (please use apic=debug kernel parameter), output of lspci -nnxxxx (as
> > root),
> >
> 
> I'm using debian sid with customized kernel. dmesg and lspci are
> attached. 

> Initializing cgroup subsys cpuset
> Initializing cgroup subsys cpu
> Linux version 2.6.38-rc6+ (root@localhost) (gcc version 4.4.5 (Debian 4.4.5-12) ) #1 SMP Fri Feb 25 20:01:40 CST 2011
> Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38-rc6+ root=/dev/sda1 ro apic=debug

So that was the good case (all working as expected).

>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000097fb0000 (usable)
>  BIOS-e820: 0000000097fb0000 - 0000000097fc8000 (reserved)
>  BIOS-e820: 0000000097fc8000 - 0000000097fe7fb8 (ACPI NVS)
>  BIOS-e820: 0000000097fe7fb8 - 00000000a0000000 (reserved)
>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
>  BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
>  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> NX (Execute Disable) protection: active
> DMI 2.4 present.
> DMI: Hewlett-Packard HP Compaq 6515b (GL087PA#AB2)/30C2, BIOS 68YTT Ver. F.05 04/26/2007

                       ^^^^^^^^^^^^^^^

Hmm, I thought that this might be the case.

Can you please try to boot -rc7 with kernel parameter acpi_skip_timer_override
and send the same output (dmesg again also with apic=debug and lspci -nnxxxx)


Thanks,

Andreas

PS: My assumption is that the patch in -rc7 leads to usage of IO-APIC
    pin2 for timer interrupt (potentially I have broken chipset
    revision determination for some SB600.)
