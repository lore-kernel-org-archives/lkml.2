Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1GWBNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 21:13:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57035 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab1GWBNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 21:13:15 -0400
Message-ID: <4E2A2024.9050502@canonical.com>
Date: Fri, 22 Jul 2011 18:13:08 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: djkurtz@chromium.org
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 0/9 v2] Synaptics image sensor support
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2011 06:38 AM, djkurtz@chromium.org wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> Patches 4-7 add up to 3 finger support for image sensor touchpads.
> Image sensors do not suffer from the finger tracking issues that plagued
> the earlier "profile sensors", and which required the invention of "semi-mt"
> (Semi-mt reports a bounding box around two fingers instead of the fingers
> themselves).  Instead, the image sensors report the actual positions of two
> fingers using the same "Advanced Gesture Mode".  This driver uses two MT-B slots
> to report these two fingers to userspace.  In addition, it will also report
> the total number of fingers using BTN_TOOL_*TAP EV_KEY events.
> Userspace drivers should be aware that the number of fingers reported via
> BTN_TOOL_*TAP can be greater than the total number MT-B slots with non-negative
> track_ids.  Upon opening the device node, userspace should query the maximum
> values supported ABS_MT_SLOT, and note the number of supported BTN_TOOL_*TAP
> events.

I would still rather see a new property bit for devices that track and
report different numbers of touches. I think it is worthwhile to be
explicit here rather than leave it up to voodoo magic in userpace drivers.

This and the touch count transition issue I brought up in a reply to
patch 7 are my only concerns with this part of the patchset.

BTW, I found the commit messages and the code to be very comprehensible.
Good job on cleaning them up!

-- Chase
