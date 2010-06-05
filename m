Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab0FEUGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:06:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55716 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab0FEUGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:06:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YJ2px+Z4y/0Lg98a4ayC61tGCi36e5zVETsFV+kDIeM8A78BUeIkyO8kUJM3jHYr+m
         39Z/KvBYFz1BuCDbcE1VXQ8xAvGp8KYkDMJ7mQkgWVNA6FbP0KvNFbYmwtBfTs8x1Hvp
         Smh4POYLqbX64qtUUcisYN9V5U1aHpfWirzL0=
MIME-Version: 1.0
In-Reply-To: <20100605215604.68efc4e5@schatten.dmk.lab>
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
	<AANLkTinBg9W7zeomPbpGEDWkIsfxO9OfFUC0Kq7wafFb@mail.gmail.com>
	<20100605215604.68efc4e5@schatten.dmk.lab>
Date: Sat, 5 Jun 2010 23:06:03 +0300
Message-ID: <AANLkTilhvUn3PfnHsJTNzhr59xrUyvGlFmnAOnub65sE@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
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

On Sat, Jun 5, 2010 at 10:56 PM, Florian Mickler <florian@mickler.org> wrote:
> On Sat, 5 Jun 2010 20:30:40 +0300
> Felipe Contreras <felipe.contreras@gmail.com> wrote:
>> I don't think the suspend blockers solve much. A bad application will
>> behave bad on any system. Suppose somebody decides to port Firefox to
>> Android, and forgets to listen to the screen off event (bad on Android
>> or Maemo), however, notices the application behaves very badly, so by
>> googling finds these suspend blockers, and enables them all the time
>> the application runs.
>>
>> When the user install the application, will be greeted by a warning
>> "This application might break PM, do you want to enable suspend
>> blockers?" (or whatever), as any typical user would do, will press Yes
>> (whatever).
>>
>> We end up in exactly the same situation.
>>
> No. The application will show up in the suspend blocker stats and the
> user will remember: "Oh, yes. There was a warning about that. Well I
> think I'm going to file a bug there."

How would such stats be calculated? I presume at regular intervals you
check which applications are holding suspend blockers and increase a
counter.

How would you do that with the dynamic PM approach? At regular
intervals you check for which applications are running (not idle).

> The only difference is, that with suspend blockers, he can than
> dismiss the applications permission to block suspend and will not miss
> his job interview the next day because his phones battery run
> out. And also he can use the application to a certain extent.

So the difference is between removing the app, and making it run
crappy. I don't think that's a strong argument in favor of suspend
blockers.

-- 
Felipe Contreras
