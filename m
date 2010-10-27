Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab0J0Qwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:52:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab0J0Qwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:52:47 -0400
Message-ID: <4CC858B1.6090408@redhat.com>
Date: Wed, 27 Oct 2010 14:52:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
References: <4CC8380D.3040802@redhat.com> <4CC84597.4000204@gmail.com> <4CC84846.6020304@redhat.com> <4CC84B14.1030303@gmail.com> <4CC8550B.4060403@redhat.com> <4CC8558C.3000209@gmail.com>
In-Reply-To: <4CC8558C.3000209@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-10-2010 14:38, Jiri Slaby escreveu:
> On 10/27/2010 06:36 PM, Mauro Carvalho Chehab wrote:
>> Basically, af9015 broke due to (3), as .small_i2c = 1 means nothing. It should be using
>> .small_i2c = TDA18271_16_BYTE_CHUNK_INIT, instead.
>>
>> What I don't understand is why a patch doing this change didn't fix the issue. Please
>> test the patch I posted on the original -next thread. Let's try to identify why
>> tda18271_write_regs() is not breaking the data into smaller writes.
> 
> It helps, but one needs to unplug and replug the device. So care to
> respin the pull request with the patch included?

AH! Yes, this is sometimes needed on some hardware: when a longer or wrong I2C transaction
is received, the hardware simply stops working. You need to replug it for it to return to
life.

Ok, I'll add the patch that changes it to .small_i2c = TDA18271_16_BYTE_CHUNK_INIT
to the series.

Thanks,
Mauro.
