Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab2JWBgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 21:36:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42221 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756380Ab2JWBgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 21:36:47 -0400
Message-ID: <1350956191.5283.40.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 02/37] lockd: use rpc clients cl_nodename for id encoding
From: Ben Hutchings <ben@decadent.org.uk>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Date: Tue, 23 Oct 2012 02:36:31 +0100
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA9092890D7@SACEXCMBX04-PRD.hq.netapp.com>
References: <20121019031302.789593147@linuxfoundation.org>
	 <20121019031303.167008948@linuxfoundation.org>
	 <20121019231518.GE13292@decadent.org.uk> <20121021162618.GB25856@kroah.com>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA9092890D7@SACEXCMBX04-PRD.hq.netapp.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0EOdeseyLdWm9Yif/oZS"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0EOdeseyLdWm9Yif/oZS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-10-22 at 17:02 +0000, Myklebust, Trond wrote:
> On Sun, 2012-10-21 at 09:26 -0700, Greg Kroah-Hartman wrote:
> > On Sat, Oct 20, 2012 at 12:15:18AM +0100, Ben Hutchings wrote:
> > > On Thu, Oct 18, 2012 at 08:16:25PM -0700, Greg Kroah-Hartman wrote:
> > > > 3.0-stable review patch.  If anyone has any objections, please let =
me know.
> > > >=20
> > > > ------------------
> > > >=20
> > > > From: Stanislav Kinsbursky <skinsbursky@parallels.com>
> > > >=20
> > > > commit 303a7ce92064c285a04c870f2dc0192fdb2968cb upstream.
> > > >=20
> > > > Taking hostname from uts namespace if not safe, because this cuold =
be
> > > > performind during umount operation on child reaper death. And in th=
is case
> > > > current->nsproxy is NULL already.
> > > =20
> > > In this case (3.0.y) you haven't included the following change
> > > (commit cb7323fffa85 'lockd: create and use per-net NSM RPC clients o=
n
> > > MON/UNMON requests') that makes lockd actually use cl_nodename.  I
> > > think this patch alone won't fix the bug, as nsm_args::nodename can
> > > end up pointing to freed memory.
> > >=20
> > > (I also wonder whether clients should really be per-net or per UTS
> > > namespace, and whether those should be orthogonal namespaces at all.)
> >=20
> > Hm, Trond, should I also include the other commit above in the next
> > 3.0-stable release?
> >=20
> > Or should this one be dropped?
>=20
> Hi Greg,
>=20
> Applying this patch shouldn't be harmful, but since it isn't actually
> fixing a problem (there being no net-namespace code in Linux-3.0), I'd
> suggest just dropping it.

If I understand rightly:
1. Prior to introduction of the per-netns clients, nsm_monitor() and
nsm_unmonitor() are called from a kthread which runs in the initial net
and utsname namespace.
2. Therefore, in nsm_mon_unmon(), current->nsproxy always refers to the
initial namespaces and is never NULL.
3. The per-netns clients were introduced in 3.5, so only 3.6.y needed
fixing.
4. However, this one change is harmless for earlier versions.

(I think that point 1 is not quite true in that nsm_unmonitor() can also
be called on module removal, potentially in something other than the
initial utsname namespace.  But it still won't result in a crash, and
it's hardly worth worrying about.)

Ben.

--=20
Ben Hutchings
Humour is the best antidote to reality.

--=-0EOdeseyLdWm9Yif/oZS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUIX0n+e/yOyVhhEJAQqiPA//QVrGgQnTcKosJM1KYaiIQAC13fY1GN/l
booHgf/qjrFUVb6feequaG3oGnyeoKK4Sc3+fO15FBqc7zjxl8XB9wMsCiXSZvmr
/x+Ya2ZJNi9WuJnxhLONwUfgzKwxTb2TVDcRVswVjg6JPcvlJBcA/jfjN3OYk2yx
VVCgKzg8hEy1k2VaQdYnQWz/TQmZj4LzBCJhYyz/mnvwKD17izHZCfzCPZ2TPA4Q
Hjlq8ANX5xKLm3/r4Y6tSYZFuwhA/NF3gY8xIRDXmXw3fBhpLixPy53Ka67kpSrR
C5jrLTjS94ebRNLdwO74lOhmzyuBMwkCAtlT1+9IjEk2rPEVKbkTP7fsYuWpnsq3
S+rq2ung3SutV+0tBUMjCZQea1grhokFQMLEck1ZxP+vfeKj+xgAr3gbKbvGGBZV
aEdsFY8oETgR9PzOhBlEMDXQbtB0jq9vEOSmNfN6siLavSG4UhUNIXDNN53YBJrT
2hsr0mWe7fkNz0+nlwfq2OlloCZbXxlqr9Qh6dVmSukWy0KHy2OsiBh7IFKr9hyH
L7zWtxCZS+ZMfTqXfVHY6ceRR6hDPSv56zeThqmzPCQ23QfH/KyjE3xMUYNFHDRn
3BzOPv2P1I7MxyNhlV0IPk1k+llpCbqmX76dGpHs7JfWRjOWYC7sPCD+kqe2JfOa
rfxPt3ajmkM=
=kSd6
-----END PGP SIGNATURE-----

--=-0EOdeseyLdWm9Yif/oZS--
