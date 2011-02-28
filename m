Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab1B1Vve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:51:34 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54921 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1B1Vvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:51:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LHP4v/HIpV0qEkSM59Tj4l7gYPSBBKR6b0CBOoIBbbtosskioH1sUYYFGr/ZKAhWgo
         CH1wFNBAeQ0oXDI7EaxxxireOh0UDP6QSuBt13ob+vfOvS8jfpNAHM/n7xrTby6pcNug
         XO91XvhwS73tuTIwP4i/cxU0bRzpjOKXeWcpY=
MIME-Version: 1.0
In-Reply-To: <AANLkTikje6rvjSfEA3CvUjdgFwzk-SBZDdO5kQvi6LZy@mail.gmail.com>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
	<alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
	<1298793252.8726.45.camel@edumazet-laptop>
	<AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
	<20110227125540.40754c5y78j9u2m8@hayate.sektori.org>
	<AANLkTimofhhH5omyk=HhkyaNG+MGqoac4rDf=dPuR7K-@mail.gmail.com>
	<cbb9e1113901f1a324359b6ed3f1a611@localhost>
	<AANLkTikje6rvjSfEA3CvUjdgFwzk-SBZDdO5kQvi6LZy@mail.gmail.com>
Date: Mon, 28 Feb 2011 16:51:29 -0500
Message-ID: <AANLkTin_jY_J7tJseMLVmrQVVRezOVQTGCgB_6tefgXJ@mail.gmail.com>
Subject: Re: txqueuelen has wrong units; should be time
From: John Heffner <johnwheffner@gmail.com>
To: Bill Sommerfeld <wsommerfeld@google.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>, Albert Cahalan <acahalan@gmail.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mikael Abrahamsson <swmike@swm.pp.se>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right... while I generally agree that a fixed-length drop-tail queue
isn't optimal, isn't this problem what the various AQM schemes try to
solve?

  -John


On Mon, Feb 28, 2011 at 12:20 PM, Bill Sommerfeld
<wsommerfeld@google.com> wrote:
> On Mon, Feb 28, 2011 at 07:38, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
>> On Sun, 27 Feb 2011 18:33:39 -0500, Albert Cahalan wrote:
>>> I suppose there is a need to allow at least 2 packets despite any
>>> time limits, so that it remains possible to use a traditional modem
>>> even if a huge packet takes several seconds to send.
>>
>> That is a good point! We talk about as we may know every use case of
>> Linux. But this is not true at all. One of my customer for example operates
>> the Linux network stack functionality on top of a proprietary MAC/Driver
>> where the current packet queue characteristic is just fine. The
>> time-drop-approach is unsuitable because the bandwidth can vary in a small
>> amount of time over a great range (0 till max. bandwidth). A sufficient
>> buffering shows up superior in this environment (only IPv{4,6}/UDP).
>
> The tension is between the average queue length and the maximum amount
> of buffering needed.  Fixed-sized tail-drop queues -- either long, or
> short -- are not ideal.
>
> My understanding is that the best practice here is that you need
> (bandwidth * path delay) buffering to be available to absorb bursts
> and avoid drops, but you also need to use queue management algorithms
> with ECN or random drop to keep the *average* queue length short;
> unfortunately, researchers are still arguing about the details of the
> second part...
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
