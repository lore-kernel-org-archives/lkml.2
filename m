Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2FWS6F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 14:58:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39347 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2FWS6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 14:58:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120623091752.GK27816@cmpxchg.org>
References: <20120529220636.AAA66A0308@akpm.mtv.corp.google.com>
	<CAE9FiQVEq5j1zoKS31fgfG_3xZSyfqsjdDorDku-Sgj6BTShEg@mail.gmail.com>
	<CAE9FiQXR+3k4QmOJe59xom+JW5JZAP3znRXQwdyqV5LMEPCw2g@mail.gmail.com>
	<20120623091752.GK27816@cmpxchg.org>
Date: Sat, 23 Jun 2012 11:58:02 -0700
X-Google-Sender-Auth: qnpIYlwGH_oixDrW3kaTjPfca8U
Message-ID: <CAE9FiQXYG0=XFAzZStExBTNqdnRPMSjASNydM45GC_G6qfuNkA@mail.gmail.com>
Subject: Re: [patch 046/181] mm: remove sparsemem allocation details from the
 bootmem allocator
From: Yinghai Lu <yinghai@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b339cc10a220004c32854e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b339cc10a220004c32854e1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 23, 2012 at 2:17 AM, Johannes Weiner <hannes@cmpxchg.org> wrote=
:
> On Fri, Jun 22, 2012 at 07:05:45PM -0700, Yinghai Lu wrote:
>> On Fri, Jun 22, 2012 at 6:11 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Tue, May 29, 2012 at 3:06 PM, =A0<akpm@linux-foundation.org> wrote:
>> >> From: Johannes Weiner <hannes@cmpxchg.org>
>> >> Subject: mm: remove sparsemem allocation details from the bootmem all=
ocator
>> >>
>> >> alloc_bootmem_section() derives allocation area constraints from the
>> >> specified sparsemem section. =A0This is a bit specific for a generic =
memory
>> >> allocator like bootmem, though, so move it over to sparsemem.
>> >>
>> >> As __alloc_bootmem_node_nopanic() already retries failed allocations =
with
>> >> relaxed area constraints, the fallback code in sparsemem.c can be rem=
oved
>> >> and the code becomes a bit more compact overall.
>> >>
>> >> [akpm@linux-foundation.org: fix build]
>> >> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> >> Acked-by: Tejun Heo <tj@kernel.org>
>> >> Acked-by: David S. Miller <davem@davemloft.net>
>> >> Cc: Yinghai Lu <yinghai@kernel.org>
>> >> Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
>> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> >
>> > hi, this one cause regression, will put usemap to last node's memory
>> > instead of each node.
>>
>> attached patch fixes the problem.
>
> Sorry for the trouble and thanks for the patch! =A0The number of bugs in
> these three lines is too damn high...
>
yeah, i should run Andrew -mm early.

Andrew, Do you have git tree for your -mm?
So I could merge it to my local tree.
now i only have tip, pci, scsi, net, driver-core, usb, tty in my local tree=
.

...
>> =A0 =A0 =A0 =A0*/
>> - =A0 =A0 goal =3D __pa(pgdat) & PAGE_SECTION_MASK;
>> + =A0 =A0 goal =3D ((__pa(pgdat) >> PAGE_SHIFT) & PAGE_SECTION_MASK) << =
PAGE_SHIFT;
>
> How about
>
> =A0 =A0 =A0 =A0goal =3D __pa(pgdat) & (PAGE_SECTION_MASK << PAGE_SHIFT);
>
> instead?

yeah.

After closely looking, looks like we need to revert the commit or
apply -v2 patch.

old sequence is : try same section range at first.
this commit will try [start_of_section, end_of_same_node_range], so
could have chance to get

Yinghai

--047d7b339cc10a220004c32854e1
Content-Type: application/octet-stream; name="fix_usemap_goal_v2.patch"
Content-Disposition: attachment; filename="fix_usemap_goal_v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h3t1ov970

