Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab0LNSje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 13:39:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59188 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351Ab0LNSjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 13:39:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=JHObDMzVfGj+KPEZjjvROAYsekB1IzoNyMf2+oZDEu+BvJXURVG5iM9eR09hGNJ40v
         KPXXv2V5JCI4t+XdLzfXtYHZd4WDg9KGh3A9xLSb2hhbghWuFuGB0fY3JP3x+J8Uv6is
         fMg7OyK1DZpP+uDBo+5tidx+k+xbfHrN3Yc+E=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 14 Dec 2010 10:39:12 -0800
Message-ID: <AANLkTikP+jMHvDgkGTXfq58M7TEBthzuvEFoENXvxyqJ@mail.gmail.com>
Subject: DFS development roadmap 2010-12-14
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Vipin Mehta <Vipin.Mehta@atheros.com>,
        Gery Kahn <geryk@ti.com>, Michael Green <Michael.Green@atheros.com>,
        wireless-regdb@lists.infradead.org,
        Tevfik Yucek <Tevfik.Yucek@atheros.com>,
        Susinder Gulasekaran <Susinder.Gulasekaran@atheros.com>,
        Rich Mosko <Rich.Mosko@atheros.com>,
        Mahboob Alem <Mahboob.Alem@atheros.com>,
        Madhan Jaganathan <Madhan.Jaganathan@atheros.com>,
        Sundar Sankaran <Sundar.Sankaran@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: this is a public e-mail

We had a good IRC session, and were able to at least come up with a
development roadmap to focus on:

http://wireless.kernel.org/en/developers/DFS#Development_roadmap

Some good news is we have a raise in hands by TI to participate in the
development. Things we need to iron out for each development step:

1) Map countries to a DFS region bit

The plan is to map each country in db.txt from wireless-regdb to a DFS
region. There are only 3 known DFS regions:

  * FCC
  * ETSI
  * JP/Telco

Michael, David, do you guys expect this to change any time soon (say
10 years or so)? Anyone else know?

I can work on this.

2) Get DFS region to the driver through cfg80211

This is pretty straight forward once we have 1) done, and I can work on it.

3) Where do we stuff DFS parameters for each region

One idea is to use the request_firmware() API as it is expected these
parameters will be region and chipset specific. This requires a good
review of all chipsets and with priority on the ones who have vendors
or we have documentation for that we want to support in existing
drivers. Today this means Atheros hardware and TI hardware.

Vipin, I am curios how you intend on programming DFS with ath6kl (if
this gets added, we should if TI is doing it ;) ), do you stuff all
DFS parameters in firmware?

Gery, how does TI do it?Most of the work here will involve hooking
things up for mac80211 / cfg80211 / nl80211. This will consists of
receiving DFS events from the driver for radar detection, keeping the
NOL list, sending it to hostapd, choosing a random channel, and
sending CSA to STAs.

4) Program hw DFS parameters

ath9k_hw already has some knobs for this, Felix already submitted some
of these changes upstream. Most of the work required here will take
place on ath9k.

5) DFS events

Most of the work here will involve hooking things up for mac80211 /
cfg80211 / nl80211. This will consists of receiving DFS events from
the driver for radar detection, keeping the NOL list, sending it to
hostapd, choosing a random channel, and sending CSA to STAs. We can
worry about this eventually, once we get the above 4 steps done.

  Luis
