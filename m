Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1IEKkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 06:40:01 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:48300 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585Ab1IEKjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 06:39:54 -0400
Date: Mon, 5 Sep 2011 13:39:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: balbi@ti.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110905103948.GD18442@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110823150854.2f6da7f66247c3d31b07e072@canb.auug.org.au>
 <20110823095938.GJ1341@legolas.emea.dhcp.ti.com>
 <CAMuHMdWGtsNN3_26PZYOGQjDid4rXRxxssQVDCDsNSim_FJwdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWGtsNN3_26PZYOGQjDid4rXRxxssQVDCDsNSim_FJwdg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GyRA7555PLgSTuth
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 02, 2011 at 08:32:09PM +0200, Geert Uytterhoeven wrote:
> On Tue, Aug 23, 2011 at 11:59, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Aug 23, 2011 at 03:08:54PM +1000, Stephen Rothwell wrote:
> >> After merging the moduleh tree, today's linux-next build (x86_64
> >> allmodconfig) failed like this:
> >>
> >> drivers/usb/dwc3/dwc3-pci.c: In function 'dwc3_pci_init':
> >> drivers/usb/dwc3/dwc3-pci.c:211:9: error: 'THIS_MODULE' undeclared (fi=
rst use in this function)
> >>
> >> Caused by the interaction of the module.h split up with commit
> >> 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver") from the usb
> >> tree.
> >>
> >> I have applied this patch for today (Greg, this should be applied to y=
our
> >> tree):
> >>
> >> From: Stephen Rothwell <sfr@canb.auug.org.au>
> >> Date: Tue, 23 Aug 2011 15:05:25 +1000
> >> Subject: [PATCH] usb: include module.h in the DesignWare USB3 DRD driv=
er
> >>
> >> Fixes this build error:
> >>
> >> drivers/usb/dwc3/dwc3-pci.c: In function 'dwc3_pci_init':
> >> drivers/usb/dwc3/dwc3-pci.c:211:9: error: 'THIS_MODULE' undeclared (fi=
rst use in this function)
> >>
> >> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> >> ---
> >> =A0drivers/usb/dwc3/dwc3-pci.c | =A0 =A01 +
> >> =A01 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> >> index 2578595..e3b77d2 100644
> >> --- a/drivers/usb/dwc3/dwc3-pci.c
> >> +++ b/drivers/usb/dwc3/dwc3-pci.c
> >> @@ -38,6 +38,7 @@
> >> =A0 */
> >>
> >> =A0#include <linux/kernel.h>
> >> +#include <linux/module.h>
> >
> > that was my fault, I didn't know about Paul's commit. Please Greg, apply
> > this to your tree:
> >
> > Acked-by: Felipe Balbi <balbi@ti.com>
>=20
> The include should also be added to drivers/usb/dwc3/core.c and
> drivers/usb/dwc3/dwc3-omap.c,
> cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/4491952/

that's true, here's a patch for that:

=46rom 2b248785ee47dd16bb8fa544f80f7e2e51919e8c Mon Sep 17 00:00:00 2001
=46rom: Felipe Balbi <balbi@ti.com>
Date: Mon, 5 Sep 2011 13:37:28 +0300
Subject: [PATCH] usb: dwc3: add module.h to dwc3-omap.c and core.c
Organization: Texas Instruments\n

We need that header because of THIS_MODULE.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/dwc3/core.c      |    1 +
 drivers/usb/dwc3/dwc3-omap.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 6aa0913..64ba097 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -37,6 +37,7 @@
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
=20
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index ddbf38a..8a5d6ae 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -37,6 +37,7 @@
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
=20
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
--=20
1.7.6.396.ge0613

I'll send this to Greg once hera is back up and running.

--=20
balbi

--GyRA7555PLgSTuth
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOZKb0AAoJEAv8Txj19kN1yWsH/1gUwM+ml3SaB2yX56vvcRE5
f9SsUWTiohWdilSY6G0ZLikwkA0XLYukd1HjHVtiquvgX+E9D7jiDUqkHnDi0Lb8
gRvfVSbCPBdCYsxi74PSThOBRsZgTgzEOKdJI1XNn20S+71HA6RyR4syX0kVBBUW
R/DCiy5B/fSMpVJXy6+aQFDMfrHpbvMV3ecFP4oKgLE0A4MVO0AmO6LwVNmvay1/
4exwIwT2R+Wd6Z6b2tOAzq7pnecq8fWP0UheIrTPeReR/R84prneVTxU0gef+tUl
TBpjN+hIPihBMfV7/tDOjcdQqfOGFkf48scJ07dTgtwWKqU6LU5PeSn3pqqL9/I=
=twJz
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--
