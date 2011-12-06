Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab1LFAHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 19:07:23 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33307 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab1LFAHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 19:07:20 -0500
MIME-Version: 1.0
In-Reply-To: <4EDD01BA.40208@redhat.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com>
	<4EDC9B17.2080701@gmail.com>
	<CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
	<4EDD01BA.40208@redhat.com>
Date: Tue, 6 Dec 2011 01:07:20 +0100
Message-ID: <CAJbz7-1S6K=sDJFcOM8mMxL3t2JS91k+fHLy4gq868_9eUyS9A@mail.gmail.com>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
From: HoP <jpetrous@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I doubt that scan or w_scan would support it. Even if it supports, that
> would mean that,
> for each ioctl that would be sent to the remote server, the error code would
> take 480 ms
> to return. Try to calculate how many time w_scan would work with that. The
> calculus is easy:
> see how many ioctl's are called by each frequency and multiply by the number
> of frequencies
> that it would be seek. You should then add the delay introduced over
> streaming the data
> from the demux, using the same calculus. This is the additional time over a
> local w_scan.
>
> A grouch calculus with scandvb: to tune into a single DVB-C frequency, it
> used 45 ioctls.
> Each taking 480 ms round trip would mean an extra delay of 21.6 seconds.
> There are 155
> possible frequencies here. So, imagining that scan could deal with 21.6
> seconds of delay
> for each channel (with it doesn't), the extra delay added by it is 1 hour
> (45 * 0.48 * 155).
>
> On the other hand, a solution like the one described by Florian would
> introduce a delay of
> 480 ms for the entire scan to happen, as only one data packet would be
> needed to send a
> scan request, and one one stream of packets traveling at 10GB/s would bring
> the answer
> back.

Andreas was excited by your imaginations and calculations, but not me.
Now you again manifested you are not treating me as partner for discussion.
Otherwise you should try to understand how-that-ugly-hack works.
But you surelly didn't try to do it at all.

How do you find those 45 ioctls for DVB-C tune? I still see only one ioctl
FE_SET_FRONTEND or v5+ variant FE_SET_PROPERTY.

Sorry, but, for example, szap tunes very close to local variant:

# time szap -c channels.conf -x Ocko
reading channels from file 'channels.conf'
zapping to 15 'ocko':
sat 0, frequency = 12168 MHz V, symbolrate 27500000, vpid = 0x00a0,
apid = 0x0050 sid = 0x1451
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal d410 | snr d380 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
0.00user 0.00system 0:01.33elapsed 0%CPU (0avgtext+0avgdata 2000maxresident)k
0inputs+0outputs (0major+171minor)pagefaults 0swaps

Honza
