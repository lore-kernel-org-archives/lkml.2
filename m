Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1AKLJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:09:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60865 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab1AKLJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:09:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=htJ8LriMSyk9OgczEMWqnmrZKPnXibFFFNxun+C9ulVQdDZFgYXhMnrj/JkW4Yz6pz
         FrssB1V3sDBUQytgl4I2Bhr7bGZ/ame+qHK0J1z5ACvyCnhW+IxJSx8sbQRaxbzHj4Sm
         VVeyl26Paqoroqx8NfO1vYa9ZAgZEJUcfHNO8=
Date: Tue, 11 Jan 2011 12:09:48 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V8 02/13] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <20110111110948.GA5279@riccoc20.at.omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
 <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com>
 <20110108175028.GA22308@riccoc20.at.omicron.at>
 <AANLkTikigXGSACF6R6kfNHyKZ7GFWrUrCMxygvL3fUC6@mail.gmail.com>
 <20110110071759.GA4864@riccoc20.at.omicron.at>
 <AANLkTimS0-ih=WZ_GvPi9NFjbYMT4OctWV943ri4GuTD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimS0-ih=WZ_GvPi9NFjbYMT4OctWV943ri4GuTD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 05:47:13AM +0900, Kuwahara,T. wrote:
> On Mon, Jan 10, 2011 at 4:17 PM, Richard Cochran
> <richardcochran@gmail.com> wrote:
> > the PTP Hardware Clocks for which this whole patch
> > set was created in the first place will keep their time as TAI.
> 
> Are you sure of that?

Yes.

> I don't have the standard handy (it's non-free, right?) but it seems
> that the Annex B states differently.

IEEE Std 1588-2008, Page 41:

        The timescale PTP: In normal operation, the epoch is the PTP
        epoch and the timescale is continuous; see 7.2.4. The unit of
        measure of time is the SI second as realized on the rotating
        geoid.

IEEE Std 1588-2008, Page 42:

        The PTP epoch is 1 January 1970 00:00:00 TAI, which is 31
        December 1969 23:59:51.999918 UTC.

The standard does permit using some other, arbitrary timescale, "set
by an administrative procedure." But no other timescales are
standardized by 1588.

> But that's not the point anyway.  My concern is that your patch not
> only adds the useless (and broken) feature to the existing syscall
> but also makes a permanent change to the public interface for your
> own use.

It is neither useless or broken. Using the new interface, you can
estimate offset and frequency for a few seconds and jump directly into
a closely synchronized state (like within 100 nanoseconds) relative to
another clock on the network. That is pretty useful.

Your issue with leap seconds is really a non-issue. The time value of
the ADJ_SETOFFSET mode is a time interval, *not* an absolute time.

>  That's what I'm against.  So if you stop touching the struct timex,
> I won't complain anymore.

I have no love for the timex interface. However, I used it for the new
syscall because Arnd Bergmann and John Stultz specifically asked for
it. Also, several other people have reviewed the new call without
objecting to the new mode.

Richard
