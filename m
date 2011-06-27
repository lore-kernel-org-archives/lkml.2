Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974Ab1F0Rho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 13:37:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60719 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1F0Rhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 13:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MqjcsWdhJy6J7N0VCka4LfOkEqwKN4ndJWcdgfkNZMFvwRo1sM1g9vPC+BkSTmwdyp
         1PTBQXo0a5c6Asec9w97SbBrk3gjnZoW7dDQ2VX2MekMgGGLFBtKqbx9Dc9ru3uRUxRy
         yHrS+bmjPxYTtAm3C/862IYnV9HyB43dOvShk=
MIME-Version: 1.0
In-Reply-To: <BANLkTinr-5k3grHM-gfjVi2PA67VvvTiNg@mail.gmail.com>
References: <BLU158-w332CD7657F92343D3D2D1C876A0@phx.gbl>
	<BANLkTinr-5k3grHM-gfjVi2PA67VvvTiNg@mail.gmail.com>
Date: Mon, 27 Jun 2011 18:37:34 +0100
X-Google-Sender-Auth: fE06dpLFqderACMH2gP0cKuo7rs
Message-ID: <BANLkTinJHNztwaR44qdOpZyWg7ASrVG7vQ@mail.gmail.com>
Subject: Re: [ath9k-devel] Patching ath9k/mac80211 to change MAC layer features
From: Fred Matthews <fredmm@hotmail.co.uk>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net, ath9k-devel@lists.ath9k
Content-Type: multipart/mixed; boundary=0023547c89b3b5be8804a6b501b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0023547c89b3b5be8804a6b501b0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,

Much appreciated Mohammed Shafi, disabling aggregation works when
replacing those lines with
 sc->sc_flags &=3D ~SC_OP_TXAGGR;
 sc->sc_flags &=3D ~SC_OP_RXAGGR;
only issue is I must always recompile compat-wireless to
re-enable/disable it again. I tried to port it using debugfs to be
able to enable and disable at runtime but ath9k kept rebooting.

Also I would be very grateful if someone can help regarding my
attached patch and previous query:

------------
 need to patch ath9k so that I can be able to modify/fix the A-MPDU
aggregation frame length and other parameters such that they can be
configured at runtime via debugfs. I made a newbie attempt at trying
to change the aggregate length (attached), but I am unsure of the
correctness/efficiency  - when applied throughput varies with
different frame lengths entered but I can't be sure if its actually
changing the aggregation length (passes the framelen/aggr_limit).
Hence I would be very grateful if someone can assist in the correct
way of doing this (possibly directly via mac80211).


Also if the ampdu aggregate length is changed I believe the
number/length of the subframes of the aggregate stays constant (at the
default which is 32). I try to change this in my patch as well as the
maximum software retries by just changing the default definition in
ath9k.h, thus is there a (more) correct/better way of changing these.
Finally, how can I patch the driver to be able to disable Block-Acks
via debugfs or otherwise.
---------------

Thank you very much



