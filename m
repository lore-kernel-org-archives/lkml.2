Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab0EXGHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 02:07:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38953 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0EXGH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 02:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nVkhWraWcJM+teni8F2t7/mQKLTgK/e37TDt1o6szCBIgue3Jkq7v/fbVI/y426OZ1
         c4veE+CoVj4a2NyDvJuGcb1tygtT+w/0+CA+3qSLz46UpjUEo2FdfAyS0+acH/HEidqW
         DxregFPMyLHJgNVxqk6Hf0TN/7erpO7Rjf58U=
MIME-Version: 1.0
In-Reply-To: <20100524045855.GC16369@barra>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
	 <20100519023727.GA21030@barra.bne.redhat.com>
	 <4BF3D59E.1070801@euromail.se>
	 <20100520001323.GA28116@barra.bne.redhat.com>
	 <4BF51188.3090608@euromail.se> <20100524045855.GC16369@barra>
Date: Sun, 23 May 2010 23:07:27 -0700
Message-ID: <AANLkTimTChXjbDL0NAxoNu-Ld7AGDezfsvIHwjKuKt1A@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
From: Ping Cheng <pinglinux@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 9:58 PM, Peter Hutterer
<peter.hutterer@who-t.net> wrote:
>> > And yes, you could add it once we find it's an issue, but by then someone
>> > has already spent time to work around this. And when you then start sending
>> > slot events all the time, you admit that writing the workaround was just a
>> > time waster :)
>>
>> Work around what, exactly?
>
> I was referring to having a protocol where processes has to ignore contacts
> already down until they've been there when a contact was pressed (and your
> comment that if this becomes an issue it could be added lateron).
> Now, the ignoring part needs to be written (this is the "workaround"
> referred to above). if you're planning to add it later, we need to cater for
> that part as well then, having two implementations depending on the kernel
> versions.
>
> but this is just for clarification, it's a moot point anyway given that
> button events have the same behaviour.

This topic is outside of the _MT_ protocol discussion.

However, it is indeed an issue with all filtered input events, both
for MT and regular ones.

I think we need to add an ioctl to enable user land driver/client to
signal the kernel driver to send all events without filtering, just
once. Hot-plugged devices and X driver starts after user has contacted
with the device are two examples that the client would miss filtered
events.

Dmitry, do you think it is a valid suggestion?

I've had this issue for ages (but never had time to work on it :(.

Ping
