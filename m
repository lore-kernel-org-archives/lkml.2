Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2FWCFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 22:05:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54943 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2FWCFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 22:05:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVEq5j1zoKS31fgfG_3xZSyfqsjdDorDku-Sgj6BTShEg@mail.gmail.com>
References: <20120529220636.AAA66A0308@akpm.mtv.corp.google.com>
	<CAE9FiQVEq5j1zoKS31fgfG_3xZSyfqsjdDorDku-Sgj6BTShEg@mail.gmail.com>
Date: Fri, 22 Jun 2012 19:05:45 -0700
X-Google-Sender-Auth: 4Mzc6dMMrBYjsRPXTD93SU-Lm0A
Message-ID: <CAE9FiQXR+3k4QmOJe59xom+JW5JZAP3znRXQwdyqV5LMEPCw2g@mail.gmail.com>
Subject: Re: [patch 046/181] mm: remove sparsemem allocation details from the
 bootmem allocator
From: Yinghai Lu <yinghai@kernel.org>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, hannes@cmpxchg.org, davem@davemloft.net,
        shangw@linux.vnet.ibm.com, tj@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b339cc1d3f37704c31a2f98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b339cc1d3f37704c31a2f98
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 22, 2012 at 6:11 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, May 29, 2012 at 3:06 PM, =A0<akpm@linux-foundation.org> wrote:
>> From: Johannes Weiner <hannes@cmpxchg.org>
>> Subject: mm: remove sparsemem allocation details from the bootmem alloca=
tor
>>
>> alloc_bootmem_section() derives allocation area constraints from the
>> specified sparsemem section. =A0This is a bit specific for a generic mem=
ory
>> allocator like bootmem, though, so move it over to sparsemem.
>>
>> As __alloc_bootmem_node_nopanic() already retries failed allocations wit=
h
>> relaxed area constraints, the fallback code in sparsemem.c can be remove=
d
>> and the code becomes a bit more compact overall.
>>
>> [akpm@linux-foundation.org: fix build]
>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> Acked-by: Tejun Heo <tj@kernel.org>
>> Acked-by: David S. Miller <davem@davemloft.net>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> hi, this one cause regression, will put usemap to last node's memory
> instead of each node.
>
> got warning:
>
> [ =A0 =A00.000000] node 0 must be removed before remove section 16399
> [ =A0 =A00.000000] node 1 must be removed before remove section 16399
> [ =A0 =A00.000000] node 2 must be removed before remove section 16399
> [ =A0 =A00.000000] node 3 must be removed before remove section 16399
> [ =A0 =A00.000000] node 4 must be removed before remove section 16399
> [ =A0 =A00.000000] node 5 must be removed before remove section 16399
> [ =A0 =A00.000000] node 6 must be removed before remove section 16399
>
> location for usemap:
>
> [ =A0 =A00.000000] Initmem setup node 0 [mem 0x00000000-0x407fffffff]
> [ =A0 =A00.000000] =A0 NODE_DATA [mem 0x407ffd9000-0x407fffffff]
> [ =A0 =A00.000000] Initmem setup node 1 [mem 0x4080000000-0x807fffffff]
> [ =A0 =A00.000000] =A0 NODE_DATA [mem 0x807ffd9000-0x807fffffff]
> [ =A0 =A00.000000] Initmem setup node 2 [mem 0x8080000000-0xc07fffffff]
> [ =A0 =A00.000000] =A0 NODE_DATA [mem 0xc07ffd9000-0xc07fffffff]
> [ =A0 =A00.000000] Initmem setup node 3 [mem 0xc080000000-0x1007fffffff]
> [ =A0 =A00.000000] =A0 NODE_DATA [mem 0x1007ffd9000-0x1007fffffff]
> [ =A0 =A00.000000] Initmem setup node 4 [mem 0x10080000000-0x1407fffffff]
> [ =A0 =A00.000000] =A0 NODE_DATA [mem 0x1407ffd9000-0x1407fffffff]
> [ =A0 =A00.000000] Initmem setup node 5 [mem 0x14080000000-0x1807fffffff]
> [ =A0 =A00.000000] =A0 NODE_DATA [mem 0x1807ffd9000-0x1807fffffff]
> [ =A0 =A00.000000] Initmem setup node 6 [mem 0x18080000000-0x1c07fffffff]
> [ =A0 =A00.000000] =A0 NODE_DATA [mem 0x1c07ffd9000-0x1c07fffffff]
> [ =A0 =A00.000000] Initmem setup node 7 [mem 0x1c080000000-0x2007fffffff]
> [ =A0 =A00.000000] =A0 NODE_DATA [mem 0x2007fbd8000-0x2007fbfefff]
> [ =A0 =A00.000000] MEMBLOCK configuration:
> [ =A0 =A00.000000] =A0memory size =3D 0x1ffff6d5000 reserved size =3D 0x1=
05a544ee
> [ =A0 =A00.000000] =A0memory.cnt =A0=3D 0xa
> [ =A0 =A00.000000] =A0memory[0x0] =A0 =A0 [0x00010000-0x00094fff], 0x8500=
0 bytes on node 0
> [ =A0 =A00.000000] =A0memory[0x1] =A0 =A0 [0x00100000-0x7f74ffff], 0x7f65=
0000
> bytes on node 0
> [ =A0 =A00.000000] =A0memory[0x2] =A0 =A0 [0x100000000-0x407fffffff],
> 0x3f80000000 bytes on node 0
> [ =A0 =A00.000000] =A0memory[0x3] =A0 =A0 [0x4080000000-0x807fffffff],
> 0x4000000000 bytes on node 1
> [ =A0 =A00.000000] =A0memory[0x4] =A0 =A0 [0x8080000000-0xc07fffffff],
> 0x4000000000 bytes on node 2
> [ =A0 =A00.000000] =A0memory[0x5] =A0 =A0 [0xc080000000-0x1007fffffff],
> 0x4000000000 bytes on node 3
> [ =A0 =A00.000000] =A0memory[0x6] =A0 =A0 [0x10080000000-0x1407fffffff],
> 0x4000000000 bytes on node 4
> [ =A0 =A00.000000] =A0memory[0x7] =A0 =A0 [0x14080000000-0x1807fffffff],
> 0x4000000000 bytes on node 5
> [ =A0 =A00.000000] =A0memory[0x8] =A0 =A0 [0x18080000000-0x1c07fffffff],
> 0x4000000000 bytes on node 6
> [ =A0 =A00.000000] =A0memory[0x9] =A0 =A0 [0x1c080000000-0x2007fffffff],
> 0x4000000000 bytes on node 7
> [ =A0 =A00.000000] =A0reserved.cnt =A0=3D 0x10
> [ =A0 =A00.000000] =A0reserved[0x0] =A0 [0x0008f000-0x00094fff], 0x6000 b=
ytes
> [ =A0 =A00.000000] =A0reserved[0x1] =A0 [0x00095400-0x000fffff], 0x6ac00 =
bytes
> [ =A0 =A00.000000] =A0reserved[0x2] =A0 [0x01000000-0x02afb9db], 0x1afb9d=
c bytes
> [ =A0 =A00.000000] =A0reserved[0x3] =A0 [0x02cfb9dc-0x0383f8ad], 0xb43ed2=
 bytes
