Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0EXP7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:59:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64166 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab0EXP7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bFXtszfifqiq8Hsbko1QlBjHOsieJhYzhjwxdX+mBLEL5rJrjJuOtDoQva06g6t5f2
         K1kTAzgdc9UM0PaxVeaFip7Nmla5ycOPefHgrfHbSR74G7qXE+HxVoRfO4RS9//g8bWq
         sCYyJak6xJcALdTAJNFKh1hpBKj/jIWiKUe9A=
Date: Mon, 24 May 2010 08:59:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>,
       Henrik Rydberg <rydberg@euromail.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
Message-ID: <20100524155901.GB3182@core.coreip.homeip.net>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
 <20100519023727.GA21030@barra.bne.redhat.com>
 <4BF3D59E.1070801@euromail.se>
 <20100520001323.GA28116@barra.bne.redhat.com>
 <4BF51188.3090608@euromail.se>
 <20100524045855.GC16369@barra>
 <AANLkTimTChXjbDL0NAxoNu-Ld7AGDezfsvIHwjKuKt1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimTChXjbDL0NAxoNu-Ld7AGDezfsvIHwjKuKt1A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 11:07:27PM -0700, Ping Cheng wrote:
> On Sun, May 23, 2010 at 9:58 PM, Peter Hutterer
> <peter.hutterer@who-t.net> wrote:
> >> > And yes, you could add it once we find it's an issue, but by then someone
> >> > has already spent time to work around this. And when you then start sending
> >> > slot events all the time, you admit that writing the workaround was just a
> >> > time waster :)
> >>
> >> Work around what, exactly?
> >
> > I was referring to having a protocol where processes has to ignore contacts
> > already down until they've been there when a contact was pressed (and your
> > comment that if this becomes an issue it could be added lateron).
> > Now, the ignoring part needs to be written (this is the "workaround"
> > referred to above). if you're planning to add it later, we need to cater for
> > that part as well then, having two implementations depending on the kernel
> > versions.
> >
> > but this is just for clarification, it's a moot point anyway given that
> > button events have the same behaviour.
> 
> This topic is outside of the _MT_ protocol discussion.
> 
> However, it is indeed an issue with all filtered input events, both
> for MT and regular ones.
> 
> I think we need to add an ioctl to enable user land driver/client to
> signal the kernel driver to send all events without filtering, just
> once. Hot-plugged devices and X driver starts after user has contacted
> with the device are two examples that the client would miss filtered
> events.
> 
> Dmitry, do you think it is a valid suggestion?
>

What about using EVIOCGKEY/EVIOCGSW/EVIOCGABS?

-- 
Dmitry
