Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab0LGMkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:40:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab0LGMka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:40:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
Date: Tue, 7 Dec 2010 13:40:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se> <20101207091653.GA22416@core.coreip.homeip.net> <AANLkTimnSsfCG0WtDpa-qEu3N1uMOeo+CzzZ8wsaZN1v@mail.gmail.com>
In-Reply-To: <AANLkTimnSsfCG0WtDpa-qEu3N1uMOeo+CzzZ8wsaZN1v@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012071340.26244.arnd@arndb.de>
X-Provags-ID: V02:K0:uDLc5JPs+L7DU7gFapAQT9s4bQtwmrr9LnhrUk9qT8Y
 P3BmUtJQiyYT7Tqsx0LasBlD5RXmZiMGCwky+odugxpV8Rky44
 wZ8k5R3hCe/bJFR78y+ssBhqQWDuEBKF4LQW8MZGausMrxco1y
 2m0HoFZQtmZbkiQ6/oLDXbfukkNXVxBb7tJURcCg3OGapQtl1g
 QDDv1YzBnOFJ07V8dKDBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 December 2010, Kay Sievers wrote:
> On Tue, Dec 7, 2010 at 10:16, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > Hi Henrik,
> >
> > On Tue, Dec 07, 2010 at 08:25:26AM +0100, Henrik Rydberg wrote:
> >> Today, userspace sets up an input device based on the data it emits.
> >> This is not always enough; a tablet and a touchscreen may emit exactly
> >> the same data, for instance, but the former should be set up with a
> >> pointer whereas the latter does not need to. Recently, a new type of
> >> touchpad has emerged where the buttons are under the pad, which changes
> >> handling logic without changing the emitted data. This patch introduces
> >> a new ioctl, EVIOCGDEVINFO, which allows userspace to extract information
> >> about the device resulting in proper setup.
> >
> > If we agree that the new ioctl is suitable we'llalso need to wireit up
> > through sysfs. Also, can we keep all definitions to INPUT_ namespace?
> 
> Please don't add new ioctls which are not extensible. The ioctl should
> carry the length or the version of the structure it asks for, so it
> can be extended in the future. Sysfs should be good enough for such
> interface though.

Please never add any ioctls that have a version or length field!

Ideally ioctls should have only scalar arguments, not structures,
so I'd recommend splitting it into two, so you can read type and
capability parameters separately.

	Arnd
