Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab2KVTLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:11:09 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:52083 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab2KVTLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:11:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: balbi@ti.com
Cc: walter harms <wharms@bfs.de>, Cyril Roelandt <tipecaml@gmail.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] UVC: use GFP_ATOMIC under spin lock.
Date: Thu, 22 Nov 2012 13:38:20 +0100
Message-ID: <1906481.9XLFQBE7QO@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121122122223.GC18022@arwen.pp.htv.fi>
References: <1353360842-18384-1-git-send-email-tipecaml@gmail.com> <50ADDDD5.1080709@bfs.de> <20121122122223.GC18022@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4560873.UUymmdTJiz"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4560873.UUymmdTJiz
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 22 November 2012 14:22:23 Felipe Balbi wrote:
> On Thu, Nov 22, 2012 at 09:09:57AM +0100, walter harms wrote:
> > Am 19.11.2012 22:34, schrieb Cyril Roelandt:
> > > Found using the following semantic patch:
> > > <spml>
> > > @@
> > > @@
> > > spin_lock_irqsave(...);
> > > ... when != spin_unlock_irqrestore(...);
> > > * GFP_KERNEL
> > > </spml>
> > > 
> > > Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> > > ---
> > > 
> > >  drivers/usb/gadget/uvc_video.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/usb/gadget/uvc_video.c
> > > b/drivers/usb/gadget/uvc_video.c index b0e53a8..79b4132 100644
> > > --- a/drivers/usb/gadget/uvc_video.c
> > > +++ b/drivers/usb/gadget/uvc_video.c
> > > @@ -309,7 +309,7 @@ uvc_video_pump(struct uvc_video *video)
> > > 
> > >  		video->encode(req, video, buf);
> > >  		
> > >  		/* Queue the USB request */
> > > 
> > > -		if ((ret = usb_ep_queue(video->ep, req, GFP_KERNEL)) < 0) {
> > > +		if ((ret = usb_ep_queue(video->ep, req, GFP_ATOMIC)) < 0) {
> > > 
> > >  			printk(KERN_INFO "Failed to queue request (%d)\n", ret);
> > >  			usb_ep_set_halt(video->ep);
> > >  			spin_unlock_irqrestore(&video->queue.irqlock, flags);
> > 
> > IMHO, this should be two lines, aka:
> > 
> > ret = usb_ep_queue(video->ep, req, GFP_KERNEL);
> > if (ret<0)
> 
> correct, please resend with the fix.

I agree as well.

-- 
Regards,

Laurent Pinchart

--nextPart4560873.UUymmdTJiz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQrhzCAAoJEIkPb2GL7hl1NX8IAJIE8YqFtr7qIZepw63hbv4a
GE3Y1eC61aYxXyVCukv73SImYVCa1TUPk69cP3pHctkeh72Wylzofgov1yN8blZH
VniHH/owMCbzUmmrUSDqhOGpA9jZAM70iFMA84feht5E09Gm4w4BQgMnNVVIvSPf
2IXFayGFFL6Kv5mPwUh1mRTgFoWY/RgCap0BICYxQrpT1cKryLfLxLXU+753iTKf
r1CpXy0u9IQOkLMZVT5r48kuXIdw/Dn/PBGEN/na/NSnSCfSX/5wWFVpJxYSqiQI
81gI4eHXHfANTlu1w1Tqx9Ch4nGDqeKXwqnjhhqiBToEuFlDqMgguQw2EWtVnMM=
=GeEF
-----END PGP SIGNATURE-----

--nextPart4560873.UUymmdTJiz--

