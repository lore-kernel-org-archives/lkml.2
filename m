Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab0FERan (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 13:30:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39384 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab0FERal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 13:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GAaJaQQWlENUdVMU/jjc8V6KVrElzTdAW/cyU1+D+QVCehA27ll1gAQgbbJtNKh8F/
         EVJJ7OVXKpwxcXoFTMlKiLgZ6h/1+Ggu1PHEVDUIlx2r1HtacpFlLc4HLaVKpLKdTBC1
         Q7Q7gwdRjd6gY3VyBAzsSUdzUgVWDfLciIShE=
MIME-Version: 1.0
In-Reply-To: <1275578881.27810.35995.camel@twins>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<201005302202.39511.rjw@sisk.pl>
	<AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
	<201005312347.24251.rjw@sisk.pl>
	<AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
	<alpine.LFD.2.00.1006011411200.2933@localhost.localdomain>
	<AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
	<alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
	<AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
	<1275471561.27810.30865.camel@twins>
	<AANLkTilLmAb2c9fQwuguzWtjcHfuTZvPUTbUx7vuwFI6@mail.gmail.com>
	<1275474088.27810.31000.camel@twins>
	<20100602221309.6da754e7@schatten.dmk.lab>
	<1275550802.27810.34863.camel@twins>
	<20100603161205.73a2b56d@schatten.dmk.lab>
	<1275578881.27810.35995.camel@twins>
Date: Sat, 5 Jun 2010 20:30:40 +0300
Message-ID: <AANLkTinBg9W7zeomPbpGEDWkIsfxO9OfFUC0Kq7wafFb@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Florian Mickler <florian@mickler.org>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 6:28 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-06-03 at 16:12 +0200, Florian Mickler wrote:
>> On Thu, 03 Jun 2010 09:40:02 +0200
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> > Same for firefox, you can teach it to not render animated gifs and run
>> > javascript for invisible tabs, and once the screen-saver kicks in,
>> > nothing is visible (and with X telling apps their window is visible or
>> > not it knows), so it should go idle all of its own.
>> >
>> > Fix the friggin apps, don't kludge with freezing.
>>
>> Of course programs should be as smart as possible. But that is an
>> orthogonal problem.
>>
>> Suppose firefox were fixed. It still needs to fetch my rss feeds every
>> minute, because I'm sad if it doesn't. It just can't be fixed at the
>> application level.
>
> Sure it can, why would it need to fetch RSS feeds when the screen is off
> and nobody could possible see the result? So you can stop the timer when
> you know the window isn't visible or alternatively when the screensaver
> is active, I think most desktops have notification of that as well.

Exactly, and that's what applications in the N900 do. For this to work
reliably, you need these notifications (network disconnected, screen
off) to be easily accessible, and even transparent to the application
writer.

I don't think the suspend blockers solve much. A bad application will
behave bad on any system. Suppose somebody decides to port Firefox to
Android, and forgets to listen to the screen off event (bad on Android
or Maemo), however, notices the application behaves very badly, so by
googling finds these suspend blockers, and enables them all the time
the application runs.

When the user install the application, will be greeted by a warning
"This application might break PM, do you want to enable suspend
blockers?" (or whatever), as any typical user would do, will press Yes
(whatever).

We end up in exactly the same situation.

-- 
Felipe Contreras
