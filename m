Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab0LUSGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:06:11 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:62221 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0LUSGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:06:09 -0500
MIME-Version: 1.0
In-Reply-To: <20101221165956.GA28702@polaris.bitmath.org>
References: <1292852364-19127-1-git-send-email-rydberg@euromail.se>
	<1292852364-19127-3-git-send-email-rydberg@euromail.se>
	<4D10D75D.80400@canonical.com>
	<20101221165956.GA28702@polaris.bitmath.org>
Date: Tue, 21 Dec 2010 12:06:08 -0600
Message-ID: <AANLkTi=rxBMDB+JKLY9A4iMZEtCBGNhfJxAERMb4CEjR@mail.gmail.com>
Subject: Re: [PATCH 2/3] Input: synaptics - add multi-finger and semi-mt support
From: Chris Bagwell <chris@cnpbagwell.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 10:59 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > Reported-by: Tobyn Bertram
>> > Not-yet-signed-off-by: Takashi Iwai <tiwai@suse.de>
>> > Not-yet-signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>> > Not-yet-signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
>> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>>
>> You can keep my SOB.
>
> Great, thanks.
>
>> > +static void set_slot(struct input_dev *dev, int slot, bool active, int x, int y)
>> > +{
>> > +   input_mt_slot(dev, slot);
>> > +   input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
>> > +   if (active) {
>> > +           input_report_abs(dev, ABS_MT_POSITION_X, x);
>> > +           input_report_abs(dev, ABS_MT_POSITION_Y,
>> > +                            YMAX_NOMINAL + YMIN_NOMINAL - y);
>> > +   }
>> > +}
>>
>> I take it that you feel MT_TOOL_FINGER should always be set, even if
>> it's always the same as BTN_TOOL_*? I just want to be sure this is
>> intended so we document it appropriately.
>
> Yes - the MT_TOOLs are only emitted when explicitly set in absbit, but
> the internal interface always handles it. This is actually documented
> in the code (and DocBook).

That note is good guidance for developer side.  Its also worth noting
on app side that MT_TOOL_FINGER is a little special since its value is
0.  In most common case, I think it will get filtered out where as
BTN_TOOL_FINGER will always be sent.

Since we can't yet query per slot ABS_MT_TOOL_TYPE, I guess apps have
to just assume its a finger unless told otherwise?

Chris
