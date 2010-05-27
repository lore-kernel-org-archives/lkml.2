Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab0E0TIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:08:10 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:45286 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab0E0TIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:08:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=c1czYvm7wW3vkY+wCnmi4IT56u5LbhbBb025TnTwONCgFaIflb8XfMpv8lozk6TR2V
         I3wwsAS1A5ThqvnlSkCWrU+clcISK4e7gn7J2sxG33uEPnWhcEtzFjfxtJY1InFYNwZd
         1I0X37BcxuXIiav1WC+xm6OVMyhVJY9k7Liho=
MIME-Version: 1.0
In-Reply-To: <htmdsk$9kn$1@dough.gmane.org>
References: <loom.20100524T171038-56@post.gmane.org>
	<20100525062100.GP22163@redhat.com>
	<4BFD5616.6070302@cora.nwra.com>
	<4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>
	<htmdsk$9kn$1@dough.gmane.org>
Date: Thu, 27 May 2010 12:08:04 -0700
X-Google-Sender-Auth: 16_-sKx7e_O2JV3v_EXMMCqmq5o
Message-ID: <AANLkTindrSuRdOI30l4P5XMuUVv3j7Zso9fMi1xREb3A@mail.gmail.com>
Subject: Re: Clock jumps
From: john stultz <johnstul@us.ibm.com>
To: Bernhard Schmidt <berni@birkenwald.de>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:32 AM, Bernhard Schmidt <berni@birkenwald.de> wrote:
> Alexander Graf <agraf@suse.de> wrote:
>> Do you have ntpd running inside the guest? I have a bug report lying
>> around about 2.6.33 with kvm-clock jumping in time when ntpd is used:
>> https://bugzilla.novell.com/show_bug.cgi?id=582260
>
> I want to chime in here, I have a very similar problem, but not with
> ntpd in the guest.
>
> The host was a HP ProLiant DL320 G5p with a Dualcore Xeon3075. System
> was a Debian Lenny with a custom 2.6.33 host kernel and a custom
> qemu-kvm 0.11.0 .deb ported from Ubuntu. The host is synced with ntpd.
>
> The guests are various Debian Lenny/Squeeze VMs, with a custom kernel
> (2.6.33 at the moment) with kvm-clock. Exclusively amd64 guest
> kernels, but one system has i386 userland.
>
> With this setup once in a while (maybe every other week) one VM would
> have a sudden clock jump, 6-12 hours into the future. No kernel messages
> or other log entries than applications complaining about the clock jump
> after the fact. Other VMs were unaffected.
>
> Yesterday I did an upgrade to Debian Squeeze. This involved a new
> qemu-kvm (0.12.4), but not a new host kernel. I also upgraded the guest
> kernels from 2.6.33 to 2.6.33.4.
>
> First of all, after the reboot the host clock was totally unreliable. I
> had a constant skew of up to five seconds per minute in the host clock,
> which of course affected the VMs as well.  This problem went away when I
> changed from tsc into hpet on the host. The host does CPU frequency
> scaling which is, as far as I know, known to affect TSC stability. I
> think I remember messages about tsc being unstable in earlier boots,
> maybe the detection did just not work this time.

I'd be very interested in hearing more about the host side issue. So
this happened with the same kernel that you were using before, with no
trouble?

Could you also send dmesg output from this boot? And if you can find
any older dmesg logs to compare with, send those too?

thanks
-john