U3ViamVjdDogW1BBVENIXSBtbTogZml4IGdvYWwgY2FsY3VsYXRpbmcgd2l0aCB1c2VtYXAKClBB
R0VfU0VDVElPTl9NQVNLIHNob3VsZCBiZSB1c2VkIHdpdGggcGZuIGluc3RlYWQgb2YgcGEuCgpB
bHNvIHJlc3RvcmUgdGhlIG9sZCBiZWhhdm9pcjoKCWxpbWl0IHRoZSBhbGxvY2F0aW5nIHRvIHNh
bWUgc2VjdGlvbiBhdCBmaXJzdC4KCW5lZWQgdG8gZXhwb3NlIF9fYWxsb2NfYm9vdG1lbV9ub2Rl
X25vcGFuaWMgd2l0aCBsaW1pdC4KCi12MjogYWRkIGxpbWl0IG9mIHNhbWUgc2VjdGlvbgoKU2ln
bmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBpbmNsdWRl
L2xpbnV4L2Jvb3RtZW0uaCB8ICAgIDUgKysrKysKIG1tL2Jvb3RtZW0uYyAgICAgICAgICAgIHwg
ICAgMiArLQogbW0vbm9ib290bWVtLmMgICAgICAgICAgfCAgICAyICstCiBtbS9zcGFyc2UuYyAg
ICAgICAgICAgICB8ICAgMjIgKysrKysrKysrKysrKysrKy0tLS0tLQogNCBmaWxlcyBjaGFuZ2Vk
LCAyMyBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9tbS9z
cGFyc2UuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9tbS9zcGFyc2UuYworKysgbGlu
dXgtMi42L21tL3NwYXJzZS5jCkBAIC0yNzUsOCArMjc1LDkgQEAgc3RhdGljIHVuc2lnbmVkIGxv
bmcgKiBfX2luaXQKIHNwYXJzZV9lYXJseV91c2VtYXBzX2FsbG9jX3BnZGF0X3NlY3Rpb24oc3Ry
dWN0IHBnbGlzdF9kYXRhICpwZ2RhdCwKIAkJCQkJIHVuc2lnbmVkIGxvbmcgc2l6ZSkKIHsKLQlw
Z19kYXRhX3QgKmhvc3RfcGdkYXQ7Ci0JdW5zaWduZWQgbG9uZyBnb2FsOworCXVuc2lnbmVkIGxv
bmcgZ29hbCwgbGltaXQ7CisJdW5zaWduZWQgbG9uZyAqcDsKKwlpbnQgbmlkOwogCS8qCiAJICog
QSBwYWdlIG1heSBjb250YWluIHVzZW1hcHMgZm9yIG90aGVyIHNlY3Rpb25zIHByZXZlbnRpbmcg
dGhlCiAJICogcGFnZSBiZWluZyBmcmVlZCBhbmQgbWFraW5nIGEgc2VjdGlvbiB1bnJlbW92YWJs
ZSB3aGlsZQpAQCAtMjg3LDEwICsyODgsMTkgQEAgc3BhcnNlX2Vhcmx5X3VzZW1hcHNfYWxsb2Nf
cGdkYXRfc2VjdGlvbgogCSAqIGZyb20gdGhlIHNhbWUgc2VjdGlvbiBhcyB0aGUgcGdkYXQgd2hl
cmUgcG9zc2libGUgdG8gYXZvaWQKIAkgKiB0aGlzIHByb2JsZW0uCiAJICovCi0JZ29hbCA9IF9f
cGEocGdkYXQpICYgUEFHRV9TRUNUSU9OX01BU0s7Ci0JaG9zdF9wZ2RhdCA9IE5PREVfREFUQShl
YXJseV9wZm5fdG9fbmlkKGdvYWwgPj4gUEFHRV9TSElGVCkpOwotCXJldHVybiBfX2FsbG9jX2Jv
b3RtZW1fbm9kZV9ub3BhbmljKGhvc3RfcGdkYXQsIHNpemUsCi0JCQkJCSAgICBTTVBfQ0FDSEVf
QllURVMsIGdvYWwpOworCWdvYWwgPSBfX3BhKHBnZGF0KSAmIChQQUdFX1NFQ1RJT05fTUFTSyA8
PCBQQUdFX1NISUZUKTsKKwlsaW1pdCA9IGdvYWwgKyAoMVVMIDw8IFBBX1NFQ1RJT05fU0hJRlQp
OworCW5pZCA9IGVhcmx5X3Bmbl90b19uaWQoZ29hbCA+PiBQQUdFX1NISUZUKTsKKworYWdhaW46
CisJcCA9IF9fX2FsbG9jX2Jvb3RtZW1fbm9kZV9ub3BhbmljKE5PREVfREFUQShuaWQpLCBzaXpl
LAorCQkJCQkgIFNNUF9DQUNIRV9CWVRFUywgZ29hbCwgbGltaXQpOworCWlmICghcCAmJiBsaW1p
dCkgeworCQlsaW1pdCA9IDA7CisJCWdvdG8gYWdhaW47CisJfQorCisJcmV0dXJuIHA7CiB9CiAK
IHN0YXRpYyB2b2lkIF9faW5pdCBjaGVja191c2VtYXBfc2VjdGlvbl9ucihpbnQgbmlkLCB1bnNp
Z25lZCBsb25nICp1c2VtYXApCkluZGV4OiBsaW51eC0yLjYvaW5jbHVkZS9saW51eC9ib290bWVt
LmgKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvaW5jbHVkZS9saW51eC9ib290bWVtLmgK
KysrIGxpbnV4LTIuNi9pbmNsdWRlL2xpbnV4L2Jvb3RtZW0uaApAQCAtOTEsNiArOTEsMTEgQEAg
ZXh0ZXJuIHZvaWQgKl9fYWxsb2NfYm9vdG1lbV9ub2RlX25vcGFuaQogCQkJCSAgdW5zaWduZWQg
bG9uZyBzaXplLAogCQkJCSAgdW5zaWduZWQgbG9uZyBhbGlnbiwKIAkJCQkgIHVuc2lnbmVkIGxv
bmcgZ29hbCk7Cit2b2lkICpfX19hbGxvY19ib290bWVtX25vZGVfbm9wYW5pYyhwZ19kYXRhX3Qg
KnBnZGF0LAorCQkJCSAgdW5zaWduZWQgbG9uZyBzaXplLAorCQkJCSAgdW5zaWduZWQgbG9uZyBh
bGlnbiwKKwkJCQkgIHVuc2lnbmVkIGxvbmcgZ29hbCwKKwkJCQkgIHVuc2lnbmVkIGxvbmcgbGlt
aXQpOwogZXh0ZXJuIHZvaWQgKl9fYWxsb2NfYm9vdG1lbV9sb3codW5zaWduZWQgbG9uZyBzaXpl
LAogCQkJCSB1bnNpZ25lZCBsb25nIGFsaWduLAogCQkJCSB1bnNpZ25lZCBsb25nIGdvYWwpOwpJ
bmRleDogbGludXgtMi42L21tL2Jvb3RtZW0uYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3Jp
Zy9tbS9ib290bWVtLmMKKysrIGxpbnV4LTIuNi9tbS9ib290bWVtLmMKQEAgLTY5OCw3ICs2OTgs
NyBAQCB2b2lkICogX19pbml0IF9fYWxsb2NfYm9vdG1lbSh1bnNpZ25lZCBsCiAJcmV0dXJuIF9f
X2FsbG9jX2Jvb3RtZW0oc2l6ZSwgYWxpZ24sIGdvYWwsIGxpbWl0KTsKIH0KIAotc3RhdGljIHZv
aWQgKiBfX2luaXQgX19fYWxsb2NfYm9vdG1lbV9ub2RlX25vcGFuaWMocGdfZGF0YV90ICpwZ2Rh
dCwKK3ZvaWQgKiBfX2luaXQgX19fYWxsb2NfYm9vdG1lbV9ub2RlX25vcGFuaWMocGdfZGF0YV90
ICpwZ2RhdCwKIAkJCQl1bnNpZ25lZCBsb25nIHNpemUsIHVuc2lnbmVkIGxvbmcgYWxpZ24sCiAJ
CQkJdW5zaWduZWQgbG9uZyBnb2FsLCB1bnNpZ25lZCBsb25nIGxpbWl0KQogewpJbmRleDogbGlu
dXgtMi42L21tL25vYm9vdG1lbS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL21tL25v
Ym9vdG1lbS5jCisrKyBsaW51eC0yLjYvbW0vbm9ib290bWVtLmMKQEAgLTI3NCw3ICsyNzQsNyBA
QCB2b2lkICogX19pbml0IF9fYWxsb2NfYm9vdG1lbSh1bnNpZ25lZCBsCiAJcmV0dXJuIF9fX2Fs
bG9jX2Jvb3RtZW0oc2l6ZSwgYWxpZ24sIGdvYWwsIGxpbWl0KTsKIH0KIAotc3RhdGljIHZvaWQg
KiBfX2luaXQgX19fYWxsb2NfYm9vdG1lbV9ub2RlX25vcGFuaWMocGdfZGF0YV90ICpwZ2RhdCwK
K3ZvaWQgKiBfX2luaXQgX19fYWxsb2NfYm9vdG1lbV9ub2RlX25vcGFuaWMocGdfZGF0YV90ICpw
Z2RhdCwKIAkJCQkJCSAgIHVuc2lnbmVkIGxvbmcgc2l6ZSwKIAkJCQkJCSAgIHVuc2lnbmVkIGxv
bmcgYWxpZ24sCiAJCQkJCQkgICB1bnNpZ25lZCBsb25nIGdvYWwsCg==
--047d7b339cc10a220004c32854e1--
