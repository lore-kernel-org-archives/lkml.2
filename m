Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2JVLCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:02:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60109 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2JVLB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:01:58 -0400
Date: Mon, 22 Oct 2012 13:56:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Li Yang-R58472 <r58472@freescale.com>, "balbi@ti.com" <balbi@ti.com>,
        Simon Haggett <simon.haggett@realvnc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: gadget: Don't attempt to dequeue requests for a
 disabled USB endpoint on Freescale hardware
Message-ID: <20121022105601.GS14033@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350667166-3559-1-git-send-email-simon.haggett@realvnc.com>
 <20121019173718.GA2738@arwen.pp.htv.fi>
 <94F013E7935FF44C83EBE7784D62AD3F094730DB@039-SN2MPN1-023.039d.mgd.msft.net>
 <1535820.NU10ADjvOZ@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ggC1wwkyYWqEab//"
Content-Disposition: inline
In-Reply-To: <1535820.NU10ADjvOZ@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ggC1wwkyYWqEab//
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 22, 2012 at 12:47:21PM +0200, Laurent Pinchart wrote:
> Hi,
>=20
> On Monday 22 October 2012 03:33:19 Li Yang-R58472 wrote:
> > On Saturday, October 20, 2012 1:37 AM Felipe Balbi wrote:
> > > On Fri, Oct 19, 2012 at 06:19:26PM +0100, Simon Haggett wrote:
> > > > Some gadget drivers may attempt to dequeue requests for an endpoint
> > > > that has already been disabled. For example, in the UVC gadget driv=
er,
> > > > uvc_function_set_alt() will call usb_ep_disable() when alt setting 0
> > > > is selected. When the userspace application subsequently issues the
> > > > VIDIOC_STREAMOFF ioctl, uvc_video_enable() invokes usb_ep_dequeue()=
 to
> > >=20
> > > ensure that all requests have been cancelled.
> > >=20
> > > bug is on uvc gadget, then. Laurent ?
>=20
> We've discussed this topic a couple of months before. I believe that's no=
t a=20
> bug.
>=20
> http://68.183.106.108/lists/linux-usb/msg68869.html

fair enough :-)

That's a different case, however. At the link above we're discussing
dequeueing a request which is already being dequeued. $SUBJECT is trying
to fix dequeueing of a request for an endpoint which isn't even enabled.

--=20
balbi

--ggC1wwkyYWqEab//
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhSZBAAoJEIaOsuA1yqREtvcP/ikDgBcQnGMnmLx0B46yUH8B
vl0tI2pdTM5vEKj1a0wQrx5sClIVcYCMxGI1F4lwhEZ4fJOSCi7RW5f2UFq48ndh
Nb8XkmRtGyDOgpW5XZ1YLhOR/JCM5/xDHH4guv8i+kL09Kn+Rp881SlsjMiMRK0n
pi6W8ZZ9FEtqSY3cmMIkQnbQzo3lsu+k9c6nVjC+kx9PJytCGpk5jXxWva9LUO4q
DCEtXkHz64slgz7Ok01cYGJ/q8qs8soWHLRaYepHUrsoPcHwZ89kgMhhmlfz2E9A
t+154yO+ZO4NaRYgHVMhRVRsiLlZpNDx5ljTZgPPhQIxQD6/GIXCLkgGNpqSCpa3
MUdKSap3VmWbWaF9jxi6otNynHckUyX2CS7Jnp+l4URALhcsRzZjt3LFaAs9VI1l
jguLJRnTaZw4JtIPrMJYqOqkGR9l1Km5ogphZxzO0czkFx7P+G3ZryeqFvJD7YmR
dbN5QQPuMDVzBsl6lhdQBIAndRlEeqGR6dg51aYdAURey2HQEQ3XX5UxJTsF3oZb
u0AfUxtm8jnrcQG1TiC6gBVKiQAwRNMbXbRx9kIAqf6441RZ/8IGnGOUGQsNpGyA
KhCP0kv9nPdim2mite7td3+ICZIJh+Q2tvHcAT1eVEgS8czJnDpfeDLy4HBskyhb
NimFSvjXETC5tXwCcF/g
=8aST
-----END PGP SIGNATURE-----

--ggC1wwkyYWqEab//--
