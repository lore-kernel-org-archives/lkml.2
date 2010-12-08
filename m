Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab0LHXnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:43:55 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64355 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab0LHXnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:43:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l71Ucdb4mDQGwR9WXGi+I6oh20dT5eRul1zr+unTsCalkahlEvIeK2bdTAgYmaYbxo
         G/HpYe1+zfaTOB2QladAcm+2xWoSSY1rcithtWe94yKn4aI3HzwgfFIfXrqsMT8fUbOW
         PmFAzke5ixPeziiVyAzrt5lsrGdxI9ybMYCk0=
MIME-Version: 1.0
In-Reply-To: <4CFFC3C2.1080905@canonical.com>
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se>
	<4CFFC3C2.1080905@canonical.com>
Date: Wed, 8 Dec 2010 15:43:51 -0800
Message-ID: <AANLkTikmomm2hd7AAJMTnY+=J2wPyVvodv2Ft0jFe7w2@mail.gmail.com>
Subject: Re: [PATCH] input: mt: Add an envelope tool type
From: Ping Cheng <pinglinux@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 9:43 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On 12/07/2010 03:29 AM, Henrik Rydberg wrote:
>> Some touch devices are capable of detecting the envelope or hull
>> of the touches, but not the touches themselves. This patch adds
>> the MT_TOOL_ENVELOPE touch type to be used for such devices.
>>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>> ---
>> Hi all,
>>
>> This patch represents an MT solution for those devices that can detect
>> and report some effects of dual touch, but cannot report individual
>> contacts. Synaptics and elantech are two examples. Having the drivers
>> report the bounding rectangle of the touches is useful in userland,
>> since the information makes it possible to implement zooming
>> gestures. At the same time, it would be confusing to send these
>> envelope points as fingers, since they clearly are not. As a remedy,
>> introduce MT_TOOL_ENVELOPE, which tells applications that care about
>> details that these are not real fingers, at the same time as it allows
>> gesture applications based on MT data to function without
>> modification.
>
> Is it assumed that the envelop has only two touches comprising it? Or is
> it any number of touches? If it's any number of touches, how does one
> know how many touches it is?

Those are good questions. Specifying how many touches are in the
envelop makes sense. It also covers rectangle as a special case of
envelop.

Ping

> How are the envelop shape and position determined?
>
> I think the idea is good, I just don't have enough information to
> understand how the tool type is supposed to be used. This has been an
> issue with many evdev properties, so I'm hoping we can provide more
> detailed documentation this time around :).
>
> -- Chase
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
