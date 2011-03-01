Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1CAELQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 23:11:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34204 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1CAELP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 23:11:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S4AUW/wJvmk03Hl1fEDHdnIK+sZQTVfpA0PCt6sUh1KhhaBhk7WUHpYnAI44wDSnhy
         q7ET410kpBz4T7wnv/rdg4mr74bf6LjnH2jnno4cKBK0GXvDgUNo8vvKaXjgVfNTzDqO
         mRQPao2Hkung8BIrqcO6tOM2yrU/BFYlw9OjM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinj5szpStmA+fZ1xggdyTS+sd8Y9jXaYquDNEjs@mail.gmail.com>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
	<alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
	<1298793252.8726.45.camel@edumazet-laptop>
	<AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
	<20110227125540.40754c5y78j9u2m8@hayate.sektori.org>
	<1298837273.8726.128.camel@edumazet-laptop>
	<20110228161115.GB2515@tuxdriver.com>
	<1298911694.2941.639.camel@edumazet-laptop>
	<20110228165501.GC2515@tuxdriver.com>
	<AANLkTinj5szpStmA+fZ1xggdyTS+sd8Y9jXaYquDNEjs@mail.gmail.com>
Date: Mon, 28 Feb 2011 23:11:13 -0500
Message-ID: <AANLkTinFZu5AgfhO6PoA7C1NTGSfD8HH0KXq_o-mHEJF@mail.gmail.com>
Subject: Re: txqueuelen has wrong units; should be time
From: Albert Cahalan <acahalan@gmail.com>
To: John Heffner <johnwheffner@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Mikael Abrahamsson <swmike@swm.pp.se>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 4:45 PM, John Heffner <johnwheffner@gmail.com> wrote:
> On Mon, Feb 28, 2011 at 11:55 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Mon, Feb 28, 2011 at 05:48:14PM +0100, Eric Dumazet wrote:
>>> Le lundi 28 février 2011 à 11:11 -0500, John W. Linville a écrit :
>>> > On Sun, Feb 27, 2011 at 09:07:53PM +0100, Eric Dumazet wrote:

>>> > > Qdisc should return to caller a good indication packet is queued or
>>> > > dropped at enqueue() time... not later (aka : never)
>>> > >
>>> > > Accepting a packet at t0, and dropping it later at t0+limit without
>>> > > giving any indication to caller is a problem.
>>> >
>>> > Can you elaborate on what problem this causes?  Is it any worse than
>>> > if the packet is dropped at some later hop?
>>> >
>>> > Is there any API that could report the drop to the sender (at
>>> > least a local one) without having to wait for the ack timeout?
>>> > Should there be?
>>>
>>> Not all protocols have ACKS ;)
>>>
>>> dev_queue_xmit() returns an error code, some callers use it.
>>
>> Well, OK -- I agree it is best if you can return the status at
>> enqueue time.  The question becomes whether or not a dropped frame
>> is worse than living with high latency.  The answer, of course, still
>> seems to be a bit subjective.  But, if the admin has determined that
>> a link should be low latency...?
>
> Notably, TCP is one caller that uses the error code.  The error code
> is functionally equivalent to ECN, one of whose great advantages is
> reducing delay jitter.  If TCP didn't get the error, that would
> effectively double the latency for a full window of data, since the
> dropped segment would not be retransmitted for an RTT.

It sounds like you need a callback or similar, so that TCP can be
informed later that the drop has occurred.
