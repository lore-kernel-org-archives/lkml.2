Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1B0I1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 03:27:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51201 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1B0I1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 03:27:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rz/kI83Pc/wmRalVEEGJp9Q0KJJh+j58fz+ArhpgnrSfsmoEPX8hAxSlCY7ejSeKq7
         1TBxWSJuyyNW4VM728yk06Je7Cz4mLuEUjNgd1QntXgxeLAjehhwSyro2MPrEU3SRztC
         9qCr1lIDcKT8YLfIcAoPk60GtvpQXPd5LqTCE=
MIME-Version: 1.0
In-Reply-To: <1298793252.8726.45.camel@edumazet-laptop>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
	<alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
	<1298793252.8726.45.camel@edumazet-laptop>
Date: Sun, 27 Feb 2011 03:27:45 -0500
Message-ID: <AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
Subject: Re: txqueuelen has wrong units; should be time
From: Albert Cahalan <acahalan@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 2:54 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le dimanche 27 février 2011 à 08:02 +0100, Mikael Abrahamsson a écrit :
>> On Sun, 27 Feb 2011, Albert Cahalan wrote:
>>
>> > Nanoseconds seems fine; it's unlikely you'd ever want
>> > more than 4.2 seconds (32-bit unsigned) of queue.
...
> Problem is some machines have slow High Resolution timing services.
>
> _If_ we have a time limit, it will probably use the low resolution (aka
> jiffies), unless high resolution services are cheap.

As long as that is totally internal to the kernel and never
getting exposed by some API for setting the amount, sure.

> I was thinking not having an absolute hard limit, but an EWMA based one.

The whole point is to prevent stale packets, especially to prevent
them from messing with TCP, so I really don't think so. I suppose
you do get this to some extent via early drop.
