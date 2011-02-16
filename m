Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab1BPItx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:49:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48470 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab1BPItu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:49:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rCaCy2myC5fFw+aW97orvwwT9MjG6Q6ZUoebHS2LN3v/v3PAgQyZYT8CzQtYS09+5r
         +7skCpu2XfVV5wOXYj1O6woxxIWykrmY6qo6nFr0cCpaBxl1tFZ8Z5EQR0LyDPULBiqw
         LYNxDRLD9F1zk3S3NGjtvyJn/CziYw11iZ8qA=
MIME-Version: 1.0
In-Reply-To: <20110216083747.GF16529@elte.hu>
References: <4D484853.9020409@gmail.com>
	<20110202023610.3799.qmail@science.horizon.com>
	<AANLkTi=X8vCuVOCMBJiCOB-8GZRF4-5RVx59QchecLz4@mail.gmail.com>
	<AANLkTikLVMNQzmugH-ORc89_ZouX6zWvG-tHSf1QoVf3@mail.gmail.com>
	<AANLkTikx-7zJZaV2tgP=D=vZ12Brp9qrnyxLv_mVXQT3@mail.gmail.com>
	<20110216083747.GF16529@elte.hu>
Date: Wed, 16 Feb 2011 11:49:50 +0300
Message-ID: <AANLkTimXDquQV7c5yOM+1h-F08Lxti7Z5JJbbL7q7hNd@mail.gmail.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@gmail.com>, George Spelvin <linux@horizon.com>,
        a.p.zijlstra@chello.nl, dzickus@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Content-Type: multipart/mixed; boundary=20cf302078622287d9049c625da6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf302078622287d9049c625da6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 16, 2011 at 11:37 AM, Ingo Molnar <mingo@elte.hu> wrote:
...
>> >>
>> >
>> > Ping on this problem, still seeing
>> >
>> > Uhhuh. NMI received for unknown reason 3c on CPU 0.
>> > Do you have a strange power saving mode enabled?
>> > Dazed and confused, but trying to continue
>> >
>> > on my Pentium-D system here with latest Linus head.
>> >
>> > its sometimes 3c, sometimes 3d, I'm going to bisect and push for
>> > reverts if nobody still has any clue about how to fix this.
>> >
>> > Dave.
>> >
>>
>> We still trying to resolve it but without success yet. There is no
>> easy way to revert it. One of the option might be to disable perf on
>> p4 for a while. If this is acceptable -- i'll cook such patch and send
>> it to Ingo. Hm?
>
> That's not really acceptable - need to fix it or revert it to the last wo=
rking
> state. Which commit broke it?
>
> Thanks,
>
> =A0 =A0 =A0 =A0Ingo
>

I can't say you the commit id after which unknown-nmi start happening
(i'm out of git tree
at moment) but even then this commit should not be reverted since the
problem is in
p4 code not in the rest of perf system.

I have two patches here (attached) and would really appreciate of
their testing on HT machine
together with kgdb bootup tests enabled. Dave could you please?

--20cf302078622287d9049c625da6
Content-Type: application/octet-stream; name=perf-x86-p4-extra-nmi
Content-Disposition: attachment; filename=perf-x86-p4-extra-nmi
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk801uud0

