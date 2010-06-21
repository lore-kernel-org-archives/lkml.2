Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab0FUS6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:58:00 -0400
Received: from emroute4.ornl.gov ([160.91.86.27]:60470 "EHLO emroute4.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab0FUS56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:57:58 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jun 2010 14:57:58 EDT
Date: Mon, 21 Jun 2010 14:50:50 -0400
From: David Dillow <dave@thedillows.org>
Subject: Re: PROBLEM: SIS7019 stops recording after 42 min
In-reply-to: <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com>
To: linux@schou.dk
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Message-id: <1277146250.2501.44.camel@lap75545.ornl.gov>
MIME-version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com>
 <1276972298.22889.16.camel@obelisk.thedillows.org>
 <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com>
 <1277043970.22889.45.camel@obelisk.thedillows.org>
 <AANLkTikBTMq3d-Ov65wYLJ_Vw-7Jde4AOwfXcEPB0wLr@mail.gmail.com>
 <1277129180.22889.64.camel@obelisk.thedillows.org>
 <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 19:42 +0200, Hans Schou wrote:
> 2010/6/21 David Dillow <dave@thedillows.org>:
> > I don't know the options available on sox, but if you can use arecord to
> > reproduce, then that is probably the best tool for the job. Can you set
> > it up to use two periods per buffer and see if you still can reproduce?
> > Options would look like -B 250000 -F 125000. A second test with -B
> > 1000000 -F 500000 would be interesting, if the hw can handle buffers of
> > that size -- I don't recall offhand.
> 
> I have just started it with  -B 250000 -F 125000 and get a lot of overrun.
> I skipped using strace to make less stress.
> 
> cmdline is now:
> arecord -B 250000 -F 125000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav
> 
> overrun!!! (at least 0.201 ms long)
> Status:
>   state       : XRUN
>   trigger_time: 1277140527.1826705
>   tstamp      : 1277140527.2005279
>   delay       : 0
>   avail       : 16537
>   avail_max   : 16537

This really makes me think the system just cannot keep up. Can you post
the initial output to verify that it is getting two periods per buffer,
please? If you are getting overruns and small files in that
configuration, there is not much I think I do to help -- that uses the
hardware's built-in support for generating the appropriate interrupts.

Also, does it do the same without the -M ? And you may wish to try
longer and shorter periods to see if you get so many overruns.

Also, what storage are you using? Does it support DMA? PIO modes can be
very slow...

> > I will hopefully have my hardware back up and running tonight; BTW, what
> > distro are you using? I'm trying Fedora 13, but I'm expecting to run
> > into trouble with the lack of cmov support on the processor.
> 
> Debian stable.

Thanks, I'll fall back to that if getting Fedora going looks to be more
trouble than it is worth.

Dave

