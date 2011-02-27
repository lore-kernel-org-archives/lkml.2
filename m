Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab1B0HyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 02:54:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45941 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1B0HyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 02:54:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GY2StMiLlId6N3nm8vqJ3rObGfJxOyvV+OyI0NJFi7L4stVOmKzsgY7QSXDodxw0oc
         QyH/wnlXcZTUbfSZQPip7b/LVJABvL+kpwfusu5czutxTBY+MGkgdD+hpgENC3hO6H0b
         EaFJT3VthJrCvdav1E/HhoffvpuV7oDG3zchI=
Subject: Re: txqueuelen has wrong units; should be time
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Albert Cahalan <acahalan@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
	 <alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Feb 2011 08:54:12 +0100
Message-ID: <1298793252.8726.45.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 27 février 2011 à 08:02 +0100, Mikael Abrahamsson a écrit :
> On Sun, 27 Feb 2011, Albert Cahalan wrote:
> 
> > Nanoseconds seems fine; it's unlikely you'd ever want
> > more than 4.2 seconds (32-bit unsigned) of queue.
> 
> I think this is shortsighted and I'm sure someone will come up with a case 
> where 4.2 seconds isn't enough. Let's not build in those kinds of 
> limitations from start.
> 
> Why not make it 64bit and go to picoseconds from start?
> 
> If you need to make it 32bit unsigned, I'd suggest to start from 
> microseconds instead. It's less likely someone would want less than a 
> microsecond of queue, than someone wanting more than 4.2 seconds of queue.
> 

32 or 64 bits doesnt matter a lot. At Qdisc stage we have up to 40 bytes
available in skb->sb[] for our usage.

Problem is some machines have slow High Resolution timing services.

_If_ we have a time limit, it will probably use the low resolution (aka
jiffies), unless high resolution services are cheap.

I was thinking not having an absolute hard limit, but an EWMA based one.