cGVyZiwgeDg2OiBQNCBQTVUgLS0gY2FwdHVyZSBleHRyYSBubWkgb24gb3ZlcmZsb3cKCkl0IHdh
cyBvYnNlcnZlZCB0aGF0IGluIGNhc2Ugb2YgcGVyZm9ybWFuY2Ugbm1pIGFuIGV4dHJhCm5taSBt
YXkgYmUgaXNzdWVkLCBjYXB0dXJlIGl0IG90aGVyd2lzZSAndW5rbm93bicgbm1pCm1lc3NhZ2Ug
d2lsbCBhcHBlYXIuCgpTaWduZWQtb2ZmLWJ5OiBDeXJpbGwgR29yY3Vub3YgPGdvcmN1bm92QG9w
ZW52ei5vcmc+Ci0tLQogYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2ZW50X3A0LmMgfCAgICA5
ICsrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQoKSW5kZXg6IGxpbnV4
LTIuNi50aXAvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2ZW50X3A0LmMKPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gbGludXgtMi42LnRpcC5vcmlnL2FyY2gveDg2L2tlcm5lbC9jcHUvcGVyZl9ldmVudF9wNC5j
CisrKyBsaW51eC0yLjYudGlwL2FyY2gveDg2L2tlcm5lbC9jcHUvcGVyZl9ldmVudF9wNC5jCkBA
IC05NTAsNiArOTUwLDE1IEBAIHN0YXRpYyBpbnQgcDRfcG11X2hhbmRsZV9pcnEoc3RydWN0IHB0
X3IKIAl9CiAKIAlpZiAoaGFuZGxlZCkgeworCQkvKgorCQkgKiBwNCBxdWlyazogZXh0cmEgTk1J
IG1pZ2h0IGhhcHBlbiBzbyB3ZQorCQkgKiBhZGQgb25lIG1vcmUgaGVyZSwgdGhlIGJhY2stdG8t
YmFjaworCQkgKiBubWkgbG9naWMgd2lsbCBjYXB0dXJlIGl0OyBpZiBtb3JlIHRoYW4KKwkJICog
b25lIGNvdW50ZXIgdHJpZ2dlcmVkIGFuIGV4dHJhIG5taSB3aWxsCisJCSAqIGJlIGNhcHR1cmVk
IGFueXdheQorCQkgKi8KKwkJaWYgKGhhbmRsZWQgPCAyKQorCQkJaGFuZGxlZCsrOwogCQkvKiBw
NCBxdWlyazogdW5tYXNrIGl0IGFnYWluICovCiAJCWFwaWNfd3JpdGUoQVBJQ19MVlRQQywgYXBp
Y19yZWFkKEFQSUNfTFZUUEMpICYgfkFQSUNfTFZUX01BU0tFRCk7CiAJCWluY19pcnFfc3RhdChh
cGljX3BlcmZfaXJxcyk7Cg==
--20cf302078622287d9049c625da6
Content-Type: application/octet-stream; name=perf-x86-p4-unflagged-nmi
Content-Disposition: attachment; filename=perf-x86-p4-unflagged-nmi
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk8028271

