Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1KAUWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 16:22:39 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29070 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAUWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 16:22:38 -0400
Date: Tue, 1 Nov 2011 23:22:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ciaran McCormick <ciaranmccormick@gmail.com>, devel@driverdev.osuosl.org,
        shemminger@vyatta.com, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stageing: bcm: fixed spacing coding style in
 led_control.c
Message-ID: <20111101202259.GC4682@mwanda>
References: <1320144259-22339-1-git-send-email-ciaranmccormick@gmail.com>
 <1320145665.14409.149.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
Content-Disposition: inline
In-Reply-To: <1320145665.14409.149.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4EB05505.0124,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 01, 2011 at 12:07:45PM +0100, Paul Bolle wrote:
> Stageing? And you might as well drop the filename from the summary. By
> the way, are the other files (if any) of this driver any better (I
> haven't checked)?
>=20

This needs a Signed-off-by line as well.

I'd say keep the filename.  Otherwise you get a string of cleanup
patches that all have the same name and that's annoying.

> On Tue, 2011-11-01 at 10:44 +0000, Ciaran McCormick wrote:
> > ---
> >  drivers/staging/bcm/led_control.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/staging/bcm/led_control.c b/drivers/staging/bcm/le=
d_control.c
> > index 16e939f..28c3382 100644
> > --- a/drivers/staging/bcm/led_control.c
> > +++ b/drivers/staging/bcm/led_control.c
> > @@ -5,8 +5,8 @@
> > =20
> >  static B_UINT16 CFG_CalculateChecksum(B_UINT8 *pu8Buffer, B_UINT32 u32=
Size)
> >  {
> > -	B_UINT16 	u16CheckSum=3D0;
> > -	while(u32Size--) {
> > +	B_UINT16	u16CheckSum =3D 0;

Put a blank line between declarations and code.  Probably you could
make the tab a space as well.

> > +	while (u32Size--) {
> >  		u16CheckSum +=3D (B_UINT8)~(*pu8Buffer);
>=20
> I'd say this line might need a space after the cast.

That's not in CodingStyle so it's up to the maintainer to decide, I
guess.  I think we normally wouldn't put a space there.

>=20
> >  	    pu8Buffer++;

This line should be indented the same as the previous line.

> >  	}
> > @@ -16,7 +16,7 @@ BOOLEAN IsReqGpioIsLedInNVM(PMINI_ADAPTER Adapter, UI=
NT gpios)
> >  {
> >  	INT Status ;
> >  	Status =3D (Adapter->gpioBitMap & gpios) ^ gpios ;
>=20
> You missed the space before the semicolons here.
>=20
> > -	if(Status)
> > +	if (Status)
> >  		return FALSE;
> >  	else
> >  		return TRUE;
>=20
> But, more importantly, why only do whitespace related stuff? Almost
> every second word apparently needs to be restyled here. Is doing just
> whitespace related stuff worthwhile? (This is not a rhetorical question.
> I'm actually wondering what Greg prefers).

You're right that this driver needs a lot of work.  Actually this
patch only touches on a tiny bit of the white space changes that are
needed in the file.  Here are the checkpatch complaints:

dcarpenter@elgon:~/progs/kernel/devel$ ./scripts/checkpatch.pl -f drivers/s=
taging/bcm/led_control.c | egrep "^(WARN|ERROR):" | sort | uniq -c
     21 ERROR: code indent should use tabs where possible
     74 ERROR: do not use C99 // comments
      9 ERROR: else should follow close brace '}'
      2 ERROR: space prohibited after that open parenthesis '('
      3 ERROR: space prohibited before that close parenthesis ')'
      2 ERROR: space prohibited before that ':' (ctx:WxE)
      2 ERROR: space required after that ',' (ctx:VxO)
     81 ERROR: space required after that ',' (ctx:VxV)
      1 ERROR: space required after that ',' (ctx:WxV)
      2 ERROR: space required before that '&' (ctx:OxV)
      1 ERROR: space required before the open brace '{'
     88 ERROR: space required before the open parenthesis '('
      2 ERROR: spaces required around that '||' (ctx:VxE)
      1 ERROR: spaces required around that ':' (ctx:VxE)
      1 ERROR: spaces required around that '<' (ctx:VxV)
      1 ERROR: spaces required around that '=3D=3D' (ctx:VxV)
      5 ERROR: spaces required around that '=3D' (ctx:VxV)
      8 ERROR: spaces required around that '=3D' (ctx:VxW)
      2 ERROR: spaces required around that '!=3D' (ctx:VxW)
      1 ERROR: spaces required around that '<' (ctx:WxV)
      2 ERROR: spaces required around that '=3D' (ctx:WxV)
      1 ERROR: spaces required around that '||' (ctx:WxV)
     70 ERROR: that open brace { should be on the previous line
dcarpenter@elgon:~/progs/kernel/devel$=20

I'd prefer a series of patches:

[patch 1/3] Staging: bcm: fix whitespace in led_control.c
This would address tabs vs spaces, extra prohibited spaces, and
spaces required around certain chars.  Also it would add blank lines
between functions and between declarations and code.

[patch 2/3] Staging: bcm: fix C99 comments in led_control.c
This would fix the 74 ERROR: do not use C99 // comments

[patch 3/3] Staging: bcm: fix braces style in led_control.c
This would fix the 70 ERROR: that open brace { should be on the
previous line.

Then another series would go through every file in the driver and
change the types to standard kernel types.

[patch 1/x] Staging: bcm: Change B_UINT16 to u16
[patch 2/x] Staging: bcm: Change B_UINT32 to u32

Then go through each file and rename the local variables to kernel
style variables.

[patch 1/y] Staging: bcm: Rename "Status" to "ret" in led_control.c
[patch 2/y] Staging: bcm: Rename CamelCase variables in led_control.c

Then go through the whole driver and make as many functions as
possible static.  Sparse can help with this.

[patch 1/z] Staging: bcm: mark functions as static
[patch 2/z] Staging: bcm: fix function names in led_control.c

Then go through the entire driver and rename all the non-static
functions.  This would be done one function per patch.  Btw the
coccinelle is could at this.  So much of this stuff could be scripted.

Then get rid of all the typedefs.

Then rename all the struct members.

Delete all the dead code.

Change all the custom printk() macros to normal kernel format.

All this stuff is fairly mechanical and do-able.

Then is when you start to hit the interesting bits.  The driver is at
the hello world stage.  It can connect to the internet but it crashes
soon after that.  I think you need a forked version of WPA supplicant
in userspace to make this work.  I tried a while back and didn't find
the userspace code and now I don't have the hardware.

So there is a long way to go... But anyway, every small step in the
right direction helps.  I think we tend to merge patches even if they
are small like this one.

regards,
dan carpenter

--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsFUiAAoJEOnZkXI/YHqR/S4P/1ge3Aqic21D2eC10Sqn4h0Q
aNj5M/hjpCtjhn6jeZ5NTm/zxhSDd/qJ3BfRDipVQ2sr4vcPJqtONJkL8drvJJ8U
l4ATsJ1VHn6irQa8SRgEZ5ylxLMQzomjwuOs6+xcSgd9R3LJjk8adBfk+XVXMzP6
OvTz/1oNAbemWZVFbqvQu+LtUH/Dt+ySry/4xlHWuI0nHNNtwH6ffEYyfjGv89le
O4tPw9kdchfUQDOPzQUHAaagL0JteTxsxw4yVHExUrinIfooQcjGhW2Q30YTvEnJ
rl5J0bKzr9PbVTRs3vYPk/YGZux3hZhXhbdAvftz0LbgJnQyMoVAbJRTuD2lUQbV
9yHzTH8PJARqTCcbQgEH2e8vCJ4xUz7632L5KRKfyl5ubkfhAGdwPSNZHwcyVNTL
CXFXPcMtI4uW8vCm71ihDoKer77G3Nic9Ve5qK4MuMX3n50Nynnn54MqmiequvcW
G1bjU5D6iWVB44TvIlQ1iIg4T/ywOAlFHkJXVnzFKvGLUK5UiEw1QSfKuBvg6bJO
vBmURi24FhLTXjclM6STvnar/tIrBc1cefkw0LztPe5SP88R0o121bJ4j4LzzUbs
d38wQt7cwtIfsrVIFz8KHQu6xxjtyzFJTdIhStxXRQVun2AwkGO28U09V5RyWv2D
H1FFzcdc2WxAr6EfzEKG
=3neB
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--
