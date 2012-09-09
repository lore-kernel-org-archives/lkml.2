Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab2IINwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 09:52:47 -0400
Received: from mout.web.de ([212.227.17.12]:59794 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab2IINwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 09:52:46 -0400
Message-ID: <504C9F18.30904@web.de>
Date: Sun, 09 Sep 2012 15:52:24 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 11/12] KVM: introduce readonly memslot
References: <5032F8FD.2020306@linux.vnet.ibm.com> <5032FA5B.5040308@linux.vnet.ibm.com> <5049CB36.4080000@siemens.com> <5049D0AA.2060202@linux.vnet.ibm.com> <5049D722.5090305@siemens.com> <504C9CA9.5010708@redhat.com>
In-Reply-To: <504C9CA9.5010708@redhat.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC87A82FE9CE0F9CCCC2C1F29"
X-Provags-ID: V02:K0:I+DtU4UByzFCUngYcB7UJ7sFFAZ0ah5pjDOQiLGGvH7
 wdgc0aC3SXBVxgogaYiiMmTGsvhFnDFvGqmOJnz4m1gUN7D719
 7tucDL1nxL332lA5TL9Xh1VSGmgh2pd1gJRnV9AY38irbPNS7L
 LUrmMoQwl/Ymk1wf37O+ivnDm9CqUW2uqQy7f+dMaIAVxvJGgr
 kdHJXFbPq3Q8hPp8CaEAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC87A82FE9CE0F9CCCC2C1F29
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2012-09-09 15:42, Avi Kivity wrote:
> On 09/07/2012 02:14 PM, Jan Kiszka wrote:
>>>
>>> $ grep __KVM_HAVE include/linux/kvm.h | wc -l
>>> 20
>>
>> Yes, mistakes of the past.
>>
>>>
>>> As your suggestion, userspace will always use the CAP even if the CAP=

>>> is not really supported. We do not need care the overload on other ar=
ches?
>>
>> Generally, userspace can only find out if a CAP is supported by testin=
g
>> during runtime. Sometimes, the CAP may also be used to switch features=

>> that are only available on certain archs. But this particular feature
>> should surely become a generic one soon, and the code you could skip i=
n
>> userspace is truly minimal.
>=20
> You also need them for build time, to see if the ioctl names and
> structures are defined.  qemu chose not to do this ifdeffery but we mus=
t
> not make that choice for other userspace.

I disagree. We switched QEMU to the pattern the kernel officially
recommends: carry your own headers if you cannot rely on a recent
distribution. The only valid use case for #ifdef KVM_CAP is to allow
disabling of generic code that only some archs can make use of.

I'm not arguing for cleaning up legacy CAPs but for applying this rule
on newly introduced ones.

Jan



--------------enigC87A82FE9CE0F9CCCC2C1F29
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBMnx4ACgkQitSsb3rl5xRy1gCdFmyHVBLQzDc/RAG/OGQ+cCTX
LGwAoJLNc1I7BpSwQw/8joVYjWHcUOMK
=IGA4
-----END PGP SIGNATURE-----

--------------enigC87A82FE9CE0F9CCCC2C1F29--
