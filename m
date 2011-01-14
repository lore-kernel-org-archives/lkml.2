Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab1ANIkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:40:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51362 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1ANIkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:40:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MBPj+CJxnV5ivdv9ZVuA282LFwthh5POTD1jm6vHmQ2HZhQ2uKR6hNIzLySNw3LUTt
         6mZuK9Zo4EqdtwBdF9EpW8xn5HdR+w5xqjScd4NXE3O/kVnLlH5bi5I7dg8Uw3u00Wb2
         vT5YGZSWcRdL0LQYIoXVKwimDoA+aN8GmTeGo=
MIME-Version: 1.0
In-Reply-To: <20110114052813.GZ19804@ZenIV.linux.org.uk>
References: <7352.1294971049@jrobl>
	<AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com>
	<20110114052813.GZ19804@ZenIV.linux.org.uk>
Date: Fri, 14 Jan 2011 19:40:01 +1100
Message-ID: <AANLkTi=pzFGHyFDYM_qvabODdKn8gDvRjjo_nbPfcT=q@mail.gmail.com>
Subject: Re: vfs-scale, nd->inode after __do_follow_link()
From: Nick Piggin <npiggin@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00504502d1b54835cb0499ca61ce
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502d1b54835cb0499ca61ce
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 14, 2011 at 4:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Jan 14, 2011 at 03:09:10PM +1100, Nick Piggin wrote:
>
>> > + ? ? ? ? ? ? ? ? ? ? ? struct dentry *i =3D path.dentry->d_inode;
>> > + ? ? ? ? ? ? ? ? ? ? ? if (!IS_ERR(cookie) && i->i_op->put_link)
>> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? i->i_op->put_link(path.dentry, &nd, co=
okie);
>> > ? ? ? ? ? ? ? ? ? ? ? ?/* nd.path had been dropped */
>> > ? ? ? ? ? ? ? ? ? ? ? ?nd.path =3D path;
>> > ? ? ? ? ? ? ? ? ? ? ? ?goto out_path;
>>
>> It should be the inode we followed, rather than the inode of the
>> new path, I think.
>
> And that's what the first argument of __do_follow_link() is. =A0I'm actua=
lly
> tempted to rename it from path to symlink and make it const to clarify
> the things a bit.

Yes I was completely wrong there, thanks again for another good
catch. I'll merge this in the vfs-scale branch, and ask to merge if
there are no objections.

--00504502d1b54835cb0499ca61ce
Content-Type: application/octet-stream; name="fs-namei-putlink-fix.patch"
Content-Disposition: attachment; filename="fs-namei-putlink-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_giwucbu10

