Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab1DHVS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 17:18:59 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:58040 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab1DHVS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 17:18:58 -0400
Message-ID: <4D9F7BC0.8010003@web.de>
Date: Fri, 08 Apr 2011 23:18:56 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        KVM mailing list <kvm@vger.kernel.org>
Subject: Re: trace-cmd errors on kvm events
References: <4D9F59AC.6080707@gmail.com> <4D9F790B.2000300@web.de> <4D9F7A4B.3040606@gmail.com>
In-Reply-To: <4D9F7A4B.3040606@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig546135EA6B2AF285244562DF"
X-Provags-ID: V01U2FsdGVkX1/8cSIvTXnj4GhzDHExBUnB6TAFBu1owUMyFDp0
	REmlKTUrHkD70vpeScfODFEfJe0i5WFtRvVofmWHZQf5UImugL
	KvFmjEjik=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig546135EA6B2AF285244562DF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2011-04-08 23:12, David Ahern wrote:
>=20
>=20
> On 04/08/11 15:07, Jan Kiszka wrote:
>> On 2011-04-08 20:53, David Ahern wrote:
>>> 2.6.38.2 kernel with trace-cmd git pulled this morning:
>>>
>>> trace-cmd record -e kvm
>>>
>>> trace-cmd report 2>&1 | less
>>>
>>> trace-cmd: No such file or directory
>>
>> Does this error come from trace-cmd failing to find its kvm plugin?
>> Check what strace -e open says.
>>
>> Jan
>>
>=20
> Tried that before - it was not enlightening.
> strace -e trace=3Dopen trace-cmd report 2>&1 | less
>=20
> open("/etc/ld.so.cache", O_RDONLY)      =3D 3
> open("/lib64/libdl.so.2", O_RDONLY)     =3D 3
> open("/lib64/libc.so.6", O_RDONLY)      =3D 3
> open("/root/trace.dat", O_RDONLY)       =3D 3
> trace-cmd: No such file or directory
>   function ftrace_print_symbols_seq not defined
>   failed to read event print fmt for kvm_nested_vmexit_inject
>   function ftrace_print_symbols_seq not defined
>   failed to read event print fmt for kvm_nested_vmexit
>   function ftrace_print_symbols_seq not defined
>   failed to read event print fmt for kvm_exit
>   bad op token {
>   failed to read event print fmt for kvm_emulate_insn
> open("/proc/meminfo", O_RDONLY)         =3D 4

Let me check... indeed, I'm getting the same file-not-found here with
trace-cmd.git 9cce1c9b5b when starting it directly from its build directo=
ry.

But maybe your trace-cmd or kernel versions are too old / incompatible.
I'm not getting complaints about unparseable events with the above
snapshot and 2.6.38.

Jan


--------------enig546135EA6B2AF285244562DF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk2fe8AACgkQitSsb3rl5xTqzACgyzjMgZectM7IkXEJzk4hcIQ8
WYQAoIYOI85vw1xLsalxGm2xPTe0aUqK
=Z7wU
-----END PGP SIGNATURE-----

--------------enig546135EA6B2AF285244562DF--