> [ =A0 =A00.000000] =A0reserved[0x4] =A0 [0x7ccd9000-0x7d0d5fff], 0x3fd000=
 bytes
> [ =A0 =A00.000000] =A0reserved[0x5] =A0 [0x7d0d8000-0x7f744fff], 0x266d00=
0 bytes
> [ =A0 =A00.000000] =A0reserved[0x6] =A0 [0x407ffd9000-0x407fffffff], 0x27=
000 bytes
> [ =A0 =A00.000000] =A0reserved[0x7] =A0 [0x807ffd9000-0x807fffffff], 0x27=
000 bytes
> [ =A0 =A00.000000] =A0reserved[0x8] =A0 [0xc07ffd9000-0xc07fffffff], 0x27=
000 bytes
> [ =A0 =A00.000000] =A0reserved[0x9] =A0 [0x1007ffd9000-0x1007fffffff], 0x=
27000 bytes
> [ =A0 =A00.000000] =A0reserved[0xa] =A0 [0x1407ffd9000-0x1407fffffff], 0x=
27000 bytes
> [ =A0 =A00.000000] =A0reserved[0xb] =A0 [0x1807ffd9000-0x1807fffffff], 0x=
27000 bytes
> [ =A0 =A00.000000] =A0reserved[0xc] =A0 [0x1c07ffd9000-0x1c07fffffff], 0x=
27000 bytes
> [ =A0 =A00.000000] =A0reserved[0xd] =A0 [0x1ff7f3f9000-0x2007f7fafff], 0x=
100402000 bytes
> [ =A0 =A00.000000] =A0reserved[0xe] =A0 [0x2007fbd8000-0x2007fbff03f], 0x=
27040 bytes
> [ =A0 =A00.000000] =A0reserved[0xf] =A0 [0x2007fc00000-0x2007fffffff], 0x=
400000 bytes
> [ =A0 =A00.000000] memblock_reserve: [0x1ff7eff9000-0x1ff7f3f8fff] usemap=
_map
> [ =A0 =A00.000000] memblock_reserve: [0x2007fbc4000-0x2007fbcffff] usemap=
 section
> [ =A0 =A00.000000] node 0 must be removed before remove section 16399
> [ =A0 =A00.000000] memblock_reserve: [0x2007fbb8000-0x2007fbc3fff] usemap=
 section
> [ =A0 =A00.000000] node 1 must be removed before remove section 16399
> [ =A0 =A00.000000] memblock_reserve: [0x2007fbac000-0x2007fbb7fff] usemap=
 section
