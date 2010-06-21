Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab0FURnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:43:01 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54677 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab0FURnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=FRXwvPLGCFV/ddIArb/Pao6d+9Mhgq3kHDaKfNWS5c61Pa4fhKQK80y3ySSVDgIMg8
         s4Aiz9Z0U/fFt7EaSwl8Wq0PKfZucV3c7pILUlfWDa6AaEj2Oni1z8WVXiUJc1pv+lqb
         1daBfZjp8aklLB9g9NPoejzWtbkWSIM1fSAdQ=
MIME-Version: 1.0
Reply-To: linux@schou.dk
In-Reply-To: <1277129180.22889.64.camel@obelisk.thedillows.org>
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com> 
	<1276972298.22889.16.camel@obelisk.thedillows.org> <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com> 
	<1277043970.22889.45.camel@obelisk.thedillows.org> <AANLkTikBTMq3d-Ov65wYLJ_Vw-7Jde4AOwfXcEPB0wLr@mail.gmail.com> 
	<1277129180.22889.64.camel@obelisk.thedillows.org>
From: Hans Schou <linux@schou.dk>
Date: Mon, 21 Jun 2010 19:42:38 +0200
X-Google-Sender-Auth: IRBuaEV1Oekd0pIy-Qkm72pgSks
Message-ID: <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com>
Subject: Re: PROBLEM: SIS7019 stops recording after 42 min
To: David Dillow <dave@thedillows.org>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/21 David Dillow <dave@thedillows.org>:

>> Only 35 minutes of recording but I was running in 50min.
>
> Ok, cool, we see the problem with arecord as well, though you were
> getting overrun messages as well?

Yes, a lot of overrun. At least one per second.

>> How do I enable SND_PCM_XRUN_DEBUG with sox?
>
> Sorry, that should be CONFIG_SND_PCM_XRUN_DEBUG in the kernel
> configuration, but if we can demonstrate this with arecord, there's no
> real reason to recompile your kernel at this point.

OK, I'll skip that. It takes rather long time to compile.

>> Right now uptime says
>>    load average: 0.19, 0.21, 0.18
>> but strace and top is the bad guys, not arecord.
>
> An overrun means that arecord didn't run for 500ms, and the load average
> won't really tell you much about that -- latency can happen with low

Well, I did not see that with sox. It was running fine for 42 min.

> loads. That said, I'm suspecting that you've found a problem in the
> driver, and I'd lay odds it is in the handling of multiple periods per
> buffer.

> I don't know the options available on sox, but if you can use arecord to
> reproduce, then that is probably the best tool for the job. Can you set
> it up to use two periods per buffer and see if you still can reproduce?
> Options would look like -B 250000 -F 125000. A second test with -B
> 1000000 -F 500000 would be interesting, if the hw can handle buffers of
> that size -- I don't recall offhand.

I have just started it with  -B 250000 -F 125000 and get a lot of overrun.
I skipped using strace to make less stress.

cmdline is now:
arecord -B 250000 -F 125000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav

overrun!!! (at least 0.201 ms long)
Status:
  state       : XRUN
  trigger_time: 1277140527.1826705
  tstamp      : 1277140527.2005279
  delay       : 0
  avail       : 16537
  avail_max   : 16537
overrun!!! (at least 0.207 ms long)
Status:
  state       : XRUN
  trigger_time: 1277140527.128608572
  tstamp      : 1277140527.128793445
  delay       : 0
  avail       : 16537
  avail_max   : 16537
overrun!!! (at least 0.167 ms long)
Status:
  state       : XRUN
  trigger_time: 1277140527.256925501
  tstamp      : 1277140527.257071819
  delay       : 0
  avail       : 16537
  avail_max   : 16537

> I will hopefully have my hardware back up and running tonight; BTW, what
> distro are you using? I'm trying Fedora 13, but I'm expecting to run
> into trouble with the lack of cmov support on the processor.

Debian stable.

/hans
