Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1FHXyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 19:54:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53531 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1FHXyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 19:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mR72Y0PAM9On7PbcY2ePijPcueXGICyucMx3G7QdFmxMunv2lIhTJvCKezSRqurKYS
         zX2wJj/FLnMSScBcY7moRYLIxeYAvTmuUjsEnC+v2RuA9ZOVyUexk1NdiI/nXowxrvZh
         y3md8MQ3Rn8zIvRSRULFFCNut1/0yEzKugFps=
Message-ID: <4DF00BC1.1040007@gmail.com>
Date: Thu, 09 Jun 2011 01:54:41 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Yinghai Lu <yinghai@kernel.org>,
        Jim Bos <jim876@xs4all.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <20110608193833.GA29855@srcf.ucam.org> <4DEFD220.5040507@kernel.org> <20110608195250.GB30256@srcf.ucam.org> <4DEFD58D.5060402@kernel.org> <20110608200903.GA30694@srcf.ucam.org> <4DEFDA4A.9080500@kernel.org> <20110608203037.GA31052@srcf.ucam.org> <4DEFDD69.7010000@kernel.org> <20110608204244.GA31484@srcf.ucam.org> <BANLkTikfbSsgGgNEQ3GVD=HOPn1Dz_xh+g@mail.gmail.com> <20110608212813.GB32056@srcf.ucam.org> <BANLkTikbx6xm+NY34ATN7YkJyjPp9CSXTw@mail.gmail.com> <4DEFEEE7.1030703@linux.intel.com> <BANLkTi=0NyXLRpxnP=dmSgeStNtxYMKPuA@mail.gmail.com>
In-Reply-To: <BANLkTi=0NyXLRpxnP=dmSgeStNtxYMKPuA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 09-06-11 00:57, Linus Torvalds schreef:
> On Wed, Jun 8, 2011 at 2:51 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>> However, I suspect that what we *should* do is carry an kernel EFI stub
>> to go along with the BIOS stub... otherwise we're forever at mercy of
>> getting all the boot loader authors to change in lockstep, and there are
>> specific ones which are notoriously hard to work with.
> Yes, that would probably be a good approach. We obviously have some
> low-level asm code for the BIOS case that is technically linked into
> the kernel, but is running before the kernel boots and not really
> "part" of the kernel. Doing something similar for EFI support sounds
> entirely sane to me.
I agree that's a long term solution, meanwhile can we just hope
that not too much boot memory is reserved and not free
that memory so it at least boots for more people?

Maybe add a printk of 'X amount of boot memory will not freed',
so at least people can quantify and judge for themselves whether
it's worth disabling kernel efi support or not.

~Maarten
