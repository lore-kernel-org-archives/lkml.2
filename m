Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab1KHPFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:05:38 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:41700 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab1KHPFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:05:37 -0500
Message-ID: <4EB944FD.7030007@web.de>
Date: Tue, 08 Nov 2011 16:04:29 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Pekka Enberg <penberg@kernel.org>,
        Am?rico Wang <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <4EB93FA4.8020800@redhat.com> <20111108145257.GA10846@infradead.org>
In-Reply-To: <20111108145257.GA10846@infradead.org>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC60E77515C186E33A408C163"
X-Provags-ID: V02:K0:7lSPOsyGg0LgeIa3H3yt1lhLlmizf3S6sck01K2lA5V
 rF1rD+dOk0oMcdxd8iUw64hOm1rLhiBzJWxqwFQRyp5g8b50qi
 c3Red2CFj4iEiJu2a0nBEv6fAA1KsjfrSPvUT7RTnW6wBh61Jf
 /aTPeHf8uz/qj8ak7UOsfI3ptCsVi30bnHqfdAUkYHgUeiElfg
 z+KWPep297seoFI32zwog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC60E77515C186E33A408C163
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2011-11-08 15:52, Christoph Hellwig wrote:
> On Tue, Nov 08, 2011 at 04:41:40PM +0200, Avi Kivity wrote:
>> On 11/06/2011 03:35 AM, Alexander Graf wrote:
>>> To quickly get going, just execute the following as user:
>>>
>>>     $ ./Documentation/run-qemu.sh -r / -a init=3D/bin/bash
>>>
>>> This will drop you into a shell on your rootfs.
>>>
>>
>> Doesn't work on Fedora 15.  F15's qemu-kvm doesn't have -machine or
>> -virtfs.  Even qemu.git on F15 won't build virtfs since xattr.h
>> detection is broken (patch posted).
>=20
> Nevermind that running virtfs as a rootfs is a really dumb idea.  You
> do now want to run a VM that has a rootfs that gets changed all the
> time behind your back.
>=20
> Running qemu -snapshot on the actual root block device is the only
> safe way to reuse the host installation, although it gets a bit
> complicated if people have multiple devices mounted into the namespace.=


I thought about this while hacking a slide on this topic: It's clumsy
(compared to -snapshot - my favorite one as well), but you could use
some snapshot on the host fs. Or a union fs (if we had  an official one)
with the write layer directed to some tmpfs area.

But what we likely rather want (as it would work without privileges) is
built-in write redirection for virtfs. Not an expert on this, but I
guess that will have to solve the same problems an in-kernel union fs
solution faces, no?

Jan


--------------enigC60E77515C186E33A408C163
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk65RP0ACgkQitSsb3rl5xQXBgCeOpYarFxnzImk5wYcpAYN46rh
0n8AniTaK8cXEu05DI00u8sejkZfHnXO
=K5tx
-----END PGP SIGNATURE-----

--------------enigC60E77515C186E33A408C163--
