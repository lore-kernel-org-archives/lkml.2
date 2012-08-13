Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab2HMTs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 15:48:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab2HMTs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 15:48:56 -0400
Message-ID: <50295A17.8010404@redhat.com>
Date: Mon, 13 Aug 2012 13:48:39 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, Gleb Natapov <gleb@redhat.com>,
        kvm list <kvm@vger.kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH v8] kvm: notify host when the guest is panicked
References: <5021D235.4050800@cn.fujitsu.com> <20120813182132.GB25268@amt.cnet>
In-Reply-To: <20120813182132.GB25268@amt.cnet>
X-Enigmail-Version: 1.4.3
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enigF2EF96AD58E57E8BEB7FB44F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF2EF96AD58E57E8BEB7FB44F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/13/2012 12:21 PM, Marcelo Tosatti wrote:
> On Wed, Aug 08, 2012 at 10:43:01AM +0800, Wen Congyang wrote:
>> We can know the guest is panicked when the guest runs on xen.
>> But we do not have such feature on kvm.
>>
>> Another purpose of this feature is: management app(for example:
>> libvirt) can do auto dump when the guest is panicked. If management
>> app does not do auto dump, the guest's user can do dump by hand if
>> he sees the guest is panicked.
>>
>> We have three solutions to implement this feature:
>> 1. use vmcall
>> 2. use I/O port
>> 3. use virtio-serial.
>>
>> We have decided to avoid touching hypervisor. The reason why I choose
>> choose the I/O port is:
>> 1. it is easier to implememt
>> 2. it does not depend any virtual device
>> 3. it can work when starting the kernel
>=20
> How about searching for the "Kernel panic - not syncing" string=20
> in the guests serial output? Say libvirtd could take an action upon
> that?
>=20
> Advantages:
> - It works for all architectures.
> - It does not depend on any virtual device.

But it _does_ depend on a serial console, and furthermore requires
libvirt to tee the serial console (right now, libvirt can treat the
console as an opaque pass-through to the end user, but if you expect
libvirt to parse the serial console for a particular string, you've lost
some efficiency).

> - It works as early as serial console output does (panics before
> that should be rare).
> - It allows you to see why the guest panicked.

I think your arguments for a serial console have already been made and
refuted in earlier versions of this patch series, which is WHY this
series is still applicable.

--=20
Eric Blake   eblake@redhat.com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


--------------enigF2EF96AD58E57E8BEB7FB44F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJQKVoYAAoJEKeha0olJ0NqosQH+gKrPqkuriJCiuuY5XQe1DMo
Bv+nUptgx3sW8WoXt8HGvA+wmfpFZPtGYlxMB1axapIAeYaw27u6YzQnVJGxliZH
hRhAEexKlfFKadeM4r5A8cb7b1mbs5EnWfklN5UoxNhSDgYclb6b0nJZmgFUVRYi
vmmc86JN0mSl1O8fNB1gxYx0jCKNvcOsZe+1jbADuGcSBWuAIicyzpAnr7lWWeoc
9GU1H2FfM7kJfO5LXPtz3mG5OIGvITBixkUFFnB/i4mU+jy5OVFpQQ50x3ZD+OUt
RMlBWlW4k8w/QkaaixysD1Xg84OroOCmsiiRpUmUUdKD3E9n57wo6cK4JRzI5Ck=
=OVM5
-----END PGP SIGNATURE-----

--------------enigF2EF96AD58E57E8BEB7FB44F--
