Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab0EXRGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:06:20 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59769 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab0EXRGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NeIZ8wudqcvyJIjOA3ZwQ4G9CdH4B55AQzuNosh6bwO4EOXiR/wIep+bqHUX9rt5Pn
         4r7OuS0zj6NCzzf73NVnRkQbYN4iJTblGOD3YEVpSEQfY95EF20Ne/oB3XFC8wkI/sNY
         pHxg+VyxZi+fosuenQPB7sZZKkrDpd4DPuHN0=
MIME-Version: 1.0
In-Reply-To: <20100524155901.GB3182@core.coreip.homeip.net>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
	 <20100519023727.GA21030@barra.bne.redhat.com>
	 <4BF3D59E.1070801@euromail.se>
	 <20100520001323.GA28116@barra.bne.redhat.com>
	 <4BF51188.3090608@euromail.se> <20100524045855.GC16369@barra>
	 <AANLkTimTChXjbDL0NAxoNu-Ld7AGDezfsvIHwjKuKt1A@mail.gmail.com>
	 <20100524155901.GB3182@core.coreip.homeip.net>
Date: Mon, 24 May 2010 10:06:15 -0700
Message-ID: <AANLkTin9ahtqL7jrUP4C0zF9-P3rUg7ktN93-hcqdDnj@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 8:59 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Sun, May 23, 2010 at 11:07:27PM -0700, Ping Cheng wrote:
>> On Sun, May 23, 2010 at 9:58 PM, Peter Hutterer
>> <peter.hutterer@who-t.net> wrote:
>> >> > And yes, you could add it once we find it's an issue, but by then someone
>> >> > has already spent time to work around this. And when you then start sending
>> >> > slot events all the time, you admit that writing the workaround was just a
>> >> > time waster :)
>> >>
>> >> Work around what, exactly?
>> >
>> > I was referring to having a protocol where processes has to ignore contacts
>> > already down until they've been there when a contact was pressed (and your
>> > comment that if this becomes an issue it could be added lateron).
>> > Now, the ignoring part needs to be written (this is the "workaround"
>> > referred to above). if you're planning to add it later, we need to cater for
>> > that part as well then, having two implementations depending on the kernel
>> > versions.
>> >
>> > but this is just for clarification, it's a moot point anyway given that
>> > button events have the same behaviour.
>>
>> This topic is outside of the _MT_ protocol discussion.
>>
>> However, it is indeed an issue with all filtered input events, both
>> for MT and regular ones.
>>
>> I think we need to add an ioctl to enable user land driver/client to
>> signal the kernel driver to send all events without filtering, just
>> once. Hot-plugged devices and X driver starts after user has contacted
>> with the device are two examples that the client would miss filtered
>> events.
>>
>> Dmitry, do you think it is a valid suggestion?
>>
>
> What about using EVIOCGKEY/EVIOCGSW/EVIOCGABS?

Those EVIOCs only give us the static values (max/min/supported keys,
etc.).  We need their dynamic input data here, the actual x, y,
button, pressure, etc. Am I missing something about those EVIOs?

Ping
