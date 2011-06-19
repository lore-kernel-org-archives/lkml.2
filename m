Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1FSDpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 23:45:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38945 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1FSDpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 23:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PbSb3mXVgmqoh1xmNSSrzjQW8R4TK6B2OvMFrI6B8Lz2NEPEh67mbpkwj1I6anXvUA
         cYZN9wDH8PDzRmu+00BykvdP9F9yVaNEAUAR4diOwgy6lHp06RCDqX38Uyz0+MdFSdFL
         JHovghNJRVtEJGJZGJPF66Ok9tWdbI9ufPnUI=
MIME-Version: 1.0
In-Reply-To: <BANLkTik3iseHFah_s=NNasQ22NtA+9zLWA@mail.gmail.com>
References: <BANLkTik3iseHFah_s=NNasQ22NtA+9zLWA@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sat, 18 Jun 2011 23:44:29 -0400
Message-ID: <BANLkTi=SrUOgTdBZUzP2SCGNHogw+P_Y5g@mail.gmail.com>
Subject: Re: tracing kernel panics
To: Shane <software.research.development@gmail.com>
Cc: linux-kernel@vger.kernel.org, Calvin Owens <jcalvinowens@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 18, 2011 at 20:12, Shane
<software.research.development@gmail.com> wrote:
> Anyone offer advice on how I should go about tracking down this kernel
> panic? Apologies if I've got the wrong list, let me know.
>
> I'm developing a networking module, my own protocol over TCP. I load
> my module, I make a network connection, and then I close it. I do
> nothing more, then after about 1-2 minutes, it throws this panic
> output and none of it seems to come from my module code. I know my
> code is the problem, and if I don't run my modules, I never get
> panics. But nothing in the stack trace I recognize from my code and
> I'm having a very hard time find where in my code I've gone wrong. I
> run my kernel modules in a VM as a guest OS which connects to another
> guest OS (currently using 2.6.36-r5).
>
> I've read how to analyze an OOPS, but ... here I can't even find the
> file that this might belong to so as to disassemble it, or understand
> what device this is. Any suggestions/pointers/advice much appreciated?
[...]
> [  330.829809]  [<ffffffff8147f763>] arp_process+0x1a8/0x4e9
> [  330.829809]  [<ffffffff8104b236>] ? pvclock_clocksource_read+0x4b/0xb4
> [  330.829809]  [<ffffffff8147f5bb>] ? arp_process+0x0/0x4e9

First, try turning on frame pointers (CONFIG_FRAME_POINTER) - without
them the stack traces can be a bit unreliable, as we can see here.

If you still need help after turning on frame pointers and getting a
clean trace, you may want to consider cross-posting to
linux-net@vger.kernel.org and kernelnewbies@kernelnewbies.org as well.


Also, if you're just doing this as an exercise in learning kernel APIs
ignore this, but if this is for a real application, please consider
implementing TCP-based protocols in userspace instead of the kernel;
for most use cases there's no real need to put it down in the kernel
(with some exceptions, such as network filesystems).
