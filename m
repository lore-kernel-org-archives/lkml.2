Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0DUWWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:22:55 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48324 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0DUWWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QLZrY5D2plTjulLiYSD3elMhQ5QfTWYPKXsEr6ap+YuIKW11wOWKGgHMDZEM9MkKjG
         RE5kudHX/E+pY3xJD4kj/R09zgFLCrAKiiMr4mjBbsJBluXSaoBTJbg2jc3kzfdYPVbX
         k/mVrbEZY58zsab+jMImubcIwVMf06QCo1Fno=
MIME-Version: 1.0
In-Reply-To: <20100419145934.GA10893@kroah.com>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
	 <20100419145934.GA10893@kroah.com>
Date: Thu, 22 Apr 2010 01:22:51 +0300
Message-ID: <t2w1ba2fa241004211522le49fc938m341553b0f2b89031@mail.gmail.com>
Subject: Re: request_firmware API exhaust memory
From: Tomas Winkler <tomasw@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Kay Sievers <kay.sievers@vrfy.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6d9728a7f41fa0484c6a231
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d9728a7f41fa0484c6a231
Content-Type: text/plain; charset=UTF-8

On Mon, Apr 19, 2010 at 5:59 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Apr 19, 2010 at 03:20:34PM +0300, Tomas Winkler wrote:
>> Lately we've been developing a device that rather more extensively
>> used request_firmware API in load and also using pm_notifiers to load
>> firmware.
>
> Do you have a pointer to your driver source anywhere that shows how you
> are trying to use the firmware api in this manner?

I've attached a very simple  test driver I'm using.  Just wanted to
eliminate anything else.
Bellow is a little script that loads and releases the firmware. My
previous observation was wrong.
The free memory gradually decreases regardless of number or dangling
udevd forks, which are eventually collected if the sleep period is
long enough ~10s.

testfw=${1:-test-fw600k.fw}
count=${2:-100}
s=${3:-10}
for ((i=0; i<$count ; i++)) ; do
        echo -n $testfw > /sys/devices/platform/fw-test/load_fw
        echo -n 1 > /sys/devices/platform/fw-test/release_fw
        sleep $s
        grep MemFree /proc/meminfo | awk '{print $2}'
        ps auxwww | grep udevd | wc -l
done

Thanks
Tomas

--0016e6d9728a7f41fa0484c6a231
Content-Type: application/octet-stream; name="fw-test.c"
Content-Disposition: attachment; filename="fw-test.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g8apd8zj0

