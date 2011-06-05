Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab1FELHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 07:07:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62875 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab1FELHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 07:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WnhS4tUzIHj6NFXXgdoDaekKWMdy3CgElv2Ubyw5kTP3AS67yqq98vhcaPiSptlLrF
         DlvxtP3zMSthsLoMyO8bBgTINHrGbPRpAivsDg04aB9n2SF85aZFxK75yAHfriIym6tR
         i9XGMZyxwkpZ3AUwszCZYpnJm016pXl/fHx4E=
MIME-Version: 1.0
In-Reply-To: <1296577197-9766-1-git-send-email-bp@amd64.org>
References: <1296577197-9766-1-git-send-email-bp@amd64.org>
Date: Sun, 5 Jun 2011 07:07:34 -0400
Message-ID: <BANLkTikJ8jUVeEk=GuV6iaw2ASuOLPA4yw@mail.gmail.com>
Subject: Re: [PATCH 1/2] sysdev: Do not register with sysdev when erroring on add
From: Brian Gerst <brgerst@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 11:19 AM, Borislav Petkov <bp@amd64.org> wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
>
> When encountering an error while executing the driver's ->add method, we
> should cancel registration and unwind what we've regged so far. The low
> level ->add methods do return proper error codes but those aren't looked
> at in sysdev_driver_register(). Fix that by sharing the unregistering
> code.

This patch is causing boot failures on a virtual machine running
Fedora 15 32-bit.  With this patch, the microcode driver repeatedly
spews:
microcode: CPU0: AMD CPU family 0x6 not supported
modprobe: FATAL: Error inserting microcode: Invalid argument.
until eventually causing an oops.  Reverting this patch allows the
boot to proceed.

/proc/cpuinfo:
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 6
model		: 2
model name	: QEMU Virtual CPU version 0.13.0
stepping	: 3
cpu MHz		: 2809.416
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 4
wp		: yes
flags		: fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush mmx fxsr sse sse2 syscall nx lm pni cx16 popcnt
hypervisor lahf_lm abm sse4a
bogomips	: 5618.83
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

--
Brian Gerst
