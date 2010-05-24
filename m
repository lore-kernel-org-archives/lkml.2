Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab0EXRWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:22:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53051 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044Ab0EXRWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:22:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=kl1hkKOD4MC6G3ZLeJmtKebOfdtcyXY9ahzZyTlF6bbldtb+X2K+/SmKxxglDQJM77
         ZhCqBQxluSPbqVaYFXG4OtQbUp/amz88MjSWop7ckEdeYxWrEFyEk6cnGbHctnJ4pPa6
         NlRNr7uo54TL6raM/Rj3100Scl9mZgMxm8Mjg=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
Date: Mon, 24 May 2010 10:21:02 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32.12-115.fc12.x86_64; KDE/4.4.2; x86_64; ; )
Cc: Peter Hutterer <peter.hutterer@who-t.net>,
       Henrik Rydberg <rydberg@euromail.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se> <20100524155901.GB3182@core.coreip.homeip.net> <AANLkTin9ahtqL7jrUP4C0zF9-P3rUg7ktN93-hcqdDnj@mail.gmail.com>
In-Reply-To: <AANLkTin9ahtqL7jrUP4C0zF9-P3rUg7ktN93-hcqdDnj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005241021.02731.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 May 2010 10:06:15 am Ping Cheng wrote:
> On Mon, May 24, 2010 at 8:59 AM, Dmitry Torokhov
> 
> <dmitry.torokhov@gmail.com> wrote:
> > On Sun, May 23, 2010 at 11:07:27PM -0700, Ping Cheng wrote:
> >> On Sun, May 23, 2010 at 9:58 PM, Peter Hutterer
> >> 
> >> <peter.hutterer@who-t.net> wrote:
> >> >> > And yes, you could add it once we find it's an issue, but by then
> >> >> > someone has already spent time to work around this. And when you
> >> >> > then start sending slot events all the time, you admit that
> >> >> > writing the workaround was just a time waster :)
> >> >> 
> >> >> Work around what, exactly?
> >> > 
> >> > I was referring to having a protocol where processes has to ignore
> >> > contacts already down until they've been there when a contact was
> >> > pressed (and your comment that if this becomes an issue it could be
> >> > added lateron). Now, the ignoring part needs to be written (this is
> >> > the "workaround" referred to above). if you're planning to add it
> >> > later, we need to cater for that part as well then, having two
> >> > implementations depending on the kernel versions.
> >> > 
> >> > but this is just for clarification, it's a moot point anyway given
> >> > that button events have the same behaviour.
> >> 
> >> This topic is outside of the _MT_ protocol discussion.
> >> 
> >> However, it is indeed an issue with all filtered input events, both
> >> for MT and regular ones.
> >> 
> >> I think we need to add an ioctl to enable user land driver/client to
> >> signal the kernel driver to send all events without filtering, just
> >> once. Hot-plugged devices and X driver starts after user has contacted
> >> with the device are two examples that the client would miss filtered
> >> events.
> >> 
> >> Dmitry, do you think it is a valid suggestion?
> > 
> > What about using EVIOCGKEY/EVIOCGSW/EVIOCGABS?
> 
> Those EVIOCs only give us the static values (max/min/supported keys,
> etc.).  We need their dynamic input data here, the actual x, y,
> button, pressure, etc. Am I missing something about those EVIOs?
> 

Yes you are ;) Supported events are reported via EVIOCGBIT, EVIOCGKEY and
EVIOCGSW will return current state of keys/switches. As far as EVIOCGABS
goes, it also returns, besides min/max/etc, last reported _values_ of the
ABS_* events.

-- 
Dmitry
