Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab0GARUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:20:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:14727 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab0GARUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:20:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,520,1272870000"; 
   d="scan'208";a="581911154"
Message-ID: <4C2CCE67.6070600@intel.com>
Date: Thu, 01 Jul 2010 10:20:39 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Woodhouse, David" <david.woodhouse@intel.com>
CC: Chris Li <lkml@chrisli.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>	 <4C29420D.2010406@intel.com>	 <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>	 <4C2A8879.8010000@intel.com>	 <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>	 <4C2AC55E.3040303@intel.com>	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>	 <1277923422.16256.8.camel@localhost>  <4C2B9DAC.1030806@intel.com>	 <1277928125.18854.0.camel@localhost>  <4C2BBACF.3080405@intel.com>	 <1277965264.18854.16.camel@localhost>  <4C2C3B07.7050200@intel.com>	 <1277968336.4945.3.camel@localhost>  <4C2C4319.6090906@intel.com> <1277972137.12558.2.camel@localhost>
In-Reply-To: <1277972137.12558.2.camel@localhost>
Content-Type: multipart/mixed;
 boundary="------------060401010202070209030600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060401010202070209030600
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/1/2010 1:15 AM, Woodhouse, David wrote:
> On Thu, 2010-07-01 at 08:26 +0100, Williams, Dan J wrote:
>> On 7/1/2010 12:12 AM, Woodhouse, David wrote:
>>> On Thu, 2010-07-01 at 07:51 +0100, Williams, Dan J wrote:
>>>> This version of the device only exists on the 5400 chipset and always
>>>> has its own iommu, but since other platforms get the DMAR entry right I
>>>> think this hammer is too big?  Wouldn't this break VT-d operation on
>>>> non-busted platforms?
>>>
>>> That just means we have to get the quirk right. Does 'this version' of
>>> the device have its own PCI ID? We can always fall back to checking the
>>> ID of the device at 0000:00:00.0 to check which chipset we're on.
>>>
>>
>> PCI_DEVICE_ID_INTEL_IOAT_SNB only exists on this chipset
>
> Something like this, then?
>

Thanks David!

Chris, attached is a combined patch with David's catch for the VT-d 
misconfiguration, and some code to more gracefully handle this init 
failure in the driver.  Can you see if this resolves the problem? 
(remove the prior patches I have sent).

Thanks,
Dan


--------------060401010202070209030600
Content-Type: text/plain;
 name="ioat-catch-broken-vtd.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ioat-catch-broken-vtd.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZG1hL2lvYXQvZG1hLmggYi9kcml2ZXJzL2RtYS9pb2F0
