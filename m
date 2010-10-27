Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939Ab0J0PsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:48:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62811 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab0J0PsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:48:22 -0400
MIME-Version: 1.0
In-Reply-To: <4CC84846.6020304@redhat.com>
References: <4CC8380D.3040802@redhat.com>
	<4CC84597.4000204@gmail.com>
	<4CC84846.6020304@redhat.com>
Date: Wed, 27 Oct 2010 11:48:20 -0400
Message-ID: <AANLkTim=RfR3Dq0w+ACYjhGTHCSgapdf35wGW8QoZ38n@mail.gmail.com>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 11:41 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>> Even though you know this one breaks at least one driver you want it merged?
>
> We need to fix that issue with af9015, but, without this patch, cx231xx is broken, as it
> doesn't accept more than 4 bytes per I2C transfer. I tested the patch here with some possible
> restrictions for I2C size. Also, Mkrufky tested it with other different hardware.
>
> What I don't understand is that the only change that this patch caused for af9015 is to change
> the I2C max size that used to be 16. The patch I sent you reverted this behaviour, by using
> the proper macro value, instead of a magic number, but you reported that this didn't fix your
> problem.
>
> So, we need to figure out what af9015 is doing different than the other patches, and add patch
> the issue with af9015. It shouldn't be hard to fix. I'll keep working with you in order to solve
> the issue, although I don't have any af90xx hardware here, so, I need your help with the tests.
>
> Cheers,
> Mauro.

Hi Mauro,

Have you looked at the code for how the Conexant guys got the xc5000
firmware load to work (which uses 64 bytes at a time).  I suspect what
*really* needs to happen is that needs to be made generic so that the
stop bit is properly set (which would allow a single i2c transaction
to span across multiple USB control messages).

Note that the xc5000 hack is actually two changes merged together -
one uses a GPIO mode in certain cases to handle clock stretching
properly (which probably has to stay there for now), and the other
allows for larger i2c transactions.  I am referring to the latter
change.

If we fix the cx231xx i2c master, then we can go back to the original
18271 config, which avoids the risk of regression for other devices.

Adding mkrufky to the CC: on this, since he is the 18271 maintainer.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