> [ =A0 =A00.000000] node 2 must be removed before remove section 16399
> [ =A0 =A00.000000] memblock_reserve: [0x2007fba0000-0x2007fbabfff] usemap=
 section
> [ =A0 =A00.000000] node 3 must be removed before remove section 16399
> [ =A0 =A00.000000] memblock_reserve: [0x2007fb94000-0x2007fb9ffff] usemap=
 section
> [ =A0 =A00.000000] node 4 must be removed before remove section 16399
> [ =A0 =A00.000000] memblock_reserve: [0x2007fb88000-0x2007fb93fff] usemap=
 section
> [ =A0 =A00.000000] node 5 must be removed before remove section 16399
> [ =A0 =A00.000000] memblock_reserve: [0x2007fb7c000-0x2007fb87fff] usemap=
 section
> [ =A0 =A00.000000] node 6 must be removed before remove section 16399
> [ =A0 =A00.000000] memblock_reserve: [0x2007fb70000-0x2007fb7bfff] usemap=
 section
>
> reverting that patch fixes the problem.
>
> will get correct...
>
> [ =A0 =A00.000000] memblock_reserve: [0x1ff7eff9000-0x1ff7f3f8fff] usemap=
_map
> [ =A0 =A00.000000] memblock_reserve: [0x407ffc4000-0x407ffcffff] usermap =
section
> [ =A0 =A00.000000] memblock_reserve: [0x807ffc5000-0x807ffd0fff] usermap =
section
> [ =A0 =A00.000000] memblock_reserve: [0xc07ffc5000-0xc07ffd0fff] usermap =
section
> [ =A0 =A00.000000] memblock_reserve: [0x1007ffc5000-0x1007ffd0fff] userma=
p section
> [ =A0 =A00.000000] memblock_reserve: [0x1407ffc5000-0x1407ffd0fff] userma=
p section
> [ =A0 =A00.000000] memblock_reserve: [0x1807ffc5000-0x1807ffd0fff] userma=
p section
> [ =A0 =A00.000000] memblock_reserve: [0x1c07ffc5000-0x1c07ffd0fff] userma=
p section
> [ =A0 =A00.000000] memblock_reserve: [0x2007fbc4000-0x2007fbcffff] userma=
p section
>

attached patch fixes the problem.

you can decide if reverting the commit or apply the patch.

Thanks

Yinghai

--047d7b339cc1d3f37704c31a2f98
Content-Type: application/octet-stream; name="fix_usemap_goal.patch"
Content-Disposition: attachment; filename="fix_usemap_goal.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h3s1pw9t0

U3ViamVjdDogW1BBVENIXSBtbTogZml4IGdvYWwgY2FsY3VsYXRpbmcgd2l0aCB1c2VtYXAKClBB
R0VfU0VDVElPTl9NQVNLIHNob3VsZCBiZSB1c2VkIHdpdGggcGZuIGluc3RlYWQgb2YgcGEuCgpT
aWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CgpkaWZmIC0tZ2l0
IGEvbW0vc3BhcnNlLmMgYi9tbS9zcGFyc2UuYwppbmRleCA2YTRiZjkxLi5mZDAwOTI4IDEwMDY0
NAotLS0gYS9tbS9zcGFyc2UuYworKysgYi9tbS9zcGFyc2UuYwpAQCAtMjg3LDcgKzI4Nyw3IEBA
IHNwYXJzZV9lYXJseV91c2VtYXBzX2FsbG9jX3BnZGF0X3NlY3Rpb24oc3RydWN0IHBnbGlzdF9k
YXRhICpwZ2RhdCwKIAkgKiBmcm9tIHRoZSBzYW1lIHNlY3Rpb24gYXMgdGhlIHBnZGF0IHdoZXJl
IHBvc3NpYmxlIHRvIGF2b2lkCiAJICogdGhpcyBwcm9ibGVtLgogCSAqLwotCWdvYWwgPSBfX3Bh
KHBnZGF0KSAmIFBBR0VfU0VDVElPTl9NQVNLOworCWdvYWwgPSAoKF9fcGEocGdkYXQpID4+IFBB
R0VfU0hJRlQpICYgUEFHRV9TRUNUSU9OX01BU0spIDw8IFBBR0VfU0hJRlQ7CiAJaG9zdF9wZ2Rh
dCA9IE5PREVfREFUQShlYXJseV9wZm5fdG9fbmlkKGdvYWwgPj4gUEFHRV9TSElGVCkpOwogCXJl
dHVybiBfX2FsbG9jX2Jvb3RtZW1fbm9kZV9ub3BhbmljKGhvc3RfcGdkYXQsIHNpemUsCiAJCQkJ
CSAgICBTTVBfQ0FDSEVfQllURVMsIGdvYWwpOwo=
--047d7b339cc1d3f37704c31a2f98--