On Mon, Jun 20, 2011 at 9:15 AM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> On Fri, Jun 17, 2011 at 2:09 AM, Fred Matthews <fredmm@hotmail.co.uk> wro=
te:
>> Hello all,
>>
>>
>> I have a query regarding patching ath9k/mac80211 to change MAC layer
>> features=A0and I would be most grateful if someone can assist.
>>
>>
>> I need to patch ath9k so that I can be able to=A0modify/fix the A-MPDU
>> aggregation frame length and other parameters such that they can be
>> configured at runtime via debugfs. I made a newbie attempt at trying to
>> change the aggregate length (attached), but I am unsure of the
>> correctness/efficiency=A0=A0- when applied throughput varies with differ=
ent
>> frame lengths entered but I can't be sure if its actually changing the
>> aggregation length (passes the framelen/aggr_limit). Hence I would be ve=
ry
>> grateful if someone can assist in the correct way of doing this (possibl=
y
>> directly via mac80211).
>>
>>
>>
>> Also if the ampdu aggregate length is changed I believe the number/lengt=
h of
>> the subframes of the aggregate stays constant (at the default which is
>> 32).=A0I try to change this in my patch=A0as well as the maximum softwar=
e
>> retries by just changing the=A0default=A0definition in ath9k.h, thus is =
there a
>> (more) correct/better way of changing these.=A0Finally, how can I patch =
the
>> driver to be able to disable Block-Acks/aggregation via debugfs or
>> otherwise.
>
>
> to disable aggregation in the driver, please try this
> diff --git a/drivers/net/wireless/ath/ath9k/init.c
> b/drivers/net/wireless/ath/ath9k/init.c
> index d4b166c..e0175d0 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -524,8 +524,6 @@ static void ath9k_init_misc(struct ath_softc *sc)
> =A0 =A0 =A0 =A0sc->config.txpowlimit =3D ATH_TXPOWER_MAX;
>
> =A0 =A0 =A0 =A0if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sc->sc_flags |=3D SC_OP_TXAGGR;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sc->sc_flags |=3D SC_OP_RXAGGR;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0common->tx_chainmask =3D sc->sc_ah->caps.tx_chainmask;
>
> if you want only tx-aggregation to be disabled , please comment out only =
that.
> also you can completely disable HT by
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c
> b/drivers/net/wireless/ath/ath9k/hw.c
> index 6de2655..696b4cc 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -1915,10 +1915,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
>
> =A0 =A0 =A0 =A0common->crypt_caps |=3D ATH_CRYPT_CAP_CIPHER_AESCCM;
>
> - =A0 =A0 =A0 if (ah->hw_version.devid !=3D AR2427_DEVID_PCIE)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCap->hw_caps |=3D ATH9K_HW_CAP_HT;
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCap->hw_caps &=3D ~ATH9K_HW_CAP_HT;
> + =A0 =A0 =A0 pCap->hw_caps &=3D ~ATH9K_HW_CAP_HT;
>
> =A0 =A0 =A0 =A0if (AR_SREV_9271(ah))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCap->num_gpio_pins =3D AR9271_NUM_GPIO;
>
>
>
>
>>
>>
>>
>> I highly appreciate, help in any of the above, as well as other advice,
>> Many thanks
>>
>> _______________________________________________
>> ath9k-devel mailing list
>> ath9k-devel@lists.ath9k.org
>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>>
>>
>
>
>
> --
> shafi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

--0023547c89b3b5be8804a6b501b0
Content-Type: text/x-patch; charset=US-ASCII; 
	name="aggr+subframe+retry_change_attempt.patch"
Content-Disposition: attachment; 
	filename="aggr+subframe+retry_change_attempt.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gpfpd7yg0

