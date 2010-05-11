Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab0EKQyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:54:37 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:45584 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab0EKQyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:54:35 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 12:54:34 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jPU7S3LBjBXwKdMx1LZ2oQd3HbqYKQjodkejg20pfYtEUg914Zc8HOLHI1TsiZErHl
         hRG+0CQhKS6lrwqy62NiVFiMDuOuebChrrRWmgM8mOwer1qzMG7tAhMCyl3Qr+pxVS01
         1CwO4oONEkRTnc9eJYoOjHURZRnCLSqcTX1jI=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005111158420.1834-100000@iolanthe.rowland.org>
References: <20100512003450P.fujita.tomonori@lab.ntt.co.jp>
	 <Pine.LNX.4.44L0.1005111158420.1834-100000@iolanthe.rowland.org>
Date: Tue, 11 May 2010 17:48:11 +0100
Message-ID: <AANLkTikoF4qgkN9p0SpDEOrHAMxdh4jzPusCdrq1tRag@mail.gmail.com>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
From: Pedro Ribeiro <pedrib@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, gregkh@suse.de,
       konrad.wilk@oracle.com, tiwai@suse.de,
       USB list <linux-usb@vger.kernel.org>, clemens@ladisch.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       andi@firstfloor.org, daniel@caiaq.de,
       Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 May 2010 17:06, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> The particular test that Pedro is running uses audio output only --
> he's sending sound data to a speaker and it comes out noisy.
>
> But the audio data has to come from somewhere, and I don't remember
> where.  Pedro, does the noise occur only when you're playing sound that
> comes from a different USB device?  What happens if you play sounds
> that are stored on your hard disk, like an MP3 file?

> Or what happens if you take the incoming sound data and store it in a
> disk file, and then later play that file out through the speaker?
>
> Alan Stern
>
>

I'm clueless about the whole underlying process but I don't think it
is related to playing a file from the disk or another USB device.

I don't need to play any file for this interference to be heard - I
just need to "open" the device. By this I mean that if I create a JACK
server or if I open the device using the ALSA backed in a program like
Mixxx I immediately start hearing the cracks and pops in the speaker.
But to answer your question, playing a file from the hard drive using
aplay I can also hear the interference - but only when the sound is
playing. As soon as the sound stops and the audio device is "closed",
no interference occurs.

However, when using the JACK server, which probably opens and polls
the audio card constantly (its a low latency audio server) I don't
even need to be playing any sound for the interference to be constant.

I can also see it since I have 4 output leds in the USB audio card and
even if I'm only using 2 channels, the 4 channel leds light up with
interference as the sound cracks and pops.

Regards,
Pedro
