Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab0F2VoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 17:44:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50385 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0F2VoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 17:44:00 -0400
Message-ID: <4C2A6921.1010405@codemonkey.ws>
Date: Tue, 29 Jun 2010 16:44:01 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chetan Loke <chetanloke@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: Hypervisor detection from within a Linux VM
References: <AANLkTinl3ighc51F5V4YP7fuOSscAA_qcynYMtM5j5wk@mail.gmail.com>
In-Reply-To: <AANLkTinl3ighc51F5V4YP7fuOSscAA_qcynYMtM5j5wk@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 04:25 PM, Chetan Loke wrote:
> Hello,
>
>
> Requirement:
> I have the need to support my apps(running on a Linux VM) on different
> *nix hypervisors(ESX/Xen etc). I need to know on which hypervisor my
> app is running. I read the CPUID usage thread -
> http://thread.gmane.org/gmane.comp.emulators.kvm.devel/22643 but to be
> honest in the end I looked at
> http://lxr.linux.no/#linux+v2.6.34/arch/x86/kernel/cpu/vmware.c#L88
> The vmware_platform() detection code is straight forward.
>
> Current-hack:
> As a quick hack we just grep lspci for VMware's pci-ids.
>
> Solution:
> I can write a bare minimal driver, check the cpu-id as VMware's
> balloon driver does and then emit a proc/sysfs node. The setup
> packages and the apps can then check for this node-string.I'm
> currently working on ESX and I am hoping that this thin-driver will
> work.
>    

It can be done entirely in userspace.  Take a look at virt-what:

http://people.redhat.com/~rjones/virt-what/

> Question:
> Q1)Is it possible to get this functionality as part of the stock
> kernel or is that a bad idea? I suspect there could be other
> users/apps who would need to know what *nix hypervisor(or a
> non-virtualized environment) they are
> running on?
> Q2)If this is not the right approach then can someone please suggest
> another approach?
>    

It might be reasonable to list the hypervisor signature as a field in 
/proc/cpuinfo.  There's also a /sys/hypervisor where such information 
could go.

Regards,

Anthony Liguori

> Regards
> Chetan Loke
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

