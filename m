Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab0LNOdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:33:42 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:54830 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0LNOdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:33:41 -0500
MIME-Version: 1.0
In-Reply-To: <20101214043635.GB12059@salty.local>
References: <1292001842-5000-1-git-send-email-rydberg@euromail.se>
	<4D065BDE.5020107@canonical.com>
	<4D068E3C.8080100@euromail.se>
	<4D06A60D.7010409@canonical.com>
	<4D06AB66.8090909@euromail.se>
	<20101214043635.GB12059@salty.local>
Date: Tue, 14 Dec 2010 08:33:39 -0600
Message-ID: <AANLkTinPSkFddbM0dfWp3ROHYgvb7Gx2A_Avudwkoqif@mail.gmail.com>
Subject: Re: [PATCH v2] input: mt: Interface and MT_TOOL documentation updates
From: Chris Bagwell <chris@cnpbagwell.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 10:36 PM, Peter Hutterer
<peter.hutterer@who-t.net> wrote:
> On Tue, Dec 14, 2010 at 12:25:26AM +0100, Henrik Rydberg wrote:
>> >> The envelope contacts serve as a way to detect a small area of fingers or a
>>
>> >> large area of fingers. There is nothing inherently problematic with having one
>> >> or three or more such contacts.
>> >
>> > Then I'm more confused :).
>> >
>> > I see one problem: devices that report two touch points, (X1, Y1) and
>> > (X2, Y2), but in reality the touches could be at (X1, Y2) and (X2, Y1)
>> > instead. Using a rectangle helps resolve this issue for panning and
>> > pinching, though not for rotation.
>>
>>
>> If panning and pinching and rotation could all be recovered properly, then the
>> individual contacts could actually have been reconstructed properly in the first
>> place. This is the whole point - there is not enough information available for
>> rotation to be recovered properly.
>
> can you post an example event stream of the MT_ENVELOPE tool? I'm having
> trouble wrapping my head around it.
>

Patch 2/2 of synaptics patches from Henrik show this in code form but
here is text form.

Its sets up 2 MT slots and start out at (x,y)=(0,0) for both slots
with no fingers touching.  When 1 finger touches, slot 0 shows (x,y)
as reported by hardware and keeps slot 1 at (0,0).  When 2 fingers
touch, slot 0 shows lower left of rectangle and slot 1 shows upper
right corner.  When 3 fingers touch, same thing as 2 fingers.

For 1 finger case, we could send duplicate values of slot 0 into slot
1 but (0,0) is more efficient for more typical 1 finger usage.

The 3 finger case helps show that hardware itself really wants to talk
in terms of rectangles as well, even if they give half hearted
attempts at real multi-touch points.

Since these slots need to be treated as a whole, no tracking id or similar.

Chris