LyoKICogIGZ3LXRlc3QuYyAtRlcgVGVzdCBEcml2ZXIKICoKICoKICogIENvcHlyaWdodCAoQykg
MjAxMCwgSW50ZWwgQ29ycG9yYXRpb24uIEFsbCByaWdodHMgcmVzZXJ2ZWQuCiAqCiAqICBUaGlz
IHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29y
IG1vZGlmeQogKiAgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMg
TGljZW5zZSBhcyBwdWJsaXNoZWQgYnkKICogIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247
IGVpdGhlciB2ZXJzaW9uIDIgb2YgdGhlIExpY2Vuc2UsIG9yCiAqICAoYXQgeW91ciBvcHRpb24p
IGFueSBsYXRlciB2ZXJzaW9uLgogKgogKiAgVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGlu
IHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWwsCiAqICBidXQgV0lUSE9VVCBBTlkgV0FS
UkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgogKiAgTUVSQ0hBTlRB
QklMSVRZIG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZQogKiAg
R05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KICoKICogIFlvdSBz
aG91bGQgaGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNl
bnNlCiAqICBhbG9uZyB3aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJl
ZSBTb2Z0d2FyZQogKiAgRm91bmRhdGlvbiwgSW5jLiwgNTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAz
MzAsIEJvc3RvbiwgTUEgIDAyMTExLTEzMDcgIFVTQQogKgogKgogKiAgVE9ETwogKgogKi8KCiNp
bmNsdWRlIDxsaW51eC9rZXJuZWwuaD4KI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgojaW5jbHVk
ZSA8bGludXgvaW5pdC5oPgojaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KI2luY2x1ZGUgPGxpbnV4
L3Byb2NfZnMuaD4KI2luY2x1ZGUgPGxpbnV4L2JhY2tsaWdodC5oPgojaW5jbHVkZSA8bGludXgv
cGxhdGZvcm1fZGV2aWNlLmg+CiNpbmNsdWRlIDxsaW51eC9zeXNmcy5oPgojaW5jbHVkZSA8bGlu
dXgvZmlybXdhcmUuaD4KCgpNT0RVTEVfQVVUSE9SKCJUb21hcyBXaW5rbGVyIik7Ck1PRFVMRV9E
RVNDUklQVElPTigiRmlybXdhcmUgQVBJIFRlc3QgRHJpdmVyIik7Ck1PRFVMRV9MSUNFTlNFKCJH
UEwiKTsKCnN0cnVjdCBmd190ZXN0X2RldiB7CglzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwX2Rl
djsKCXN0cnVjdCBtdXRleCBtdXRleDsKCWNvbnN0IHN0cnVjdCBmaXJtd2FyZSAqZnc7Cn07Cgpz
dGF0aWMgc3RydWN0IGZ3X3Rlc3RfZGV2IGZ3X3Rlc3Q7CgpzdGF0aWMgc3NpemVfdCBsb2FkX2Z3
KHN0cnVjdCBkZXZpY2UgKmQsIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLAoJCWNvbnN0
IGNoYXIgKmJ1Ziwgc2l6ZV90IGNvdW50KQp7CglzdHJ1Y3QgZndfdGVzdF9kZXYgKnByaXYgPSAm
ZndfdGVzdDsKCXNzaXplX3QgcmV0OwoKCW11dGV4X2xvY2soJmZ3X3Rlc3QubXV0ZXgpOwoJcmV0
ID0gcmVxdWVzdF9maXJtd2FyZSgmcHJpdi0+ZncsIGJ1ZiwgZCk7CglpZiAocmV0KQoJCXByaW50
ayhLRVJOX0VSUiAicmVxdWVzdCBmYWlsICVzIHJldD0lemQiLCBidWYsIHJldCk7CgllbHNlIAoJ
CXJldCA9IGNvdW50OwoJbXV0ZXhfdW5sb2NrKCZmd190ZXN0Lm11dGV4KTsKCglwcmludGsoS0VS
Tl9JTkZPICJGVy1URVNUIExPQUQiKTsKCXJldHVybiByZXQ7Cn0KCnN0YXRpYyBzc2l6ZV90IHJl
bGVhc2VfZncoc3RydWN0IGRldmljZSAqZCwgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIs
CgkJY29uc3QgY2hhciAqYnVmLCBzaXplX3QgY291bnQpCnsKCXN0cnVjdCBmd190ZXN0X2RldiAq
cHJpdiA9ICZmd190ZXN0OwoJCgltdXRleF9sb2NrKCZmd190ZXN0Lm11dGV4KTsKCXJlbGVhc2Vf
ZmlybXdhcmUocHJpdi0+ZncpOwoJcHJpdi0+ZncgPSBOVUxMOwoJbXV0ZXhfdW5sb2NrKCZmd190
ZXN0Lm11dGV4KTsKCXByaW50ayhLRVJOX0lORk8gIkZXLVRFU1QgUkVMRUFTRSIpOwoJCglyZXR1
cm4gY291bnQ7Cn0KCnN0YXRpYyBERVZJQ0VfQVRUUihsb2FkX2Z3LCBTX0lXVUdPLCBOVUxMLCBs
b2FkX2Z3KTsKCnN0YXRpYyBERVZJQ0VfQVRUUihyZWxlYXNlX2Z3LCBTX0lXVUdPLCBOVUxMLCBy
ZWxlYXNlX2Z3KTsKCnN0YXRpYyBzdHJ1Y3QgYXR0cmlidXRlICpmd190ZXN0X3N5c2ZzX2VudHJp
ZXNbXSA9IHsKCSZkZXZfYXR0cl9sb2FkX2Z3LmF0dHIsCgkmZGV2X2F0dHJfcmVsZWFzZV9mdy5h
dHRyLAoJTlVMTAp9OwoKc3RhdGljIHN0cnVjdCBhdHRyaWJ1dGVfZ3JvdXAgZndfdGVzdF9hdHRy
aWJ1dGVfZ3JvdXAgPSB7CgkubmFtZSA9IE5VTEwsCQkvKiBwdXQgaW4gZGV2aWNlIGRpcmVjdG9y
eSAqLwoJLmF0dHJzID0gZndfdGVzdF9zeXNmc19lbnRyaWVzLAp9OwoKc3RhdGljIHZvaWQgZndf
dGVzdF9leGl0KHZvaWQpCnsKCglzeXNmc19yZW1vdmVfZ3JvdXAoJmZ3X3Rlc3QucF9kZXYtPmRl
di5rb2JqLCAmZndfdGVzdF9hdHRyaWJ1dGVfZ3JvdXApOwoJcGxhdGZvcm1fZGV2aWNlX3VucmVn
aXN0ZXIoZndfdGVzdC5wX2Rldik7CglwcmludGsoS0VSTl9JTkZPICJGVyBBUEkgVGVzdCBEcml2
ZXIgVW5sb2FkZWQiKTsKCglyZXR1cm47Cn0KCnN0YXRpYyBpbnQgX19pbml0IGZ3X3Rlc3RfaW5p
dCh2b2lkKQp7CgoJaW50IHJldDsKCgltdXRleF9pbml0KCZmd190ZXN0Lm11dGV4KTsKCglmd190
ZXN0LnBfZGV2ID0gcGxhdGZvcm1fZGV2aWNlX3JlZ2lzdGVyX3NpbXBsZSgiZnctdGVzdCIsIC0x
LCBOVUxMLCAwKTsKCWlmIChJU19FUlIoZndfdGVzdC5wX2RldikpIHsKCQlyZXQgPSBQVFJfRVJS
KGZ3X3Rlc3QucF9kZXYpOwoJCXByaW50ayhLRVJOX0VSUiAidW5hYmxlIHRvIHJlZ2lzdGVyIHBs
YXRmb3JtIGRldmljZVxuIik7CgkJZndfdGVzdC5wX2RldiA9IE5VTEw7CgkJZndfdGVzdF9leGl0
KCk7CgkJcmV0dXJuIHJldDsKCX0KCXJldCA9IHN5c2ZzX2NyZWF0ZV9ncm91cCgmZndfdGVzdC5w
X2Rldi0+ZGV2LmtvYmosICZmd190ZXN0X2F0dHJpYnV0ZV9ncm91cCk7CglpZiAocmV0KSB7CgkJ
cHJpbnRrKEtFUk5fRVJSICJGYWlsZWQgdG8gYWxsb2NhdGUgU1lTRlMgZW50cnkiKTsKCQlmd190
ZXN0LnBfZGV2ID0gTlVMTDsKCQlmd190ZXN0X2V4aXQoKTsKCQlyZXR1cm4gcmV0OwoJfQoJcHJp
bnRrKEtFUk5fSU5GTyAiRlcgQVBJIFRlc3QgRHJpdmVyIExvYWRlZCIpOwoJcmV0dXJuIDA7Cgp9
Cgptb2R1bGVfaW5pdChmd190ZXN0X2luaXQpOwptb2R1bGVfZXhpdChmd190ZXN0X2V4aXQpOwo=
--0016e6d9728a7f41fa0484c6a231--
