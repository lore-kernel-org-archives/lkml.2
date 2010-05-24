Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0EXRdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:33:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35379 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab0EXRdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RM3sMqmJsd4JwNEogmbOwVIgckfn3pxlqgtu55Tg4Begd2R34Csx3qFoRoAsdl3Goa
         VHxKcDAUQRx50E5xnBH5ZxHKv5P5mhNtR0zXPajWf4223l4G6qmO30jazvNZGjj8BC6R
         nmANguAj0YVDKby20AjMYjOKNGZ5n5vUi1kHs=
MIME-Version: 1.0
In-Reply-To: <201005241021.02731.dmitry.torokhov@gmail.com>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
	 <20100524155901.GB3182@core.coreip.homeip.net>
	 <AANLkTin9ahtqL7jrUP4C0zF9-P3rUg7ktN93-hcqdDnj@mail.gmail.com>
	 <201005241021.02731.dmitry.torokhov@gmail.com>
Date: Mon, 24 May 2010 10:33:05 -0700
Message-ID: <AANLkTinh9OARrU-Lk9D_c-hP8c4Ke0OvWUqJltd7hDEo@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
From: Ping Cheng <pinglinux@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>,
       Henrik Rydberg <rydberg@euromail.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 10:21 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Monday 24 May 2010 10:06:15 am Ping Cheng wrote:
>> >> This topic is outside of the _MT_ protocol discussion.
>> >>
>> >> However, it is indeed an issue with all filtered input events, both
>> >> for MT and regular ones.
>> >>
>> >> I think we need to add an ioctl to enable user land driver/client to
>> >> signal the kernel driver to send all events without filtering, just
>> >> once. Hot-plugged devices and X driver starts after user has contacted
>> >> with the device are two examples that the client would miss filtered
>> >> events.
>> >>
>> >> Dmitry, do you think it is a valid suggestion?
>> >
>> > What about using EVIOCGKEY/EVIOCGSW/EVIOCGABS?
>>
>> Those EVIOCs only give us the static values (max/min/supported keys,
>> etc.).  We need their dynamic input data here, the actual x, y,
>> button, pressure, etc. Am I missing something about those EVIOs?
>>
>
> Yes you are ;) Supported events are reported via EVIOCGBIT, EVIOCGKEY and
> EVIOCGSW will return current state of keys/switches. As far as EVIOCGABS
> goes, it also returns, besides min/max/etc, last reported _values_ of the
> ABS_* events.

Oh, My God! I should have listened to Mark Twain :).

Ping
