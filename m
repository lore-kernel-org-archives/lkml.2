Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1LFNLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:11:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab1LFNLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:11:05 -0500
Message-ID: <4EDE1457.7070408@redhat.com>
Date: Tue, 06 Dec 2011 11:10:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, HoP <jpetrous@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111205205554.2caeb496@lxorguk.ukuu.org.uk> <4EDD3583.30405@linuxtv.org> <20111206111829.GB17194@sirena.org.uk> <4EDE0400.1070304@linuxtv.org>
In-Reply-To: <4EDE0400.1070304@linuxtv.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-12-2011 10:01, Andreas Oberritter wrote:
> On 06.12.2011 12:18, Mark Brown wrote:
>> On Mon, Dec 05, 2011 at 10:20:03PM +0100, Andreas Oberritter wrote:
>>> On 05.12.2011 21:55, Alan Cox wrote:
>>>> The USB case is quite different because your latency is very tightly
>>>> bounded, your dead device state is rigidly defined, and your loss of
>>>> device is accurately and immediately signalled.
>>
>>>> Quite different.
>>
>>> How can usbip work if networking and usb are so different and what's so
>>> different between vtunerc and usbip, that made it possible to put usbip
>>> into drivers/staging?
>>
>> USB-IP is a hack that will only work well on a tightly bounded set of
>> networks - if you run it over a lightly loaded local network it can
>> work adequately.  This starts to break down as you vary the network
>> configuration.
>
> I see. So it has problems that vtunerc doesn't have.

The vtunerc has the same issues. High latency (due to high loads,  high
latency links or whatever) affects it badly, and may cause application
breakages if if the device is opened are using O_NONBLOCK mode [1].

Regards,
Mauro.

[1] Btw, if some DVB ioctl currently waits in O_NONBLOCK, this is a POSIX
violation that needs to be fixed.
