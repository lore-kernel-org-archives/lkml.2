Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab1JMAAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:00:48 -0400
Received: from claw.goop.org ([74.207.240.146]:47011 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab1JMAAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:00:47 -0400
Message-ID: <4E962A27.4090509@goop.org>
Date: Wed, 12 Oct 2011 17:00:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com> <4E94E1E5.4070505@goop.org> <20111012101615.GA14966@aftab> <4E95D9E7.6090304@zytor.com> <4E95E7FE.6050302@goop.org> <20111012194543.GD14966@aftab> <20111012204048.GA22260@phenom.oracle.com> <4E960746.90805@zytor.com> <20111012214013.GD28723@aftab> <4E96198F.4030906@zytor.com> <4E962581.2000605@goop.org> <4E9628D4.1000605@zytor.com>
In-Reply-To: <4E9628D4.1000605@zytor.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 04:55 PM, H. Peter Anvin wrote:
> On 10/12/2011 04:40 PM, Jeremy Fitzhardinge wrote:
>> On 10/12/2011 03:49 PM, H. Peter Anvin wrote:
>>> The stickiest part of all of this is where to leave the microcode so
>>> the kernel can get to it way early.  We could use the linked list, but
>>> that would mean bootloader enabling; another idea was to stick it as a
>>> prefix to the initramfs identified by a signature.
>>
>> I think it would be easiest for the multiboot case if it were a separate
>> file, but I don't feel I'm really up on all the details.
>
> For the multiboot case, yes of course.
>
> Some bootloaders allow initramfs to be concatenated from multiple
> files; unfortunately I'm not sure if Grub ever grew that capability. 
> Sigh.

Presumably we'd want some way to make all possible microcode files
available to the hypervisor/kernel so that there's no need to construct
the bootloader config for a specific CPU vendor (or worse, CPU model). 
So that would need either some way of specifying multiple files, or a
wrapper which can contain multiple files?

    J

