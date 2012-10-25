Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2JYAfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:35:43 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45312 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab2JYAfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:35:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: balbi@ti.com
Cc: Li Yang-R58472 <r58472@freescale.com>,
        Simon Haggett <simon.haggett@realvnc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: gadget: Don't attempt to dequeue requests for a disabled USB endpoint on Freescale hardware
Date: Thu, 25 Oct 2012 02:36:24 +0200
Message-ID: <3862785.b8vaFMSbLQ@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121022105601.GS14033@arwen.pp.htv.fi>
References: <1350667166-3559-1-git-send-email-simon.haggett@realvnc.com> <1535820.NU10ADjvOZ@avalon> <20121022105601.GS14033@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2939656.n0tmhdiSaC"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2939656.n0tmhdiSaC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Felipe,

On Monday 22 October 2012 13:56:01 Felipe Balbi wrote:
> On Mon, Oct 22, 2012 at 12:47:21PM +0200, Laurent Pinchart wrote:
> > On Monday 22 October 2012 03:33:19 Li Yang-R58472 wrote:
> > > On Saturday, October 20, 2012 1:37 AM Felipe Balbi wrote:
> > > > On Fri, Oct 19, 2012 at 06:19:26PM +0100, Simon Haggett wrote:
> > > > > Some gadget drivers may attempt to dequeue requests for an endpoint
> > > > > that has already been disabled. For example, in the UVC gadget
> > > > > driver, uvc_function_set_alt() will call usb_ep_disable() when alt
> > > > > setting 0 is selected. When the userspace application subsequently
> > > > > issues the VIDIOC_STREAMOFF ioctl, uvc_video_enable() invokes
> > > > > usb_ep_dequeue() to ensure that all requests have been cancelled.
> > > > 
> > > > bug is on uvc gadget, then. Laurent ?
> > 
> > We've discussed this topic a couple of months before. I believe that's not
> > a bug.
> > 
> > http://68.183.106.108/lists/linux-usb/msg68869.html
> 
> fair enough :-)
> 
> That's a different case, however. At the link above we're discussing
> dequeueing a request which is already being dequeued. $SUBJECT is trying
> to fix dequeueing of a request for an endpoint which isn't even enabled.

You've got a point there :-) That's a different case indeed, I'm open to (at 
least evaluating) a fix in the UVC gadget driver if you think that's better.

-- 
Regards,

Laurent Pinchart

--nextPart2939656.n0tmhdiSaC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQiImPAAoJEIkPb2GL7hl13ScIAKAgbjsfgiOs9qkQdjxleIgs
Up1w/sVtjvIg6B4iQaDa5XJPNksymEB20NIuIfz3C7D645YBKrsKY7Hq7XdWgQNV
30pkcFOrP/u1mpDqT7DHVX7EAgFzporCKIlL/6jSFK5QmlXlazE2Grq9YoPChPj7
+3m0twwg2OD6xy537Z8/xmyfuRhBFEuDARY8gQoZS8YP1Jxczaxj5M55Zk3YCHsc
5d5VM6jifdh8QRRQw/81G47xUO45SngexxsU0FLeVOi/8033yN38s8dJTq5KIXLS
XGkD329kKsFn/8SZZgPnlJuhQy4+90wqtN2P9WDWX9HD8lQm6/d5yll+7m7Oxyw=
=gDVD
-----END PGP SIGNATURE-----

--nextPart2939656.n0tmhdiSaC--