ZnM6IG5hbWVpIGZpeCAtPnB1dF9saW5rIG9uIHdyb25nIGlub2RlIGluIGRvX2ZpbHBfb3BlbgoK
Si4gUi4gT2thamltYSBub3RpY2VkIHRoYXQgLT5wdXRfbGluayBpcyBiZWluZyBhdHRlbXB0ZWQg
b24gdGhlCndyb25nIGlub2RlLCBhbmQgc3VnZ2VzdGVkIHRoZSB3YXkgdG8gZml4IGl0LiBJIGNo
YW5nZWQgaXQgYSBiaXQKYWNjb3JkaW5nIHRvIEFsJ3Mgc3VnZ2VzdGlvbiB0byBrZWVwIGFuIGV4
cGxpY2l0IGxpbmsgcGF0aCBhcm91bmQuCgpTaWduZWQtb2ZmLWJ5OiBOaWNrIFBpZ2dpbiA8bnBp
Z2dpbkBrZXJuZWwuZGs+CgpJbmRleDogbGludXgtMi42L2ZzL25hbWVpLmMKPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gbGludXgtMi42Lm9yaWcvZnMvbmFtZWkuYwkyMDExLTAxLTE0IDE4OjI2OjAyLjAwMDAwMDAw
MCArMTEwMAorKysgbGludXgtMi42L2ZzL25hbWVpLmMJMjAxMS0wMS0xNCAxOToxMDowMi4wMDAw
MDAwMDAgKzExMDAKQEAgLTc3OSw3ICs3NzksOCBAQCBzdGF0aWMgdm9pZCBwYXRoX3B1dF9jb25k
aXRpb25hbChzdHJ1Y3QKIAkJbW50cHV0KHBhdGgtPm1udCk7CiB9CiAKLXN0YXRpYyBpbmxpbmUg
dm9pZCBwYXRoX3RvX25hbWVpZGF0YShzdHJ1Y3QgcGF0aCAqcGF0aCwgc3RydWN0IG5hbWVpZGF0
YSAqbmQpCitzdGF0aWMgaW5saW5lIHZvaWQgcGF0aF90b19uYW1laWRhdGEoY29uc3Qgc3RydWN0
IHBhdGggKnBhdGgsCisJCQkJCXN0cnVjdCBuYW1laWRhdGEgKm5kKQogewogCWlmICghKG5kLT5m
bGFncyAmIExPT0tVUF9SQ1UpKSB7CiAJCWRwdXQobmQtPnBhdGguZGVudHJ5KTsKQEAgLTc5MSwy
MCArNzkyLDIwIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBwYXRoX3RvX25hbWVpZGF0YShzdHIKIH0K
IAogc3RhdGljIF9fYWx3YXlzX2lubGluZSBpbnQKLV9fZG9fZm9sbG93X2xpbmsoc3RydWN0IHBh
dGggKnBhdGgsIHN0cnVjdCBuYW1laWRhdGEgKm5kLCB2b2lkICoqcCkKK19fZG9fZm9sbG93X2xp
bmsoY29uc3Qgc3RydWN0IHBhdGggKmxpbmssIHN0cnVjdCBuYW1laWRhdGEgKm5kLCB2b2lkICoq
cCkKIHsKIAlpbnQgZXJyb3I7Ci0Jc3RydWN0IGRlbnRyeSAqZGVudHJ5ID0gcGF0aC0+ZGVudHJ5
OworCXN0cnVjdCBkZW50cnkgKmRlbnRyeSA9IGxpbmstPmRlbnRyeTsKIAotCXRvdWNoX2F0aW1l
KHBhdGgtPm1udCwgZGVudHJ5KTsKKwl0b3VjaF9hdGltZShsaW5rLT5tbnQsIGRlbnRyeSk7CiAJ
bmRfc2V0X2xpbmsobmQsIE5VTEwpOwogCi0JaWYgKHBhdGgtPm1udCAhPSBuZC0+cGF0aC5tbnQp
IHsKLQkJcGF0aF90b19uYW1laWRhdGEocGF0aCwgbmQpOworCWlmIChsaW5rLT5tbnQgIT0gbmQt
PnBhdGgubW50KSB7CisJCXBhdGhfdG9fbmFtZWlkYXRhKGxpbmssIG5kKTsKIAkJbmQtPmlub2Rl
ID0gbmQtPnBhdGguZGVudHJ5LT5kX2lub2RlOwogCQlkZ2V0KGRlbnRyeSk7CiAJfQotCW1udGdl
dChwYXRoLT5tbnQpOworCW1udGdldChsaW5rLT5tbnQpOwogCiAJbmQtPmxhc3RfdHlwZSA9IExB
U1RfQklORDsKIAkqcCA9IGRlbnRyeS0+ZF9pbm9kZS0+aV9vcC0+Zm9sbG93X2xpbmsoZGVudHJ5
LCBuZCk7CkBAIC0yMzQ3LDExICsyMzQ4LDEyIEBAIHN0cnVjdCBmaWxlICpkb19maWxwX29wZW4o
aW50IGRmZCwgY29uc3QKIAluZC5mbGFncyA9IGZsYWdzOwogCWZpbHAgPSBkb19sYXN0KCZuZCwg
JnBhdGgsIG9wZW5fZmxhZywgYWNjX21vZGUsIG1vZGUsIHBhdGhuYW1lKTsKIAl3aGlsZSAodW5s
aWtlbHkoIWZpbHApKSB7IC8qIHRyYWlsaW5nIHN5bWxpbmsgKi8KLQkJc3RydWN0IHBhdGggaG9s
ZGVyOworCQlzdHJ1Y3QgcGF0aCBsaW5rID0gcGF0aDsKKwkJc3RydWN0IGlub2RlICpsaW5raSA9
IGxpbmsuZGVudHJ5LT5kX2lub2RlOwogCQl2b2lkICpjb29raWU7CiAJCWVycm9yID0gLUVMT09Q
OwogCQkvKiBTX0lTRElSIHBhcnQgaXMgYSB0ZW1wb3JhcnkgYXV0b21vdW50IGtsdWRnZSAqLwot
CQlpZiAoIShuZC5mbGFncyAmIExPT0tVUF9GT0xMT1cpICYmICFTX0lTRElSKG5kLmlub2RlLT5p
X21vZGUpKQorCQlpZiAoIShuZC5mbGFncyAmIExPT0tVUF9GT0xMT1cpICYmICFTX0lTRElSKGxp
bmtpLT5pX21vZGUpKQogCQkJZ290byBleGl0X2RwdXQ7CiAJCWlmIChjb3VudCsrID09IDMyKQog
CQkJZ290byBleGl0X2RwdXQ7CkBAIC0yMzY3LDIzICsyMzY5LDIyIEBAIHN0cnVjdCBmaWxlICpk
b19maWxwX29wZW4oaW50IGRmZCwgY29uc3QKIAkJICoganVzdCBzZXQgTEFTVF9CSU5ELgogCQkg
Ki8KIAkJbmQuZmxhZ3MgfD0gTE9PS1VQX1BBUkVOVDsKLQkJZXJyb3IgPSBzZWN1cml0eV9pbm9k
ZV9mb2xsb3dfbGluayhwYXRoLmRlbnRyeSwgJm5kKTsKKwkJZXJyb3IgPSBzZWN1cml0eV9pbm9k
ZV9mb2xsb3dfbGluayhsaW5rLmRlbnRyeSwgJm5kKTsKIAkJaWYgKGVycm9yKQogCQkJZ290byBl
eGl0X2RwdXQ7Ci0JCWVycm9yID0gX19kb19mb2xsb3dfbGluaygmcGF0aCwgJm5kLCAmY29va2ll
KTsKKwkJZXJyb3IgPSBfX2RvX2ZvbGxvd19saW5rKCZsaW5rLCAmbmQsICZjb29raWUpOwogCQlp
ZiAodW5saWtlbHkoZXJyb3IpKSB7Ci0JCQlpZiAoIUlTX0VSUihjb29raWUpICYmIG5kLmlub2Rl
LT5pX29wLT5wdXRfbGluaykKLQkJCQluZC5pbm9kZS0+aV9vcC0+cHV0X2xpbmsocGF0aC5kZW50
cnksICZuZCwgY29va2llKTsKKwkJCWlmICghSVNfRVJSKGNvb2tpZSkgJiYgbGlua2ktPmlfb3At
PnB1dF9saW5rKQorCQkJCWxpbmtpLT5pX29wLT5wdXRfbGluayhsaW5rLmRlbnRyeSwgJm5kLCBj
b29raWUpOwogCQkJLyogbmQucGF0aCBoYWQgYmVlbiBkcm9wcGVkICovCi0JCQluZC5wYXRoID0g
cGF0aDsKKwkJCW5kLnBhdGggPSBsaW5rOwogCQkJZ290byBvdXRfcGF0aDsKIAkJfQotCQlob2xk
ZXIgPSBwYXRoOwogCQluZC5mbGFncyAmPSB+TE9PS1VQX1BBUkVOVDsKIAkJZmlscCA9IGRvX2xh
c3QoJm5kLCAmcGF0aCwgb3Blbl9mbGFnLCBhY2NfbW9kZSwgbW9kZSwgcGF0aG5hbWUpOwotCQlp
ZiAobmQuaW5vZGUtPmlfb3AtPnB1dF9saW5rKQotCQkJbmQuaW5vZGUtPmlfb3AtPnB1dF9saW5r
KGhvbGRlci5kZW50cnksICZuZCwgY29va2llKTsKLQkJcGF0aF9wdXQoJmhvbGRlcik7CisJCWlm
IChsaW5raS0+aV9vcC0+cHV0X2xpbmspCisJCQlsaW5raS0+aV9vcC0+cHV0X2xpbmsobGluay5k
ZW50cnksICZuZCwgY29va2llKTsKKwkJcGF0aF9wdXQoJmxpbmspOwogCX0KIG91dDoKIAlpZiAo
bmQucm9vdC5tbnQpCg==
--00504502d1b54835cb0499ca61ce--
