Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635Ab0J0PmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:42:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759269Ab0J0PmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:42:11 -0400
Message-ID: <4CC84846.6020304@redhat.com>
Date: Wed, 27 Oct 2010 13:41:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
References: <4CC8380D.3040802@redhat.com> <4CC84597.4000204@gmail.com>
In-Reply-To: <4CC84597.4000204@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Em 27-10-2010 13:30, Jiri Slaby escreveu:
> On 10/27/2010 04:32 PM, Mauro Carvalho Chehab wrote:
>> Linus,
>>
>> Please pull from
>> 	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
> ...
>> Mauro Carvalho Chehab (72):
> ...
>>       [media] tda18271: allow restricting max out to 4 bytes
> 
> Even though you know this one breaks at least one driver you want it merged?

We need to fix that issue with af9015, but, without this patch, cx231xx is broken, as it
doesn't accept more than 4 bytes per I2C transfer. I tested the patch here with some possible
restrictions for I2C size. Also, Mkrufky tested it with other different hardware.

What I don't understand is that the only change that this patch caused for af9015 is to change
the I2C max size that used to be 16. The patch I sent you reverted this behaviour, by using
the proper macro value, instead of a magic number, but you reported that this didn't fix your
problem.

So, we need to figure out what af9015 is doing different than the other patches, and add patch 
the issue with af9015. It shouldn't be hard to fix. I'll keep working with you in order to solve
the issue, although I don't have any af90xx hardware here, so, I need your help with the tests.

Cheers,
Mauro.