L2RtYS5oCmluZGV4IDZkM2E3M2IuLjUyMTZjOGEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZG1h
L2lvYXQvZG1hLmgKKysrIGIvZHJpdmVycy9kbWEvaW9hdC9kbWEuaApAQCAtOTcsNiArOTcs
NyBAQCBzdHJ1Y3QgaW9hdF9jaGFuX2NvbW1vbiB7CiAJI2RlZmluZSBJT0FUX1JFU0VUX1BF
TkRJTkcgMgogCSNkZWZpbmUgSU9BVF9LT0JKX0lOSVRfRkFJTCAzCiAJI2RlZmluZSBJT0FU
X1JFU0hBUEVfUEVORElORyA0CisJI2RlZmluZSBJT0FUX1JVTiA1CiAJc3RydWN0IHRpbWVy
X2xpc3QgdGltZXI7CiAJI2RlZmluZSBDT01QTEVUSU9OX1RJTUVPVVQgbXNlY3NfdG9famlm
ZmllcygxMDApCiAJI2RlZmluZSBJRExFX1RJTUVPVVQgbXNlY3NfdG9famlmZmllcygyMDAw
KQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9kbWEvaW9hdC9kbWFfdjIuYyBiL2RyaXZlcnMvZG1h
L2lvYXQvZG1hX3YyLmMKaW5kZXggM2M4YjMyYS4uNzc5ZjRkYSAxMDA2NDQKLS0tIGEvZHJp
dmVycy9kbWEvaW9hdC9kbWFfdjIuYworKysgYi9kcml2ZXJzL2RtYS9pb2F0L2RtYV92Mi5j
CkBAIC0yODcsNyArMjg3LDEwIEBAIHZvaWQgaW9hdDJfdGltZXJfZXZlbnQodW5zaWduZWQg
bG9uZyBkYXRhKQogCQkJY2hhbmVyciA9IHJlYWRsKGNoYW4tPnJlZ19iYXNlICsgSU9BVF9D
SEFORVJSX09GRlNFVCk7CiAJCQlkZXZfZXJyKHRvX2RldihjaGFuKSwgIiVzOiBDaGFubmVs
IGhhbHRlZCAoJXgpXG4iLAogCQkJCV9fZnVuY19fLCBjaGFuZXJyKTsKLQkJCUJVR19PTihp
c19pb2F0X2J1ZyhjaGFuZXJyKSk7CisJCQlpZiAodGVzdF9iaXQoSU9BVF9SVU4sICZjaGFu
LT5zdGF0ZSkpCisJCQkJQlVHX09OKGlzX2lvYXRfYnVnKGNoYW5lcnIpKTsKKwkJCWVsc2Ug
Lyogd2UgbmV2ZXIgZ290IG9mZiB0aGUgZ3JvdW5kICovCisJCQkJcmV0dXJuOwogCQl9CiAK
IAkJLyogaWYgd2UgaGF2ZW4ndCBtYWRlIHByb2dyZXNzIGFuZCB3ZSBoYXZlIGFscmVhZHkK
QEAgLTQ5Miw2ICs0OTUsOCBAQCBzdGF0aWMgc3RydWN0IGlvYXRfcmluZ19lbnQgKippb2F0
Ml9hbGxvY19yaW5nKHN0cnVjdCBkbWFfY2hhbiAqYywgaW50IG9yZGVyLCBnZgogCXJldHVy
biByaW5nOwogfQogCit2b2lkIGlvYXQyX2ZyZWVfY2hhbl9yZXNvdXJjZXMoc3RydWN0IGRt
YV9jaGFuICpjKTsKKwogLyogaW9hdDJfYWxsb2NfY2hhbl9yZXNvdXJjZXMgLSBhbGxvY2F0
ZS9pbml0aWFsaXplIGlvYXQyIGRlc2NyaXB0b3IgcmluZwogICogQGNoYW46IGNoYW5uZWwg
dG8gYmUgaW5pdGlhbGl6ZWQKICAqLwpAQCAtNTAwLDYgKzUwNSw3IEBAIGludCBpb2F0Ml9h
bGxvY19jaGFuX3Jlc291cmNlcyhzdHJ1Y3QgZG1hX2NoYW4gKmMpCiAJc3RydWN0IGlvYXQy
X2RtYV9jaGFuICppb2F0ID0gdG9faW9hdDJfY2hhbihjKTsKIAlzdHJ1Y3QgaW9hdF9jaGFu
X2NvbW1vbiAqY2hhbiA9ICZpb2F0LT5iYXNlOwogCXN0cnVjdCBpb2F0X3JpbmdfZW50ICoq
cmluZzsKKwl1NjQgc3RhdHVzOwogCWludCBvcmRlcjsKIAogCS8qIGhhdmUgd2UgYWxyZWFk
eSBiZWVuIHNldCB1cD8gKi8KQEAgLTU0MCw3ICs1NDYsMjAgQEAgaW50IGlvYXQyX2FsbG9j
X2NoYW5fcmVzb3VyY2VzKHN0cnVjdCBkbWFfY2hhbiAqYykKIAl0YXNrbGV0X2VuYWJsZSgm
Y2hhbi0+Y2xlYW51cF90YXNrKTsKIAlpb2F0Ml9zdGFydF9udWxsX2Rlc2MoaW9hdCk7CiAK
LQlyZXR1cm4gMSA8PCBpb2F0LT5hbGxvY19vcmRlcjsKKwkvKiBjaGVjayB0aGF0IHdlIGdv
dCBvZmYgdGhlIGdyb3VuZCAqLworCXVkZWxheSg1KTsKKwlzdGF0dXMgPSBpb2F0X2NoYW5z
dHMoY2hhbik7CisJaWYgKGlzX2lvYXRfYWN0aXZlKHN0YXR1cykgfHwgaXNfaW9hdF9pZGxl
KHN0YXR1cykpIHsKKwkJc2V0X2JpdChJT0FUX1JVTiwgJmNoYW4tPnN0YXRlKTsKKwkJcmV0
dXJuIDEgPDwgaW9hdC0+YWxsb2Nfb3JkZXI7CisJfSBlbHNlIHsKKwkJdTMyIGNoYW5lcnIg
PSByZWFkbChjaGFuLT5yZWdfYmFzZSArIElPQVRfQ0hBTkVSUl9PRkZTRVQpOworCisJCWRl
dl9lcnIodG9fZGV2KGNoYW4pLCAiZmFpbGVkIHRvIHN0YXJ0IGNoYW5uZWwgY2hhbmVycjog
JSN4XG4iLAorCQkJY2hhbmVycik7CisJCWlvYXQyX2ZyZWVfY2hhbl9yZXNvdXJjZXMoYyk7
CisJCXJldHVybiAtRUZBVUxUOworCX0KIH0KIAogYm9vbCByZXNoYXBlX3Jpbmcoc3RydWN0
IGlvYXQyX2RtYV9jaGFuICppb2F0LCBpbnQgb3JkZXIpCkBAIC03NzgsNiArNzk3LDcgQEAg
dm9pZCBpb2F0Ml9mcmVlX2NoYW5fcmVzb3VyY2VzKHN0cnVjdCBkbWFfY2hhbiAqYykKIAlk
ZWxfdGltZXJfc3luYygmY2hhbi0+dGltZXIpOwogCWRldmljZS0+Y2xlYW51cF9mbigodW5z
aWduZWQgbG9uZykgYyk7CiAJZGV2aWNlLT5yZXNldF9odyhjaGFuKTsKKwljbGVhcl9iaXQo
SU9BVF9SVU4sICZjaGFuLT5zdGF0ZSk7CiAKIAlzcGluX2xvY2tfYmgoJmNoYW4tPmNsZWFu
dXBfbG9jayk7CiAJc3Bpbl9sb2NrX2JoKCZpb2F0LT5wcmVwX2xvY2spOwpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9kbWEvaW9hdC9kbWFfdjMuYyBiL2RyaXZlcnMvZG1hL2lvYXQvZG1hX3Yz
LmMKaW5kZXggMWNkZDIyZS4uZDBmNDk5MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9kbWEvaW9h
dC9kbWFfdjMuYworKysgYi9kcml2ZXJzL2RtYS9pb2F0L2RtYV92My5jCkBAIC0zNjEsNyAr
MzYxLDEwIEBAIHN0YXRpYyB2b2lkIGlvYXQzX3RpbWVyX2V2ZW50KHVuc2lnbmVkIGxvbmcg
ZGF0YSkKIAkJCWNoYW5lcnIgPSByZWFkbChjaGFuLT5yZWdfYmFzZSArIElPQVRfQ0hBTkVS
Ul9PRkZTRVQpOwogCQkJZGV2X2Vycih0b19kZXYoY2hhbiksICIlczogQ2hhbm5lbCBoYWx0
ZWQgKCV4KVxuIiwKIAkJCQlfX2Z1bmNfXywgY2hhbmVycik7Ci0JCQlCVUdfT04oaXNfaW9h
dF9idWcoY2hhbmVycikpOworCQkJaWYgKHRlc3RfYml0KElPQVRfUlVOLCAmY2hhbi0+c3Rh
dGUpKQorCQkJCUJVR19PTihpc19pb2F0X2J1ZyhjaGFuZXJyKSk7CisJCQllbHNlIC8qIHdl
IG5ldmVyIGdvdCBvZmYgdGhlIGdyb3VuZCAqLworCQkJCXJldHVybjsKIAkJfQogCiAJCS8q
IGlmIHdlIGhhdmVuJ3QgbWFkZSBwcm9ncmVzcyBhbmQgd2UgaGF2ZSBhbHJlYWR5CmRpZmYg
LS1naXQgYS9kcml2ZXJzL3BjaS9kbWFyLmMgYi9kcml2ZXJzL3BjaS9kbWFyLmMKaW5kZXgg
MGExOTcwOC4uMjRhYzE3OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvZG1hci5jCisrKyBi
L2RyaXZlcnMvcGNpL2RtYXIuYwpAQCAtNTQzLDggKzU0MywyMCBAQCBkbWFyX2ZpbmRfbWF0
Y2hlZF9kcmhkX3VuaXQoc3RydWN0IHBjaV9kZXYgKmRldikKIAkJCQkgICAgaGVhZGVyKTsK
IAogCQlpZiAoZG1hcnUtPmluY2x1ZGVfYWxsICYmCi0JCSAgICBkcmhkLT5zZWdtZW50ID09
IHBjaV9kb21haW5fbnIoZGV2LT5idXMpKQorCQkgICAgZHJoZC0+c2VnbWVudCA9PSBwY2lf
ZG9tYWluX25yKGRldi0+YnVzKSkgeworCQkJLyogV2Uga25vdyB0aGF0IHRoaXMgZGV2aWNl
IG9uIHRoaXMgY2hpcHNldCBoYXMgaXRzIG93bgorCQkJICAgSU9NTVUuIElmIHdlIGZpbmQg
aXQgdW5kZXIgdGhlIGNhdGNoLWFsbCBJT01NVSwgdGhlbgorCQkJICAgdGhlIEJJT1MgaXMg
bHlpbmcgdG8gdXMuIEhvcGUgdGhhdCB0aGUgSU9NTVUgZm9yCisJCQkgICB0aGlzIGRldmlj
ZSBpcyBhY3R1YWxseSBkaXNhYmxlZCwgYW5kIGl0IG5lZWRzIG5vCisJCQkgICB0cmFuc2xh
dGlvbi4uLiAqLworCQkJaWYgKGRldi0+dmVuZG9yID09IFBDSV9WRU5ET1JfSURfSU5URUwg
JiYKKwkJCSAgICBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0lOVEVMX0lPQVRfU05C
KSB7CisJCQkJV0FSTl9UQUlOVF9PTkNFKDEsIFRBSU5UX0ZJUk1XQVJFX1dPUktBUk9VTkQs
CisJCQkJCQkiQklPUyB3cm9uZ2x5IGluY2x1ZGVkIEkvT0FUIGRldmljZSB1bmRlciBjYXRj
aC1hbGwgVlQtZCB1bml0XG4iKTsKKwkJCQlyZXR1cm4gTlVMTDsKKwkJCX0KIAkJCXJldHVy
biBkbWFydTsKKwkJfQogCiAJCWlmIChkbWFyX3BjaV9kZXZpY2VfbWF0Y2goZG1hcnUtPmRl
dmljZXMsCiAJCQkJCSAgZG1hcnUtPmRldmljZXNfY250LCBkZXYpKQo=
--------------060401010202070209030600--
