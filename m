Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab0LRQ4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 11:56:01 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53478 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab0LRQ4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 11:56:00 -0500
MIME-Version: 1.0
In-Reply-To: <1292683981-6908-2-git-send-email-rydberg@euromail.se>
References: <1292683981-6908-1-git-send-email-rydberg@euromail.se>
	<1292683981-6908-2-git-send-email-rydberg@euromail.se>
Date: Sat, 18 Dec 2010 10:55:59 -0600
Message-ID: <AANLkTimrNrfTXGh675_8zhOg_+9+NKgOmzJq9rafyh+6@mail.gmail.com>
Subject: Re: [PATCH 1/4] Input: synaptics - add multitouch packet support
From: Chris Bagwell <chris@cnpbagwell.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 8:52 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> From: Chase Douglas <chase.douglas@canonical.com>
>
> Synaptics 2.7 series of touchpads support a mode for reporting 2 sets
> of X/Y/Pressure data (multi-touch).  These same devices default mode
> report single finger data and do not report finger counts.
>
> Enabling MT mode makes finger count reporting start working in same
> fashion as touchpads that claim that capability. Up to three fingers
> can be reported this way.
>
> While in MT mode and two or three fingers are touching, two sets of
> data are sent.  The first is a new format buffer with lower resolution
> reporting of stationary finger and the second is standard data format
> reporting movement.

We should probably update this comment and remove parts that mention
stationary and movement.  It appears to be doing finger tracking and
first packet is always first touch... except we are getting reports
that clickpads/integrated button pads may not be consistently like
this.

This tracking is partly why type B protocol is being used in later patches.

Chris
