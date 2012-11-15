Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab2KOWHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:07:09 -0500
Received: from bsmtp5.bon.at ([195.3.86.187]:3309 "EHLO lbmfmo03.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751606Ab2KOWHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:07:05 -0500
X-Greylist: delayed 2000 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2012 17:07:04 EST
From: Markus Grabner <grabner@icg.tugraz.at>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, devel@driverdev.osuosl.org,
        line6linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/8] staging: line6: wrap >80 char lines in capture.c
Date: Thu, 15 Nov 2012 22:03:27 +0100
Message-ID: <1602710.lBylyCQOHr@medialab>
User-Agent: KMail/4.9.1 (Linux/3.4.11-2.16-desktop; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121114143305.GH11515@mwanda>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com> <1352636686-31170-2-git-send-email-stefanha@gmail.com> <20121114143305.GH11515@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 14. November 2012, 17:33:05 schrieb Dan Carpenter:
> On Sun, Nov 11, 2012 at 01:24:39PM +0100, Stefan Hajnoczi wrote:
> > Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
> > ---
> > 
> >  drivers/staging/line6/capture.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/staging/line6/capture.c
> > b/drivers/staging/line6/capture.c index c85c5b6..389c41f 100644
> > --- a/drivers/staging/line6/capture.c
> > +++ b/drivers/staging/line6/capture.c
> > @@ -256,8 +256,8 @@ static void audio_in_callback(struct urb *urb)
> > 
> >  #ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
> >  
> >  		if (!(line6pcm->flags & LINE6_BITS_PCM_IMPULSE))
> >  
> >  #endif
> > 
> > -			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM, &line6pcm-
>flags)
> > -			    && (fsize > 0))
> > +			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM,
> 
> The reason this is hitting the 80 character limit is because
> "LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM" is 35 characters long.  It
> isn't even clear from the name what it holds.  It's just a very crap
> name.
Please refer to the file pcm.h for a detailed documentation of this and 
similar names (in fact, the documentation explains the LINE6_BIT_PCM_* names 
instead, but I bevlieve the correspondence is obvious). It's hard to define a 
shorter name which is at the same time descriptive, consistent, and not to be 
confused with related names.

Should such documentation be moved to a separate file (e.g., 
"Documentation/sound/alsa/line6usb.txt")?

	Kind regards,
		Markus