ZGlmZiAtTmF1ciBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hdGg5ay5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2F0aDlrLmgKLS0tIGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDlrL2F0aDlrLmgJMjAxMS0wNS0yNyAyMDowNDo0OS4wMDAwMDAwMDAgKzAx
MDAKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2F0aDlrLmgJMjAxMS0wNi0w
MiAxOTo1OToyOC4wNDMzMjcwMDAgKzAxMDAKQEAgLTEzNyw3ICsxMzcsNyBAQAogI2RlZmluZSBB
VEhfQUdHUl9FTkNSWVBUREVMSU0gICAgICAxMAogLyogbWluaW11bSBoL3cgcWRlcHRoIHRvIGJl
IHN1c3RhaW5lZCB0byBtYXhpbWl6ZSBhZ2dyZWdhdGlvbiAqLwogI2RlZmluZSBBVEhfQUdHUl9N
SU5fUURFUFRIICAgICAgICAyCi0jZGVmaW5lIEFUSF9BTVBEVV9TVUJGUkFNRV9ERUZBVUxUIDMy
CisjZGVmaW5lIEFUSF9BTVBEVV9TVUJGUkFNRV9ERUZBVUxUIHNjLT5kZWJ1Zy5zdWJmcmFtZV9z
aXplCiAKICNkZWZpbmUgSUVFRTgwMjExX1NFUV9TRVFfU0hJRlQgICAgNAogI2RlZmluZSBJRUVF
ODAyMTFfU0VRX01BWCAgICAgICAgICA0MDk2CkBAIC01MzcsNyArNTM3LDcgQEAKICNkZWZpbmUg
REVGQVVMVF9DQUNIRUxJTkUgICAgICAgMzIKICNkZWZpbmUgQVRIX1JFR0NMQVNTSURTX01BWCAg
ICAgMTAKICNkZWZpbmUgQVRIX0NBQlFfUkVBRFlfVElNRSAgICAgODAgICAgICAvKiAlIG9mIGJl
YWNvbiBpbnRlcnZhbCAqLwotI2RlZmluZSBBVEhfTUFYX1NXX1JFVFJJRVMgICAgICAxMAorI2Rl
ZmluZSBBVEhfTUFYX1NXX1JFVFJJRVMgICAgICBzYy0+ZGVidWcucmV0cnlfbGltaXQKICNkZWZp
bmUgQVRIX0NIQU5fTUFYICAgICAgICAgICAgMjU1CiAKICNkZWZpbmUgQVRIX1RYUE9XRVJfTUFY
ICAgICAgICAgMTAwICAgICAvKiAuNSBkQm0gdW5pdHMgKi8KZGlmZiAtTmF1ciBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9kZWJ1Zy5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDlrL2RlYnVnLmMKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2RlYnVn
LmMJMjAxMS0wNS0yNyAyMDowNDo0OS4wMDAwMDAwMDAgKzAxMDAKKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYXRoL2F0aDlrL2RlYnVnLmMJMjAxMS0wNi0wMiAxOTo1NDowOS4yNjAzMjAwMDAg
KzAxMDAKQEAgLTEwNDUsNiArMTA0OCwxNjIgQEAKIAkubGxzZWVrID0gZGVmYXVsdF9sbHNlZWss
CiB9OwogCitzdGF0aWMgc3NpemVfdCByZWFkX2ZpbGVfYW1wZHVfbGVuKHN0cnVjdCBmaWxlICpm
aWxlLCBjaGFyIF9fdXNlciAqdXNlcl9idWYsCisgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHNpemVfdCBjb3VudCwgbG9mZl90ICpwcG9zKQoreworCXN0cnVjdCBhdGhfc29mdGMgKnNj
ID0gZmlsZS0+cHJpdmF0ZV9kYXRhOworCWNoYXIgYnVmWzMyXTsKKwl1bnNpZ25lZCBpbnQgbGVu
OworCisJbGVuID0gc3ByaW50ZihidWYsICIldVxuIiwgc2MtPmRlYnVnLmFtcGR1X2xlbik7CisJ
cmV0dXJuIHNpbXBsZV9yZWFkX2Zyb21fYnVmZmVyKHVzZXJfYnVmLCBjb3VudCwgcHBvcywgYnVm
LCBsZW4pOworfQorCitzdGF0aWMgc3NpemVfdCB3cml0ZV9maWxlX2FtcGR1X2xlbihzdHJ1Y3Qg
ZmlsZSAqZmlsZSwgY29uc3QgY2hhciBfX3VzZXIgKnVzZXJfYnVmLAorCQkJICAgICBzaXplX3Qg
Y291bnQsIGxvZmZfdCAqcHBvcykKK3sKKwlzdHJ1Y3QgYXRoX3NvZnRjICpzYyA9IGZpbGUtPnBy
aXZhdGVfZGF0YTsKKwl1bnNpZ25lZCBsb25nIGFtcGR1X2xlbjsKKwljaGFyIGJ1ZlszMl07CisJ
c3NpemVfdCBsZW47CisKKwlsZW4gPSBtaW4oY291bnQsIHNpemVvZihidWYpIC0gMSk7CisJaWYg
KGNvcHlfZnJvbV91c2VyKGJ1ZiwgdXNlcl9idWYsIGxlbikpCisJCXJldHVybiAtRUZBVUxUOwor
CisJYnVmW2xlbl0gPSAnXDAnOworCWlmIChzdHJpY3Rfc3RydG91bChidWYsIDAsICZhbXBkdV9s
ZW4pKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCXNjLT5kZWJ1Zy5hbXBkdV9sZW4gPSBhbXBkdV9s
ZW47CisJcmV0dXJuIGNvdW50OworfQorCitzdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0
aW9ucyBmb3BzX2FtcGR1X2xlbiA9IHsKKwkucmVhZCA9IHJlYWRfZmlsZV9hbXBkdV9sZW4sCisJ
LndyaXRlID0gd3JpdGVfZmlsZV9hbXBkdV9sZW4sCisJLm9wZW4gPSBhdGg5a19kZWJ1Z2ZzX29w
ZW4sCisJLm93bmVyID0gVEhJU19NT0RVTEUsCisJLmxsc2VlayA9IGRlZmF1bHRfbGxzZWVrLAor
fTsKKworc3RhdGljIHNzaXplX3QgcmVhZF9maWxlX3JldHJ5X2xpbWl0KHN0cnVjdCBmaWxlICpm
aWxlLCBjaGFyIF9fdXNlciAqdXNlcl9idWYsCisgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHNpemVfdCBjb3VudCwgbG9mZl90ICpwcG9zKQoreworCXN0cnVjdCBhdGhfc29mdGMgKnNj
ID0gZmlsZS0+cHJpdmF0ZV9kYXRhOworCWNoYXIgYnVmWzE2XTsKKwl1bnNpZ25lZCBpbnQgbGVu
OworCisJbGVuID0gc3ByaW50ZihidWYsICIldVxuIiwgc2MtPmRlYnVnLnJldHJ5X2xpbWl0KTsK
KwlyZXR1cm4gc2ltcGxlX3JlYWRfZnJvbV9idWZmZXIodXNlcl9idWYsIGNvdW50LCBwcG9zLCBi
dWYsIGxlbik7Cit9CisKK3N0YXRpYyBzc2l6ZV90IHdyaXRlX2ZpbGVfcmV0cnlfbGltaXQoc3Ry
dWN0IGZpbGUgKmZpbGUsIGNvbnN0IGNoYXIgX191c2VyICp1c2VyX2J1ZiwKKwkJCSAgICAgc2l6
ZV90IGNvdW50LCBsb2ZmX3QgKnBwb3MpCit7CisJc3RydWN0IGF0aF9zb2Z0YyAqc2MgPSBmaWxl
LT5wcml2YXRlX2RhdGE7CisJdW5zaWduZWQgbG9uZyByZXRyeV9saW1pdDsKKwljaGFyIGJ1Zlsx
Nl07CisJc3NpemVfdCBsZW47CisKKwlsZW4gPSBtaW4oY291bnQsIHNpemVvZihidWYpIC0gMSk7
CisJaWYgKGNvcHlfZnJvbV91c2VyKGJ1ZiwgdXNlcl9idWYsIGxlbikpCisJCXJldHVybiAtRUZB
VUxUOworCisJYnVmW2xlbl0gPSAnXDAnOworCWlmIChzdHJpY3Rfc3RydG91bChidWYsIDAsICZy
ZXRyeV9saW1pdCkpCisJCXJldHVybiAtRUlOVkFMOworCisJc2MtPmRlYnVnLnJldHJ5X2xpbWl0
ID0gcmV0cnlfbGltaXQ7CisJcmV0dXJuIGNvdW50OworfQorCitzdGF0aWMgY29uc3Qgc3RydWN0
IGZpbGVfb3BlcmF0aW9ucyBmb3BzX3JldHJ5X2xpbWl0ID0geworCS5yZWFkID0gcmVhZF9maWxl
X3JldHJ5X2xpbWl0LAorCS53cml0ZSA9IHdyaXRlX2ZpbGVfcmV0cnlfbGltaXQsCisJLm9wZW4g
PSBhdGg5a19kZWJ1Z2ZzX29wZW4sCisJLm93bmVyID0gVEhJU19NT0RVTEUsCisJLmxsc2VlayA9
IGRlZmF1bHRfbGxzZWVrLAorfTsKKworc3RhdGljIHNzaXplX3QgcmVhZF9maWxlX3N1YmZyYW1l
X3NpemUoc3RydWN0IGZpbGUgKmZpbGUsIGNoYXIgX191c2VyICp1c2VyX2J1ZiwKKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgc2l6ZV90IGNvdW50LCBsb2ZmX3QgKnBwb3MpCit7CisJ
c3RydWN0IGF0aF9zb2Z0YyAqc2MgPSBmaWxlLT5wcml2YXRlX2RhdGE7CisJY2hhciBidWZbMTZd
OworCXVuc2lnbmVkIGludCBsZW47CisKKwlsZW4gPSBzcHJpbnRmKGJ1ZiwgIiV1XG4iLCBzYy0+
ZGVidWcuc3ViZnJhbWVfc2l6ZSk7CisJcmV0dXJuIHNpbXBsZV9yZWFkX2Zyb21fYnVmZmVyKHVz
ZXJfYnVmLCBjb3VudCwgcHBvcywgYnVmLCBsZW4pOworfQorCitzdGF0aWMgc3NpemVfdCB3cml0
ZV9maWxlX3N1YmZyYW1lX3NpemUoc3RydWN0IGZpbGUgKmZpbGUsIGNvbnN0IGNoYXIgX191c2Vy
ICp1c2VyX2J1ZiwKKwkJCSAgICAgc2l6ZV90IGNvdW50LCBsb2ZmX3QgKnBwb3MpCit7CisJc3Ry
dWN0IGF0aF9zb2Z0YyAqc2MgPSBmaWxlLT5wcml2YXRlX2RhdGE7CisJdW5zaWduZWQgbG9uZyBz
dWJmcmFtZV9zaXplOworCWNoYXIgYnVmWzE2XTsKKwlzc2l6ZV90IGxlbjsKKworCWxlbiA9IG1p
bihjb3VudCwgc2l6ZW9mKGJ1ZikgLSAxKTsKKwlpZiAoY29weV9mcm9tX3VzZXIoYnVmLCB1c2Vy
X2J1ZiwgbGVuKSkKKwkJcmV0dXJuIC1FRkFVTFQ7CisKKwlidWZbbGVuXSA9ICdcMCc7CisJaWYg
KHN0cmljdF9zdHJ0b3VsKGJ1ZiwgMCwgJnN1YmZyYW1lX3NpemUpKQorCQlyZXR1cm4gLUVJTlZB
TDsKKworCXNjLT5kZWJ1Zy5zdWJmcmFtZV9zaXplID0gc3ViZnJhbWVfc2l6ZTsKKwlyZXR1cm4g
Y291bnQ7Cit9CisKK3N0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIGZvcHNfc3Vi
ZnJhbWVfc2l6ZSA9IHsKKwkucmVhZCA9IHJlYWRfZmlsZV9zdWJmcmFtZV9zaXplLAorCS53cml0
ZSA9IHdyaXRlX2ZpbGVfc3ViZnJhbWVfc2l6ZSwKKwkub3BlbiA9IGF0aDlrX2RlYnVnZnNfb3Bl
biwKKwkub3duZXIgPSBUSElTX01PRFVMRSwKKwkubGxzZWVrID0gZGVmYXVsdF9sbHNlZWssCit9
OworCitzdGF0aWMgc3NpemVfdCByZWFkX2ZpbGVfYXV0b19hbXBkdShzdHJ1Y3QgZmlsZSAqZmls
ZSwgY2hhciBfX3VzZXIgKnVzZXJfYnVmLAorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBzaXplX3QgY291bnQsIGxvZmZfdCAqcHBvcykKK3sKKwlzdHJ1Y3QgYXRoX3NvZnRjICpzYyA9
IGZpbGUtPnByaXZhdGVfZGF0YTsKKwljaGFyIGJ1Zls4XTsKKwl1bnNpZ25lZCBpbnQgbGVuOwor
CisJbGVuID0gc3ByaW50ZihidWYsICIldVxuIiwgc2MtPmRlYnVnLmF1dG9fYW1wZHUpOworCXJl
dHVybiBzaW1wbGVfcmVhZF9mcm9tX2J1ZmZlcih1c2VyX2J1ZiwgY291bnQsIHBwb3MsIGJ1Ziwg
bGVuKTsKK30KKworc3RhdGljIHNzaXplX3Qgd3JpdGVfZmlsZV9hdXRvX2FtcGR1KHN0cnVjdCBm
aWxlICpmaWxlLCBjb25zdCBjaGFyIF9fdXNlciAqdXNlcl9idWYsCisJCQkgICAgIHNpemVfdCBj
b3VudCwgbG9mZl90ICpwcG9zKQoreworCXN0cnVjdCBhdGhfc29mdGMgKnNjID0gZmlsZS0+cHJp
dmF0ZV9kYXRhOworCXVuc2lnbmVkIGxvbmcgYXV0b19hbXBkdTsKKwljaGFyIGJ1Zls4XTsKKwlz
c2l6ZV90IGxlbjsKKworCWxlbiA9IG1pbihjb3VudCwgc2l6ZW9mKGJ1ZikgLSAxKTsKKwlpZiAo
Y29weV9mcm9tX3VzZXIoYnVmLCB1c2VyX2J1ZiwgbGVuKSkKKwkJcmV0dXJuIC1FRkFVTFQ7CisK
KwlidWZbbGVuXSA9ICdcMCc7CisJaWYgKHN0cmljdF9zdHJ0b3VsKGJ1ZiwgMCwgJmF1dG9fYW1w
ZHUpKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCXNjLT5kZWJ1Zy5hdXRvX2FtcGR1ID0gYXV0b19h
bXBkdTsKKwlyZXR1cm4gY291bnQ7Cit9CisKK3N0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVy
YXRpb25zIGZvcHNfYXV0b19hbXBkdSA9IHsKKwkucmVhZCA9IHJlYWRfZmlsZV9hdXRvX2FtcGR1
LAorCS53cml0ZSA9IHdyaXRlX2ZpbGVfYXV0b19hbXBkdSwKKwkub3BlbiA9IGF0aDlrX2RlYnVn
ZnNfb3BlbiwKKwkub3duZXIgPSBUSElTX01PRFVMRSwKKwkubGxzZWVrID0gZGVmYXVsdF9sbHNl
ZWssCit9OworCiBzdGF0aWMgc3NpemVfdCByZWFkX2ZpbGVfcmVndmFsKHN0cnVjdCBmaWxlICpm
aWxlLCBjaGFyIF9fdXNlciAqdXNlcl9idWYsCiAJCQkgICAgIHNpemVfdCBjb3VudCwgbG9mZl90
ICpwcG9zKQogewpAQCAtMTE2Miw2ICsxNDA3LDE1IEBACiAJCQkgICAgc2MtPmRlYnVnLmRlYnVn
ZnNfcGh5LCBzYywgJmZvcHNfdHhfY2hhaW5tYXNrKTsKIAlkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJy
ZWdpZHgiLCBTX0lSVVNSIHwgU19JV1VTUiwgc2MtPmRlYnVnLmRlYnVnZnNfcGh5LAogCQkJICAg
IHNjLCAmZm9wc19yZWdpZHgpOworCQkJICAgIAorCWRlYnVnZnNfY3JlYXRlX2ZpbGUoImFtcGR1
X2xlbiIsIFNfSVJVU1IgfCBTX0lXVVNSLCBzYy0+ZGVidWcuZGVidWdmc19waHksCisJCQkgICAg
c2MsICZmb3BzX2FtcGR1X2xlbik7CisJZGVidWdmc19jcmVhdGVfZmlsZSgicmV0cnlfbGltaXQi
LCBTX0lSVVNSIHwgU19JV1VTUiwgc2MtPmRlYnVnLmRlYnVnZnNfcGh5LAorCQkJICAgIHNjLCAm
Zm9wc19yZXRyeV9saW1pdCk7CisJZGVidWdmc19jcmVhdGVfZmlsZSgic3ViZnJhbWVfc2l6ZSIs
IFNfSVJVU1IgfCBTX0lXVVNSLCBzYy0+ZGVidWcuZGVidWdmc19waHksCisJCQkgICAgc2MsICZm
b3BzX3N1YmZyYW1lX3NpemUpOworCWRlYnVnZnNfY3JlYXRlX2ZpbGUoImF1dG9fYW1wZHVbMDpP
RkYsMTpPTl0iLCBTX0lSVVNSIHwgU19JV1VTUiwgc2MtPmRlYnVnLmRlYnVnZnNfcGh5LAorCQkJ
ICAgIHNjLCAmZm9wc19hdXRvX2FtcGR1KTsKIAlkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJyZWd2YWwi
LCBTX0lSVVNSIHwgU19JV1VTUiwgc2MtPmRlYnVnLmRlYnVnZnNfcGh5LAogCQkJICAgIHNjLCAm
Zm9wc19yZWd2YWwpOwogCWRlYnVnZnNfY3JlYXRlX2Jvb2woImlnbm9yZV9leHRjY2EiLCBTX0lS
VVNSIHwgU19JV1VTUiwKQEAgLTExNzcsNSArMTMwMiw4IEBACiAJCQkgICBzYy0+ZGVidWcuZGVi
dWdmc19waHksICZzYy0+c2NfYWgtPmdwaW9fdmFsKTsKIAogCXNjLT5kZWJ1Zy5yZWdpZHggPSAw
OworCXNjLT5kZWJ1Zy5hdXRvX2FtcGR1ID0gMTsKKyAJc2MtPmRlYnVnLmFtcGR1X2xlbiA9IEFU
SF9BTVBEVV9MSU1JVF9NQVg7CisgCXNjLT5kZWJ1Zy5yZXRyeV9saW1pdCA9IDEwOwogCXJldHVy
biAwOwogfQogCmRpZmYgLU5hdXIgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvZGVi
dWcuaCBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9kZWJ1Zy5oCi0tLSBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9kZWJ1Zy5oCTIwMTEtMDUtMjcgMjA6MDQ6NDkuMDAw
MDAwMDAwICswMTAwCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9kZWJ1Zy5o
CTIwMTEtMDYtMDIgMTk6NTU6MzMuMzMyMzM3MDAwICswMTAwCkBAIC0xNzksNiArMTgwLDEwIEBA
CiBzdHJ1Y3QgYXRoOWtfZGVidWcgewogCXN0cnVjdCBkZW50cnkgKmRlYnVnZnNfcGh5OwogCXUz
MiByZWdpZHg7CisJdTMyIGFtcGR1X2xlbjsKKwl1MTYgcmV0cnlfbGltaXQ7CisJdTE2IHN1YmZy
YW1lX3NpemU7CisJdTggYXV0b19hbXBkdTsKIAlzdHJ1Y3QgYXRoX3N0YXRzIHN0YXRzOwogfTsK
IApkaWZmIC1OYXVyIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3htaXQuYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay94bWl0LmMKLS0tIGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDlrL3htaXQuYwkyMDExLTA1LTI3IDIwOjA0OjQ5LjAwMDAwMDAwMCArMDEw
MAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsveG1pdC5jCTIwMTEtMDYtMDIg
MTk6NTg6MTkuNjQ3MzQ3MDAwICswMTAwCkBAIC02MTYsOCArNjE2LDEyIEBACiAJCQlpZiAocmF0
ZXNbaV0uZmxhZ3MgJiBJRUVFODAyMTFfVFhfUkNfU0hPUlRfR0kpCiAJCQkJbW9kZWlkeCsrOwog
Ci0JCQlmcm1sZW4gPSBhdGhfbWF4XzRtc19mcmFtZWxlblttb2RlaWR4XVtyYXRlc1tpXS5pZHhd
OwotCQkJbWF4XzRtc19mcmFtZWxlbiA9IG1pbihtYXhfNG1zX2ZyYW1lbGVuLCBmcm1sZW4pOwor
CQkJCWZybWxlbiA9IGF0aF9tYXhfNG1zX2ZyYW1lbGVuW21vZGVpZHhdW3JhdGVzW2ldLmlkeF07
CisJCQkJCisJCQlpZiAoc2MtPmRlYnVnLmF1dG9fYW1wZHU9PTEpIAorCQkJCW1heF80bXNfZnJh
bWVsZW4gPSBtaW4obWF4XzRtc19mcmFtZWxlbiwgZnJtbGVuKTsKKwkJCWVsc2UgCisJCQkJbWF4
XzRtc19mcmFtZWxlbiA9IHNjLT5kZWJ1Zy5hbXBkdV9sZW47CiAJCX0KIAl9CiAKQEAgLTY0MSw3
ICs2NDUsNyBAQAogCSAqIFRoZSBJRSwgaG93ZXZlciBjYW4gaG9sZCB1cCB0byA2NTUzNiwgd2hp
Y2ggc2hvd3MgdXAgaGVyZQogCSAqIGFzIHplcm8uIElnbm9yZSA2NTUzNiBzaW5jZSB3ZSAgYXJl
IGNvbnN0cmFpbmVkIGJ5IGh3LgogCSAqLwotCWlmICh0aWQtPmFuLT5tYXhhbXBkdSkKKwlpZiAo
c2MtPmRlYnVnLmF1dG9fYW1wZHU9PTEgJiYgdGlkLT5hbi0+bWF4YW1wZHUpCiAJCWFnZ3JfbGlt
aXQgPSBtaW4oYWdncl9saW1pdCwgdGlkLT5hbi0+bWF4YW1wZHUpOwogCiAJcmV0dXJuIGFnZ3Jf
bGltaXQ7Cg==
--0023547c89b3b5be8804a6b501b0--
