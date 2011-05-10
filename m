Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1EJLIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:08:31 -0400
Received: from smtpout06.highway.telekom.at ([195.3.96.89]:21757 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752213Ab1EJLIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:08:30 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: i915/kms/backlight-combo mode problem
Date: Tue, 10 May 2011 13:08:23 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.5; KDE/4.6.2; x86_64; ; )
Cc: Michael Chang <mchang@novell.com>, Joey Lee <jlee@novell.com>,
        chris@chris-wilson.co.uk, dri-devel@lists.freedesktop.org,
        tiwai@suse.de
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <BANLkTimtvAWeS-t3bWjJmdVtyaPDw2uWDA@mail.gmail.com> <BANLkTi=hUBrKnbrF+Q_ZOxdUPVSOUYUm2Q@mail.gmail.com>
In-Reply-To: <BANLkTi=hUBrKnbrF+Q_ZOxdUPVSOUYUm2Q@mail.gmail.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105101308.24662@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Chang -- Tuesday 10 May 2011:
> Could you please try this patch and get the log ? We wonder why
> is_backlight_combination_mode () returns false.

This information was already buried in the bugzilla thread:

  https://bugzilla.kernel.org/show_bug.cgi?id=31522
  "It turned out that on this machine INTEL_INFO(dev)->gen equals 4,
  and is_backlight_combination_mode() returns 0x40000000."


But to say it again in your words:   :-)

  [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824  (0x40000000)

6x during boot-up, and several times later when changing the backlight
brightness.


This was with 8b061610dac3a3b89770c85ad63b481a47b0c38e. And now
I have a little shocker for you (and me): because this was a
vanilla kernel (apart from these debug messages), the screen went
black again, like I knew it. But pressing the "brightness down"
key turns the backlight on! I can't believe that I haven't tested
that. I guess I've only tried "brightness up" and "display toggle".
Those don't turn backlight on. Or maybe somethine else relevant
meanwhile changed in the i915 drivers. (I've regularly been
updating to HEAD.)  

So, the problem was just the initial state all the time?

m.
