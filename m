Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0FIImu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:42:50 -0400
Received: from smtp-out12.alice.it ([85.37.17.107]:3301 "EHLO
	smtp-out12.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0FIImr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:42:47 -0400
Date: Wed, 9 Jun 2010 10:42:35 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Alan Ott <alan@signal11.us>
Cc: Jiri Kosina <jkosina@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>,
       Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] HID: Add Support for Setting and Getting Feature 
 Reports  from hidraw
Message-Id: <20100609104235.ccce2289.ospite@studenti.unina.it>
In-Reply-To: <4C0E48DF.7000006@signal11.us>
References: <1275969108-14948-1-git-send-email-alan@signal11.us>
	<20100608083226.2dac88d2.ospite@studenti.unina.it>
	<4C0E48DF.7000006@signal11.us>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Jun_2010_10_42_35_+0200_flczoNE2olJ/V8Iz"
X-OriginalArrivalTime: 09 Jun 2010 08:42:42.0280 (UTC) FILETIME=[B97C6680:01CB07AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Jun_2010_10_42_35_+0200_flczoNE2olJ/V8Iz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 08 Jun 2010 09:42:55 -0400
Alan Ott <alan@signal11.us> wrote:

> On 06/08/2010 02:32 AM, Antonio Ospite wrote:
> > On Mon,  7 Jun 2010 23:51:48 -0400
> > Alan Ott<alan@signal11.us>  wrote:
> >
> >   =20
> >> Per the HID Specification, Feature reports must be sent and received on
> >> the Configuration endpoint (EP 0) through the Set_Report/Get_Report
> >> interfaces.  This patch adds two ioctls to hidraw to set and get featu=
re
> >> reports to and from the device.  Modifications were made to hidraw and
> >> usbhid.
> >>
> >> New hidraw ioctls:
> >>    HIDIOCSFEATURE - Perform a Set_Report transfer of a Feature report.
> >>    HIDIOCGFEATURE - Perform a Get_Report transfer of a Feature report.
> >>
> >> Signed-off-by: Alan Ott<alan@signal11.us>
> >> ---
> >>     =20
> > Thanks Alan, I am going to test this quite soon.
> >
> > TBH, when I was thinking about how to extend hidraw I thought we could
> > have added a new report_type field to struct hidraw_report_descriptor,
> > in order to re-use the HIDIOCGRDESC ioctl handler itself, adding then a
> > HIDIOCSRDESC for setting the report. This looked cleaner to my eyes,
> >   =20
> Thanks for the feedback, Antonio. The HIDIOCGRDESC ioctl copies the=20
> existing descriptor from the hid_device structure. Since it does not=20
> initiate a Get_Report transfer, I'm not sure how much re-use there could=
=20
> have been using that method. In my estimation, a Set_Report/Get_Report=20
> was more similar to the call to write().
>

I was only thinking about the interface to userspace,
HIDIOCGRDESC/HIDIOCSRDESC sounded more general to me (and look like
HIDIOCGREPORT/HIDIOCSREPORT from hiddev) if they could be made to work
with different report types, but as I said I didn't look at the
current code very well, so my remark are surely quite naive.

> > but I didn't actually implement this, so I don't know if it was
> > feasible, for instance one problem I didn't investigate further was
> > about the default value of the aforementioned report_type field in
> > order to keep the current behavior of HIDIOCGRDESC.
> >   =20
> I'm not sure what you mean here, as the report_type field is not part of=
=20
> hidraw_report_descriptor.
>

I was thinking about _adding_ that field, but again, pretty arbitrarily
thought.

> Thanks for testing my patch. Please let me know if you have problems=20
> with it.
>

It works basically ok for my needs, thanks again, waiting for comments
from usb/HID people.

Note that there are some checkpatch.pl errors in the current patch, and
also a style fix mixed with functional ones (@@ -315,7 +411,7 @@), you
may want to sort these out in a v2.

After this gets in, some more style fixes to hidraw.c could be made,
I'll do these. Maybe some naming cleanup can be made too,
hid_output_raw_report could become hid_set_raw_report for instance, but
I am waiting for the topic to settle first.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Wed__9_Jun_2010_10_42_35_+0200_flczoNE2olJ/V8Iz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwPU/sACgkQ5xr2akVTsAGilACeKT/YwLKe10oCE7rIK3Gye/Zj
QK4AoKFe/OCuGgXWeWyPCOlQzNPh1stZ
=yQ4k
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Jun_2010_10_42_35_+0200_flczoNE2olJ/V8Iz--
