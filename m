Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab2IGQOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:14:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50413 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2IGQOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:14:03 -0400
Message-ID: <504A1D43.2050909@canonical.com>
Date: Fri, 07 Sep 2012 18:13:55 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Matt Wilson <msw@amazon.com>, "Justin M. Forbes" <jmforbes@linuxtx.org>,
        xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen hypervisors
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com> <504A05B00200007800099C7B@nat28.tlf.novell.com> <5049F4E9.9050306@canonical.com> <504A1A950200007800099D4C@nat28.tlf.novell.com> <20120907142251.GA20096@linuxtx.org> <504A32800200007800099E40@nat28.tlf.novell.com> <504A172B.5020005@canonical.com> <504A347B0200007800099E92@nat28.tlf.novell.com>
In-Reply-To: <504A347B0200007800099E92@nat28.tlf.novell.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig702662897FA34D13DEE46969"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig702662897FA34D13DEE46969
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07.09.2012 17:52, Jan Beulich wrote:
>>>> On 07.09.12 at 17:47, Stefan Bader <stefan.bader@canonical.com> wrot=
e:
>> On 07.09.2012 17:44, Jan Beulich wrote:
>>> All of this still doesn't provide evidence that a plain upstream
>>> kernel is actually having any problems in the first place. Further,
>>> if you say EC2 has a crippled hypervisor patch - is that patch
>>> available for looking at somewhere?
>>
>> It was not a hypervisor patch. It was one for the guest. This was the =
hack:
>=20
> So then why do you want to patch the upstream kernel? It won't
> make that hack go away, nor will it help any existing kernels.
>=20
> Jan
>=20

It would not make it go away automatically, but whoever uses it could dro=
p it.
It was unpatched upstream kernels that would have the problem. However, w=
hile
reading again through all the changelogs I noticed

commit 61f4237d5b005767a76f4f3694e68e6f78f392d9
Author: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date:   Sat Sep 18 22:25:30 2010 -0700

    xen: just completely disable XSAVE

    Some (old) versions of Xen just kill the domain if it tries to set an=
y
    unknown bits in CR4, so we can't reliably probe for OSXSAVE in
    CR4.

    Since Xen doesn't support XSAVE for guests at the moment, and no such=

    support is being worked on, there's no downside in just unconditional=
ly
    masking XSAVE support.

    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

So until then the write to CR4 was deliberately done to probe the feature=
=2E This
was changed by

commit 947ccf9c3c30307b774af3666ee74fcd9f47f646
Author: Shan Haitao <haitao.shan@intel.com>
Date:   Tue Nov 9 11:43:36 2010 -0800

    xen: Allow PV-OPS kernel to detect whether XSAVE is supported

    Xen fails to mask XSAVE from the cpuid feature, despite not historica=
lly
    supporting guest use of XSAVE.  However, now that XSAVE support has b=
een
    added to Xen, we need to reliably detect its presence.

    The most reliable way to do this is to look at the OSXSAVE feature in=

    cpuid which is set iff the OS (Xen, in this case), has set
    CR4.OSXSAVE.

    [ Cleaned up conditional a bit. - Jeremy ]

    Signed-off-by: Shan Haitao <haitao.shan@intel.com>
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

This would make it save again _if_ the HV failing to handle the writes to=
 CR4
(which iirc the kernel code still does when the cpuid bit is set) does ha=
ve at
least the patch to mask off the cpuid bits (the one Ian mentioned)

Probably a lot of hand wavy iffs... :/


--------------enig702662897FA34D13DEE46969
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBCgAGBQJQSh1DAAoJEOhnXe7L7s6jHgIQAI2CnLJw/evY3fpxZiEi6FKE
fH9jRgbMI9EXuLIAgP4nuYpU0tnNQ0N13dhWpq8A88Qj1+YhY0IyqqBM5JUarWBn
DHWDTmMhnnQQrl+B09gfKX2izFZTrovD+eF0OJo/TTdG7CvZ4J0CC16JiUxRGymp
GN0+dv9aac75keFKq63OlRkhYXwCl7f8BzCJpDAymHWK64ASn0sJXra3msx/Sjra
kKTP1kPyEf9c1BTGRqVQBsaPrX7dhluGGa0cMH5sJa0SR3FyE3nNes5/EcIUqaXr
EZ0pjKXWZOD3vHWwk3/0alJ/+ahIUX2NGp1wpuXAvXLd61uTRHWZpJjdmUC/ljL/
G6dhXj2PIgjgLkiKto/RedrYs9Ma13ZU37ADfkgLh4aMwcD1BsYNN2WhVtKag6IS
NCE9JoMx6BGrZuY0RDo7l30sqjwZxwULMEmH0YUHnfoBJp+M1N11kbSznOhQ7C3t
EDXi1x+Lvd+Inv6NqteBUuEG1f2G0GjiPFjTtajh4Fu9lybxzdFbnylLw8eJdl1Q
HN4e102qfRXnkDe+ENUSbQJ9x5VnG3Bzmy1GuTmXcxO7aqVTyQX0dN9XRgFMQRkc
QFfCa2bM9svxc1w5psYufa6xZHC3PQCt6FxAInukfIrGs+iIyx4JaXCjdE9Lr1GG
lY8VQ6H+cEP3XT6OOKPa
=lva4
-----END PGP SIGNATURE-----

--------------enig702662897FA34D13DEE46969--
