Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab1LFNtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:49:17 -0500
Received: from ffm.saftware.de ([83.141.3.46]:52707 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248Ab1LFNtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:49:15 -0500
Message-ID: <4EDE1D57.90307@linuxtv.org>
Date: Tue, 06 Dec 2011 14:49:11 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: HoP <jpetrous@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <CAJbz7-1S6K=sDJFcOM8mMxL3t2JS91k+fHLy4gq868_9eUyS9A@mail.gmail.com> <4EDE1733.8060409@redhat.com>
In-Reply-To: <4EDE1733.8060409@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.12.2011 14:22, Mauro Carvalho Chehab wrote:
> On 05-12-2011 22:07, HoP wrote:
>>> I doubt that scan or w_scan would support it. Even if it supports, that
>>> would mean that,
>>> for each ioctl that would be sent to the remote server, the error
>>> code would
>>> take 480 ms
>>> to return. Try to calculate how many time w_scan would work with
>>> that. The
>>> calculus is easy:
>>> see how many ioctl's are called by each frequency and multiply by the
>>> number
>>> of frequencies
>>> that it would be seek. You should then add the delay introduced over
>>> streaming the data
>>> from the demux, using the same calculus. This is the additional time
>>> over a
>>> local w_scan.
>>>
>>> A grouch calculus with scandvb: to tune into a single DVB-C
>>> frequency, it
>>> used 45 ioctls.
>>> Each taking 480 ms round trip would mean an extra delay of 21.6 seconds.
>>> There are 155
>>> possible frequencies here. So, imagining that scan could deal with 21.6
>>> seconds of delay
>>> for each channel (with it doesn't), the extra delay added by it is 1
>>> hour
>>> (45 * 0.48 * 155).
>>>
>>> On the other hand, a solution like the one described by Florian would
>>> introduce a delay of
>>> 480 ms for the entire scan to happen, as only one data packet would be
>>> needed to send a
>>> scan request, and one one stream of packets traveling at 10GB/s would
>>> bring
>>> the answer
>>> back.
>>
>> Andreas was excited by your imaginations and calculations, but not me.
>> Now you again manifested you are not treating me as partner for
>> discussion.
>> Otherwise you should try to understand how-that-ugly-hack works.
>> But you surelly didn't try to do it at all.
>>
>> How do you find those 45 ioctls for DVB-C tune?
> 
> With strace. See how many ioctl's are called for each tune. Ok, perhaps
> scandvb
> is badly written, but if your idea is to support 100% of the
> applications, you
> should be prepared for badly written applications.
> 
> $strace -e ioctl scandvb dvbc-teste
> scanning dvbc-teste
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> ioctl(3, FE_GET_INFO, 0x60a640)         = 0
> initial transponder 573000000 5217000 0 5
>>>> tune to: 573000000:INVERSION_AUTO:5217000:FEC_NONE:QAM_256
> ioctl(3, FE_SET_FRONTEND, 0x7fff5f7f2cd0) = 0
> ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
> ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
> ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
> ioctl(4, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
> ioctl(5, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
> ioctl(6, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
> ioctl(7, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(8, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(9, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(10, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(11, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(12, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(13, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(14, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(15, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(16, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(17, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(18, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(19, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(20, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(21, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(22, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(23, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(24, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
> ioctl(4, DMX_STOP, 0x1)                 = 0
> ioctl(15, DMX_STOP, 0x1)                = 0
> ioctl(11, DMX_STOP, 0x1)                = 0
> ioctl(22, DMX_STOP, 0x1)                = 0
> ioctl(17, DMX_STOP, 0x1)                = 0
> ioctl(16, DMX_STOP, 0x1)                = 0

You don't need to wait for write-only operations. Basically all demux
ioctls are write-only. Since vtunerc is using dvb-core's software demux
*locally*, errors for invalid arguments etc. will be returned as usual.

What's left is one call to FE_SET_FRONTEND for each frequency to tune
to, and one FE_READ_STATUS for each time the lock status is queried.
Note that one may use FE_GET_EVENT instead of FE_READ_STATUS to get
notified of status changes asynchronously if desired.

Btw.: FE_SET_FRONTEND doesn't block either, because the driver callback
is called from a dvb_frontend's *local* kernel thread.

Regards,
Andreas
