Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab0JDIzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:55:10 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:58815 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab0JDIzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:55:08 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [linux-pm] Swsusp patches applied to suspend-2.6#linux-next
Date: Mon, 4 Oct 2010 10:55:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-tp42-suspend-next-vmembase-0-00253-gab9b069-dirty; KDE/4.5.1; i686; ; )
Cc: linux-pm@lists.linux-foundation.org,
        Nigel Cunningham <nigelc@hera.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <201010041000.33653.Martin@lichtvoll.de> <4CA990FA.2070005@tuxonice.net> (sfid-20101004_103932_056526_9342061E)
In-Reply-To: <4CA990FA.2070005@tuxonice.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010041055.04973.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 04 Oktober 2010 schrieb Nigel Cunningham:
> Hi Martin.

Hi Nigel,

> On 04/10/10 19:00, Martin Steigerwald wrote:
> > Am Samstag 02 Oktober 2010 schrieb Martin Steigerwald:
> >> Am Montag 27 September 2010 schrieb Nigel Cunningham:
> >>> Hi again Rafael.
> >> 
> >> Hi Nigel and Rafael,
> >> 
> >>> As discussed, here are the patches, modified to apply against your
> >>> current linux-next tree. A new first patch splits compression
> >>> support out into its own file, removing the need to have two
> >>> versions of the load_image and save_image routines, minimising the
> >>> changes to the remainder of the patches and making things cleaner
> >>> than would otherwise be the case.
> >>> 
> >>> On my laptop, single-threaded compression actually slows writing
> >>> down from 175MB/s to around 100-120MB/s (depending on how well the
> >>> image compresses). Reading speed improves from 218MB/s to around
> >>> 245MB/s. I expect that multithreaded writing would bring the
> >>> writing (and reading) speeds back up. It's on my swsusp to do list
> >>> :)
> >> 
> >> Testing this now
> >> (2.6.36-rc4-tp42-suspend-next-vmembase-0-00253-gab9b069- dirty).
> > 
> > Two times I had the rather strange issue that the machine booted
> > freshly instead of resuming! First I thought I maybe didn't wait
> > until the image was saved, before turning the laptop off. But now it
> > happened a second time and also the ThinkPad T42 has a battery in
> > it, thus it should always be able to complete writing the image.
> > 
> > For resuming I found this in the syslog:
> > 
> > Oct  4 09:19:10 shambhala kernel: end_request: I/O error, dev fd0,
> > sector 0
> > Oct  4 09:19:10 shambhala kernel: PM: Starting manual resume from
> > disk Oct  4 09:19:10 shambhala kernel: PM: Resume from partition 8:2
> > Oct  4 09:19:10 shambhala kernel: PM: Checking hibernation image.
> > Oct  4 09:19:10 shambhala kernel: PM: Error -22 checking image file
> > Oct  4 09:19:10 shambhala kernel: PM: Resume from disk failed. Oct 
> > 4 09:19:10 shambhala kernel: PM: Marking nosave pages:
> > 000000000009f000 - 0000000000100000
> > Oct  4 09:19:10 shambhala kernel: PM: Basic memory bitmaps created
> > Oct  4 09:19:10 shambhala kernel: PM: Basic memory bitmaps freed
> > 
> > What does error -22 mean?
> 
> -22 is -EINVAL. There are a few reasons that it could occur, but rather
> than chasing our tails, how about if I just tell you that I've been
> working on a new version of the patches that will provide more detailed
> debugging of issues like this (printks that can be enabled/disabled at
> run time) - and hopefully address your issue so it won't happen anyway.

Ok, then I switch back to a stable kernel for the time being.

Please notify me when you have something to test for me.

> > For hibernating:
> > 
> > Oct  4 00:13:09 shambhala ifplugd(eth0)[15127]: Link beat lost.
> > Oct  4 00:13:10 shambhala NetworkManager[2146]:<info>  (eth0):
> > carrier now OFF (device state 1)
[...]
> > Which is not complete. It seems the last log messages prior to
> > hibernating have not fully been written by rsyslog.
> 
> That's not unusual - after we do the atomic copy, nothing gets logged.

I thought so. I think its usually logged after resume?

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
