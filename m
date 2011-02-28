Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1B1RTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:19:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57683 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1B1RTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:19:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oaVpPklHPi7rEgNDEYnMj8tdQkStD6gfWax8U9OdZ2TpEaajqvmnysyRIGCEvs9Jej
         38SjVgHchONeNiSnYLFFwlp0fglovTHYcZCxrXgY7Nn/0wRn/6+8X8B6SGhulaz2HpcE
         OLjFfnk0N7RRRz84Ft9MSQ7b9sxSqouWHHW8Q=
Subject: Re: txqueuelen has wrong units; should be time
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Albert Cahalan <acahalan@gmail.com>,
        Mikael Abrahamsson <swmike@swm.pp.se>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <20110228165501.GC2515@tuxdriver.com>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
	 <alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
	 <1298793252.8726.45.camel@edumazet-laptop>
	 <AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
	 <20110227125540.40754c5y78j9u2m8@hayate.sektori.org>
	 <1298837273.8726.128.camel@edumazet-laptop>
	 <20110228161115.GB2515@tuxdriver.com>
	 <1298911694.2941.639.camel@edumazet-laptop>
	 <20110228165501.GC2515@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 18:18:23 +0100
Message-ID: <1298913503.2941.718.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 28 février 2011 à 11:55 -0500, John W. Linville a écrit :
> On Mon, Feb 28, 2011 at 05:48:14PM +0100, Eric Dumazet wrote:
> > Le lundi 28 février 2011 à 11:11 -0500, John W. Linville a écrit :
> > > On Sun, Feb 27, 2011 at 09:07:53PM +0100, Eric Dumazet wrote:
> > > 
> > > > Qdisc should return to caller a good indication packet is queued or
> > > > dropped at enqueue() time... not later (aka : never)
> > > > 
> > > > Accepting a packet at t0, and dropping it later at t0+limit without
> > > > giving any indication to caller is a problem.
> > > 
> > > Can you elaborate on what problem this causes?  Is it any worse than
> > > if the packet is dropped at some later hop?
> > > 
> > > Is there any API that could report the drop to the sender (at
> > > least a local one) without having to wait for the ack timeout?
> > > Should there be?
> > > 
> > 
> > Not all protocols have ACKS ;)
> > 
> > dev_queue_xmit() returns an error code, some callers use it.
> 
> Well, OK -- I agree it is best if you can return the status at
> enqueue time.  The question becomes whether or not a dropped frame
> is worse than living with high latency.  The answer, of course, still
> seems to be a bit subjective.  But, if the admin has determined that
> a link should be low latency...?
> 

If the latency problem could be solved by an admin choice, it probably
would be there already.

Point is qdisc layer is able to immediately return an error code to
caller, if qdisc handlers properly done. This can help applications to
immediately react to congestion notifications.

Some applications, even running on a "low latency link" can afford a
long delay for their packets. Should we introduce a socket API to give
the upper bound for the limit, or share a global 'per qdisc' limit ?



