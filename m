Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab0LIAGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 19:06:48 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59141 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0LIAGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 19:06:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hHHOVJefp+qjRjYMiATBjQio3QANkutZ2Sayzzop8QUOKEWp5F4GBYOKGNIKn+wAUy
         MivBMBGkX9UN4/Kglw1yLoaRbtb7aPwAYY+nIE7jd4t/j4ew8nW3PvonwbUaJrVKLRfv
         jRXBv4Eb3eEwrT9aFhDfqWgR90xD4lPua6Tlk=
MIME-Version: 1.0
In-Reply-To: <20101208235805.GE15294@core.coreip.homeip.net>
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se>
	<4CFFC3C2.1080905@canonical.com>
	<AANLkTikmomm2hd7AAJMTnY+=J2wPyVvodv2Ft0jFe7w2@mail.gmail.com>
	<20101208235805.GE15294@core.coreip.homeip.net>
Date: Wed, 8 Dec 2010 16:06:45 -0800
Message-ID: <AANLkTink9aX=dV-+n5=2BpPF34kSZGSQQ6x2tUNJ8eSM@mail.gmail.com>
Subject: Re: [PATCH] input: mt: Add an envelope tool type
From: Ping Cheng <pinglinux@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 3:58 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Dec 08, 2010 at 03:43:51PM -0800, Ping Cheng wrote:
>> On Wed, Dec 8, 2010 at 9:43 AM, Chase Douglas
>> <chase.douglas@canonical.com> wrote:
>> > On 12/07/2010 03:29 AM, Henrik Rydberg wrote:
>> >> Some touch devices are capable of detecting the envelope or hull
>> >> of the touches, but not the touches themselves. This patch adds
>> >> the MT_TOOL_ENVELOPE touch type to be used for such devices.
>> >>
>> >> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>> >> ---
>> >> Hi all,
>> >>
>> >> This patch represents an MT solution for those devices that can detect
>> >> and report some effects of dual touch, but cannot report individual
>> >> contacts. Synaptics and elantech are two examples. Having the drivers
>> >> report the bounding rectangle of the touches is useful in userland,
>> >> since the information makes it possible to implement zooming
>> >> gestures. At the same time, it would be confusing to send these
>> >> envelope points as fingers, since they clearly are not. As a remedy,
>> >> introduce MT_TOOL_ENVELOPE, which tells applications that care about
>> >> details that these are not real fingers, at the same time as it allows
>> >> gesture applications based on MT data to function without
>> >> modification.
>> >
>> > Is it assumed that the envelop has only two touches comprising it? Or is
>> > it any number of touches? If it's any number of touches, how does one
>> > know how many touches it is?
>>
>> Those are good questions. Specifying how many touches are in the
>> envelop makes sense. It also covers rectangle as a special case of
>> envelop.
>
> I have a feeling that trying to accomodate non-rectangular,

No, we are not talking about non-rectangular shape here. Envelop is
always a rectangle. By rectangle above, I meant 2 touches.

An envelop that includes number of touches offers us more information
than a rectangle does.

Ping

> more than 2 point shapes without using native MT data is over-engineering the
> problem... Do we have examples other than older generation Elantechs and
> Synaptics that need envelope notion?
>
> --
> Dmitry
>