RnJvbTogQ3lyaWxsIEdvcmN1bm92IDxnb3JjdW5vdkBvcGVudnoub3JnPgpTdWJqZWN0OiBbUEFU
Q0hdIHBlcmYsIHg4NjogUDQgUE1VIC0tIEZpeCB1bmZsYWdnZWQgb3ZlcmZsb3dzIHRlc3QKCkEg
Y291cGxlIG9mIHBlb3BsZSBoYXZlIHJlcG9ydGVkIGFuIHVua25vd24gTk1JIGlzc3VlIG9uIHA0
IHBtdS4KVGhpcyBwYXRjaCBzaG91bGQgZml4IGl0LgoKUmVwb3J0ZWQtYnk6IEdlb3JnZSBTcGVs
dmluIDxsaW51eEBob3Jpem9uLmNvbT4KUmVwb3J0ZWQtYnk6IE1lZWxpcyBSb29zIDxtcm9vc0Bs
aW51eC5lZT4KUmVwb3J0ZWQtYnk6IERvbiBaaWNrdXMgPGR6aWNrdXNAcmVkaGF0LmNvbT4KU2ln
bmVkLW9mZi1ieTogQ3lyaWxsIEdvcmN1bm92IDxnb3JjdW5vdkBvcGVudnoub3JnPgpDQzogSW5n
byBNb2xuYXIgPG1pbmdvQGVsdGUuaHU+CkNDOiBMaW4gTWluZyA8bWluZy5tLmxpbkBpbnRlbC5j
b20+CkNDOiBEb24gWmlja3VzIDxkemlja3VzQHJlZGhhdC5jb20+CkNDOiBQZXRlciBaaWpsc3Ry
YSA8YS5wLnppamxzdHJhQGNoZWxsby5ubD4KLS0tCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZXJm
X2V2ZW50X3A0LmggfCAgICAxICsKIGFyY2gveDg2L2tlcm5lbC9jcHUvcGVyZl9ldmVudF9wNC5j
ICB8ICAgMTEgKysrKysrKystLS0KIDIgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi50aXAvYXJjaC94ODYvaW5jbHVkZS9hc20v
cGVyZl9ldmVudF9wNC5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi50aXAub3JpZy9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9wZXJmX2V2ZW50X3A0LmgKKysrIGxpbnV4LTIuNi50aXAvYXJjaC94ODYv
aW5jbHVkZS9hc20vcGVyZl9ldmVudF9wNC5oCkBAIC0yMiw2ICsyMiw3IEBACiAKICNkZWZpbmUg
QVJDSF9QNF9DTlRSVkFMX0JJVFMJKDQwKQogI2RlZmluZSBBUkNIX1A0X0NOVFJWQUxfTUFTSwko
KDFVTEwgPDwgQVJDSF9QNF9DTlRSVkFMX0JJVFMpIC0gMSkKKyNkZWZpbmUgQVJDSF9QNF9VTkZM
QUdHRURfQklUCSgoMVVMTCkgPDwgKEFSQ0hfUDRfQ05UUlZBTF9CSVRTIC0gMSkpCiAKICNkZWZp
bmUgUDRfRVNDUl9FVkVOVF9NQVNLCTB4N2UwMDAwMDBVCiAjZGVmaW5lIFA0X0VTQ1JfRVZFTlRf
U0hJRlQJMjUKSW5kZXg6IGxpbnV4LTIuNi50aXAvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2
ZW50X3A0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42LnRpcC5vcmlnL2FyY2gveDg2L2tlcm5l
bC9jcHUvcGVyZl9ldmVudF9wNC5jCisrKyBsaW51eC0yLjYudGlwL2FyY2gveDg2L2tlcm5lbC9j
cHUvcGVyZl9ldmVudF9wNC5jCkBAIC03NzAsOSArNzcwLDE0IEBAIHN0YXRpYyBpbmxpbmUgaW50
IHA0X3BtdV9jbGVhcl9jY2NyX292ZigKIAkJcmV0dXJuIDE7CiAJfQogCi0JLyogaXQgbWlnaHQg
YmUgdW5mbGFnZ2VkIG92ZXJmbG93ICovCi0JcmRtc3JsKGh3Yy0+ZXZlbnRfYmFzZSArIGh3Yy0+
aWR4LCB2KTsKLQlpZiAoISh2ICYgQVJDSF9QNF9DTlRSVkFMX01BU0spKQorCS8qCisJICogYXQg
c29tZSBjaXJjdW1zdGFuY2VzIHRoZSBvdmVyZmxvdyBtaWdodCBpc3N1ZSBOTUkgYnV0IGRpZAor
CSAqIG5vdCBzZXQgUDRfQ0NDUl9PVkYgYml0IHNvIHNpbmNlIGEgY291bnRlciBob2xkcyBhIG5l
Z2F0aXZlIHZhbHVlCisJICogd2Ugc2ltcGx5IGNoZWNrIGZvciBoaWdoIGJpdCBiZWluZyBzZXQs
IGlmIGl0J3MgY2xlYXJlZCBpdCBtZWFucworCSAqIHRoZSBjb3VudGVyIGhhcyByZWFjaGVkIHpl
cm8gdmFsdWUgYW5kIGNvbnRpbnVlZCBjb3VudGluZyBiZWZvcmUKKwkgKiByZWFsIE5NSSBzaWdu
YWwgd2FzIHJlY2VpdmVkCisJICovCisJaWYgKCEodiAmIEFSQ0hfUDRfVU5GTEFHR0VEX0JJVCkp
CiAJCXJldHVybiAxOwogCiAJcmV0dXJuIDA7Cg==
--20cf302078622287d9049c625da6--
