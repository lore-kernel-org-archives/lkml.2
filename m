Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2EAHTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 03:19:35 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:44218 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2EAHTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 03:19:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUH1SiToMBanL7brzem920rCoq70hh3KKxH-ps190=51w@mail.gmail.com>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
	<1332135781-13695-6-git-send-email-yinghai@kernel.org>
	<CAErSpo5AnsmfQs4oa3P7AQyPTJ+YqCVVh5p2L=bmDY=A+BO9PQ@mail.gmail.com>
	<CAE9FiQUH1SiToMBanL7brzem920rCoq70hh3KKxH-ps190=51w@mail.gmail.com>
Date: Tue, 1 May 2012 00:19:33 -0700
X-Google-Sender-Auth: ixda_Rap15pTKtqhR5o59Q5UerA
Message-ID: <CAE9FiQW=BLxjHGKzKQvm15PSyESh+H_rrPkTEZGE-8uWboJWVg@mail.gmail.com>
Subject: Re: [PATCH -v11 05/30] PCI: Add busn_res operation functions
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b2ee18b72388704bef4647d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b2ee18b72388704bef4647d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 30, 2012 at 5:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Apr 30, 2012 at 4:29 PM, Bjorn Helgaas <bhelgaas@google.com> wrot=
e:
>> On Sun, Mar 18, 2012 at 11:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> +void pci_bus_update_busn_res_end(struct pci_bus *b, int bus_max)
>>> +{
>>> + =A0 =A0 =A0 struct resource *res =3D &b->busn_res;
>>> + =A0 =A0 =A0 struct resource old_res =3D *res;
>>> +
>>> + =A0 =A0 =A0 res->end =3D bus_max;
>>
>> I've mentioned before that I'm not comfortable with updating the
>> struct resource after it's been inserted into the tree. =A0If you want
>> to do an in-place update, I think you need to add a new interface in
>> kernel/resource.c so it can make sure the resource tree remains
>> consistent.
>
> ok, will add one function in kernel/resource.c to make sure that end
> could be updated safely
> by checking parent and children.

Rebased busn_alloc branch and added attached patch into that.

as for removing bus->subordinate and bus->secondary, like to do that later.

Thanks

Yinghai

--047d7b2ee18b72388704bef4647d
Content-Type: application/octet-stream; name="resource_update.patch"
Content-Disposition: attachment; filename="resource_update.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1omimxk0

U3ViamVjdDogW1BBVENIXSByZXNvdXJjZXM6IFVwZGF0ZSByZWdpc3RlcmVkIHJlc291cmNlIHN0
YXJ0L2VuZCBpbiB0cmVlLgoKTmVlZCB0byBjaGVjayBpZiB0aGUgbmV3IHJhbmdlIGlzCjEuIGZ1
bGx5IGNvdmVyZWQgYnkgcGFyZW50IHJlc291cmNlIGlmIGl0IGV4aXN0cwoyLiBub3Qgb3Zlcmxh
cHBlZCB3aXRoIHNpYmxpbmcgcmVzb3VyY2VzIGlmIHRoZXkgZXhpc3QuCjMuIGZ1bGx5IGNvdmVy
aW5nIGNoaWxyZW4gcmVzb3VyY2VzIGlmIHRoZXkgZXhpc3QuCgpTaWduZWQtb2ZmLWJ5OiBZaW5n
aGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CkNjOiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4
LWZvdW5kYXRpb24ub3JnPgoKLS0tCiBpbmNsdWRlL2xpbnV4L2lvcG9ydC5oIHwgICAgMiArKwog
a2VybmVsL3Jlc291cmNlLmMgICAgICB8ICAgNDkgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCA1MSBpbnNlcnRpb25zKCsp
CgpJbmRleDogbGludXgtMi42L2luY2x1ZGUvbGludXgvaW9wb3J0LmgKPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0g
bGludXgtMi42Lm9yaWcvaW5jbHVkZS9saW51eC9pb3BvcnQuaAorKysgbGludXgtMi42L2luY2x1
ZGUvbGludXgvaW9wb3J0LmgKQEAgLTE0MSw2ICsxNDEsOCBAQCBleHRlcm4gc3RydWN0IHJlc291
cmNlICpyZXF1ZXN0X3Jlc291cmNlCiBleHRlcm4gaW50IHJlcXVlc3RfcmVzb3VyY2Uoc3RydWN0
IHJlc291cmNlICpyb290LCBzdHJ1Y3QgcmVzb3VyY2UgKm5ldyk7CiBleHRlcm4gaW50IHJlbGVh
c2VfcmVzb3VyY2Uoc3RydWN0IHJlc291cmNlICpuZXcpOwogdm9pZCByZWxlYXNlX2NoaWxkX3Jl
c291cmNlcyhzdHJ1Y3QgcmVzb3VyY2UgKm5ldyk7CitpbnQgdXBkYXRlX3Jlc291cmNlKHN0cnVj
dCByZXNvdXJjZSAqciwgcmVzb3VyY2Vfc2l6ZV90IHN0YXJ0LAorCQkJIHJlc291cmNlX3NpemVf
dCBlbmQpOwogZXh0ZXJuIHZvaWQgcmVzZXJ2ZV9yZWdpb25fd2l0aF9zcGxpdChzdHJ1Y3QgcmVz
b3VyY2UgKnJvb3QsCiAJCQkgICAgIHJlc291cmNlX3NpemVfdCBzdGFydCwgcmVzb3VyY2Vfc2l6
ZV90IGVuZCwKIAkJCSAgICAgY29uc3QgY2hhciAqbmFtZSk7CkluZGV4OiBsaW51eC0yLjYva2Vy
bmVsL3Jlc291cmNlLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcva2VybmVsL3Jlc291
cmNlLmMKKysrIGxpbnV4LTIuNi9rZXJuZWwvcmVzb3VyY2UuYwpAQCAtMjI3LDYgKzIyNyw1NSBA
QCB2b2lkIHJlbGVhc2VfY2hpbGRfcmVzb3VyY2VzKHN0cnVjdCByZXNvCiAJd3JpdGVfdW5sb2Nr
KCZyZXNvdXJjZV9sb2NrKTsKIH0KIAoraW50IHVwZGF0ZV9yZXNvdXJjZShzdHJ1Y3QgcmVzb3Vy
Y2UgKnIsIHJlc291cmNlX3NpemVfdCBzdGFydCwKKwkJCXJlc291cmNlX3NpemVfdCBlbmQpCit7
CisJaW50IHJldCA9IDA7CisJc3RydWN0IHJlc291cmNlICpwYXJlbnQ7CisJc3RydWN0IHJlc291
cmNlICpwOworCisJaWYgKHN0YXJ0ID4gZW5kKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCXdyaXRl
X2xvY2soJnJlc291cmNlX2xvY2spOworCXBhcmVudCA9IHItPnBhcmVudDsKKwlpZiAocGFyZW50
KSB7CisJCWlmIChzdGFydCA8IHBhcmVudC0+c3RhcnQgfHwKKwkJICAgIGVuZCA+IHBhcmVudC0+
ZW5kKSB7CisJCQlyZXQgPSAtRUlOVkFMOworCQkJZ290byBvdXQ7CisJCX0KKworCQlwID0gcGFy
ZW50LT5jaGlsZDsKKwkJd2hpbGUgKHApIHsKKwkJCWlmIChwICE9IHIgJiYKKwkJCSAgICBtYXhf
dChyZXNvdXJjZV9zaXplX3QsIHAtPnN0YXJ0LCBzdGFydCkgPD0KKwkJCSAgICBtaW5fdChyZXNv
dXJjZV9zaXplX3QsIHAtPmVuZCwgZW5kKSkgeworCQkJCXJldCA9IC1FSU5WQUw7CisJCQkJZ290
byBvdXQ7CisJCQl9CisJCQlwID0gcC0+c2libGluZzsKKwkJfQorCX0KKworCXAgPSByLT5jaGls
ZDsKKwl3aGlsZSAocCkgeworCQlpZiAocC0+c3RhcnQgPCBzdGFydCB8fCBwLT5lbmQgPiBlbmQp
IHsKKwkJCXJldCA9IC1FSU5WQUw7CisJCQlnb3RvIG91dDsKKwkJfQorCQlwID0gcC0+c2libGlu
ZzsKKwl9CisKKwlyLT5zdGFydCA9IHN0YXJ0OworCXItPmVuZCA9IGVuZDsKKworb3V0OgorCXdy
aXRlX3VubG9jaygmcmVzb3VyY2VfbG9jayk7CisKKwlyZXR1cm4gcmV0OworfQorCiAvKioKICAq
IHJlcXVlc3RfcmVzb3VyY2VfY29uZmxpY3QgLSByZXF1ZXN0IGFuZCByZXNlcnZlIGFuIEkvTyBv
ciBtZW1vcnkgcmVzb3VyY2UKICAqIEByb290OiByb290IHJlc291cmNlIGRlc2NyaXB0b3IK
--047d7b2ee18b72388704bef4647d--
