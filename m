Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab2HJBAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 21:00:53 -0400
Received: from exout101.netflix.com ([69.53.237.162]:50414 "EHLO
	exout103.netflix.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751676Ab2HJBAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 21:00:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024;d=netflix.com;
  h=from:to:cc:subject:date:message-id:references:in-reply-to
    :content-type:mime-version;
  b=hvNoYqpwpjPTS6NJ2T+LxLu9lK99+pKjvJeTRMVKbTqSWMiBcxVQwcUe16L03cJNnYuUJcfK
    PsiEfoB9snPNlw3+d8CzCS71JM/ohho64r6LxI0mkKyzgurhTIv0gJtokqf2+e7xLfckelBY
    VU0Rd9QrsuQgL4okNvcn7IMK2zY=
From: Wesley Miaw <wmiaw@netflix.com>
To: Alasdair G Kergon <agk@redhat.com>
CC: Milan Broz <mbroz@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "msb@google.com" <msb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?Windows-1252?Q?Will_Drewry=99?= <w@google.com>
Subject: Re: [dm-devel] [PATCH v2 1/2] dm: verity support data device	offset
 (Linux 3.4.7)
Thread-Topic: [dm-devel] [PATCH v2 1/2] dm: verity support data device
	offset (Linux 3.4.7)
Thread-Index: AQHNddNR+SZbnrO+/UG7B9aFuaaGnZdSsNmA
Date: Fri, 10 Aug 2012 01:00:50 +0000
Message-ID: <6C715FBD-EDE6-44F4-A26F-9F49C861C827@netflix.com>
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com>
 <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com>
 <5022CC99.30103@redhat.com>
 <0066B4B7-B0FA-4C7F-99C4-0AABB577382C@netflix.com>
 <20120809020419.GD23758@agk-dp.fab.redhat.com>
In-Reply-To: <20120809020419.GD23758@agk-dp.fab.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.2.229.146]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_650297C4-27F9-4367-8D4A-7D72172190C4";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_650297C4-27F9-4367-8D4A-7D72172190C4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Aug 8, 2012, at 7:04 PM, Alasdair G Kergon wrote:
>=20
> However, first you need to address the second part of Mikulas's email,
> namely to make the case for these changes rather than making no kernel
> changes and instead stacking the verity target over a linear target.
>=20
> To put this another way, your patch offers an alternative way to do
> something we think the existing kernel can already do, so you need to
> advance some reasons why you believe the new alternative method is =
worth
> adding to the kernel and explain this in the patch header.

I'm afraid for some reason I didn't get Mikulas's first email, only the =
reply from Milan which must have been an incomplete quote of Mikulas's =
text.

For my part, I approached this as porting my existing code to the new =
dm-verity implementation included in Linux 3.4. The previous code used a =
data offset as this was convenient and directly supported the block =
device image format I put together back then.

However I can indeed accomplish what I need using linear, it's just a =
bit more code. I am not able to measure any runtime performance =
difference. The primary benefit I can see for is the reduced kernel =
footprint if the linear target does not need to be included (and my =
corresponding setup code is about 1/3 smaller). With my cross-compiled =
kernel the savings is ~1KB; this is obviously a very small benefit.

So I would defer to others on this. While supporting the data offset =
would be convenient and match well with my specific use case I can live =
without it and I don't think the size cost is significant enough to =
matter. I expect to get some feedback from other developers in the =
coming months regarding my Linux 3.4 integration but I doubt it would =
change my current opinion on the matter.

Thanks,
--
Wesley Miaw=

--Apple-Mail=_650297C4-27F9-4367-8D4A-7D72172190C4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)

iQEcBAEBAgAGBQJQJF1BAAoJELoPFVk1ivvRjV8H/RbcAVBfhwD7m97iU9z6o9pB
eVDxpa7RMBq/xSQGt4wfXPCBMBDmhk435bbwBAb59Y8JxVGIO28dng5aNK5OtZI0
ruLK2muNsNvum9M19RtBQyRdoXnKCndsVqe0lQeOM91Ohir+zD0UQ+PKdB0e/fY8
gxIxQeMhTSPUC0aHS/9NNEu0e0NwXCgkA69dftIIMlGdECzLJbs2hFoLdLz8Tsne
Cw3iWhXe2zDEozyPxXUZTA7goqQoo6+IkKuLwmgNpUeYRPThsW+w2mcpAwwyJ/VK
/EnaMSYfO7nGzgdJ72Dm1t9lAtJHmST9xADzbhsrTafQPxI4mbrx1rw3cgkMBjM=
=9yB3
-----END PGP SIGNATURE-----

--Apple-Mail=_650297C4-27F9-4367-8D4A-7D72172190C4--
