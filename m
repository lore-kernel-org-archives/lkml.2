Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2GNHFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 03:05:52 -0400
Received: from mout.web.de ([212.227.15.3]:62752 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab2GNHFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 03:05:51 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jul 2012 03:05:51 EDT
Message-ID: <500118F1.8060300@web.de>
Date: Sat, 14 Jul 2012 09:00:01 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
References: <4FFEBB39.8090308@redhat.com> <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com> <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com> <alpine.LFD.2.02.1207131928000.32033@ionos> <alpine.LFD.2.02.1207140208270.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1207140208270.32033@ionos>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7FF571E121A0C3197AB0C4D5"
X-Provags-ID: V02:K0:vggW/V5/fvz4M8c5VvFABQck3uzwHBXPjRBv/uJ2h3S
 Ks+Nb7Hgwpn6cFfQWGv2pFb0VQVPLuXYnDXoW/PYhYaxVlEO+E
 n9kHxzT0dON8iFbJMDT9B7PyN4HjFVSMYp3yCq7dQP1QSkKmJz
 DpK84taniVxnyI+e6LBNw6v/raP4uvcAlBN4UbOSvOio56CsHr
 CS9+MD8sq9GszW9GNwcOA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7FF571E121A0C3197AB0C4D5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-07-14 04:25, Thomas Gleixner wrote:
> On Fri, 13 Jul 2012, Thomas Gleixner wrote:
>> On Fri, 13 Jul 2012, Linus Torvalds wrote:
>>> On Fri, Jul 13, 2012 at 8:45 AM, Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>> At the same time, I do wonder if maybe MSI + IRQF_ONESHOT couldn't be=

>>> improved. The fact that the KVM people think that the extra overhead
>>> of IRQF_ONESHOT is a bad thing for MSI interrupts makes me wonder if
>>> maybe this wouldn't be an area the irq layer couldn't be improved on.=

>>> Maybe the MSI+IRQF_ONESHOT case could be improved. Because MSI is kin=
d
>>> of fundamentally one-shot, since it's a message-based irq scheme.  So=

>>> maybe the extra overhead is unnecessary in general, not just in this
>>> particular KVM case. Hmm?
>>>
>>> Thomas, see the commentary of a76beb14123a ("KVM: Fix device
>>> assignment threaded irq handler").
>>
>> Groan.
>>
>> We already discussed to let the irq chip (in this case MSI) tell the
>> core that it does not need the extra oneshot handling. That way the
>> code which requests an threaded irq with the NULL primary handler
>> works on both MSI and normal interrupts.
>=20
> That's the kind of stuff which makes me go berserk, and just for the
> record: the most complaints I get for going berserk are coming from
> the virt folks.
>=20
> I really can't understand why the virt folks think they are
> special and do not have to talk to core maintainers.
>=20
> Back then when I was doing the big irq cleanup, virt crap stood out by
> far with the most idiotic^Wcreative "workarounds". Of course nobody
> complained about me being moronic enough to come up with generic
> solutions for their problems.
>=20
> Though especially that commit including its changelog proves once
> again the ignorance and desinterest of the virt crowd in solving
> problems which are not only relevant to themself.
>=20
> I whish you'd just refused to pull that nonsense and instead made them
> talk to those folks who had a proper solution in mind already.
>=20
> In fact we could have solved that proper weeks ago, if only people
> would have raised the issue.

June 1: http://thread.gmane.org/gmane.linux.kernel/1306742

The proper solution for us will be conditional direct IRQ delivery
anyway [1], but those patches were not considered ready for 3.5.

This patch here is a workaround to unbreak devices assignment in 3.5
after the IRQ layer changes without regressing noticeable /wrt overhead.

Jan

[1] http://thread.gmane.org/gmane.comp.emulators.kvm.devel/92249


--------------enig7FF571E121A0C3197AB0C4D5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlABGRAACgkQitSsb3rl5xQ4cQCeOY0xLZzqwx3AZCELHi/EH61f
PWEAoNg6/bOF+UZJhN+GjcwQYL0c2reB
=mf8A
-----END PGP SIGNATURE-----

--------------enig7FF571E121A0C3197AB0C4D5--
