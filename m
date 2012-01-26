Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2AZFtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 00:49:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35622 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2AZFtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 00:49:07 -0500
MIME-Version: 1.0
In-Reply-To: <20120126003735.GA2346@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
	<CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
	<20120125002250.GA20431@gamma.logic.tuwien.ac.at>
	<CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
	<20120126003735.GA2346@gamma.logic.tuwien.ac.at>
Date: Wed, 25 Jan 2012 21:49:04 -0800
Message-ID: <CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: multipart/mixed; boundary=f46d0442718217863704b767f040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0442718217863704b767f040
Content-Type: text/plain; charset=ISO-8859-1

Hi Norbert,

>
> syslog output is at http://www.logic.at/people/preining/syslog.log
> this is after a suspend and resume.
>
> first connection after resume succeeded at around kernel time 378.859794
> then it worked for say 20sec or so, hard to say when exactely it dropped,
> but defeinitely at kernel time 451 it was finished.
>
> After that nothing went out or in again.
>
> Hope you can make something out of that.
>

Unfortunately, not really. I can see you are hitting PASSIVE_NO_RX,
meaning that the uCode complains that you are trying to Tx on a
passive channel on which it hasn't heard any beacon yet. But then we
finally get a beacon there, and open the queue again.

Anyway, can you try the attached patch ?
Note that I have no real way to test it (I have to admit I haven't
even compiled... I am not in my office).
I hope it might help.

--f46d0442718217863704b767f040
Content-Type: application/octet-stream; name="tid.patch"
Content-Disposition: attachment; filename="tid.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxvd4csc0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi10eC5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXR4LmMKaW5kZXggZDlkNzU4ZS4u
MWI3MDA0OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWdu
LXR4LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXR4LmMKQEAg
LTk1LDYgKzk1LDcgQEAgc3RhdGljIHZvaWQgaXdsYWduX3R4X2NtZF9idWlsZF9iYXNpYyhzdHJ1
Y3QgaXdsX3ByaXYgKnByaXYsCiAJCQl0eF9mbGFncyB8PSBUWF9DTURfRkxHX1NFUV9DVExfTVNL
OwogCQllbHNlCiAJCQl0eF9mbGFncyAmPSB+VFhfQ01EX0ZMR19TRVFfQ1RMX01TSzsKKwkJdHhf
Y21kLT50aWRfdHNwZWMgPSBJV0xfTUFYX1RJRF9DT1VOVDsKIAl9CiAKIAlpd2xhZ25fdHhfY21k
X3Byb3RlY3Rpb24ocHJpdiwgaW5mbywgZmMsICZ0eF9mbGFncyk7CkBAIC04MDgsNiArODA5LDgg
QEAgc3RhdGljIHZvaWQgaXdsX3J4X3JlcGx5X3R4X2FnZyhzdHJ1Y3QgaXdsX3ByaXYgKnByaXYs
CiAJdTMyIHN0YXR1cyA9IGxlMTZfdG9fY3B1KHR4X3Jlc3AtPnN0YXR1cy5zdGF0dXMpOwogCWlu
dCBpOwogCisgICAgICAgIFdBUk5fT04odGlkID09IElXTF9NQVhfVElEX0NPVU5UKTsKKwogCWlm
IChhZ2ctPndhaXRfZm9yX2JhKQogCQlJV0xfREVCVUdfVFhfUkVQTFkocHJpdiwKIAkJCSJnb3Qg
dHggcmVzcG9uc2Ugdy9vIGJsb2NrLWFja1xuIik7CkBAIC0xMDM1LDEwICsxMDM4LDEyIEBAIGlu
dCBpd2xhZ25fcnhfcmVwbHlfdHgoc3RydWN0IGl3bF9wcml2ICpwcml2LCBzdHJ1Y3QgaXdsX3J4
X21lbV9idWZmZXIgKnJ4YiwKIAkJfQogCiAJCV9fc2tiX3F1ZXVlX2hlYWRfaW5pdCgmc2ticyk7
Ci0JCXByaXYtPnRpZF9kYXRhW3N0YV9pZF1bdGlkXS5uZXh0X3JlY2xhaW1lZCA9IG5leHRfcmVj
bGFpbWVkOwogCi0JCUlXTF9ERUJVR19UWF9SRVBMWShwcml2LCAiTmV4dCByZWNsYWltZWQgcGFj
a2V0OiVkIiwKLQkJCQkJICBuZXh0X3JlY2xhaW1lZCk7CisJCWlmICh0aWQgIT0gSVdMX01BWF9U
SURfQ09VTlQpIHsKKwkJCXByaXYtPnRpZF9kYXRhW3N0YV9pZF1bdGlkXS5uZXh0X3JlY2xhaW1l
ZCA9IG5leHRfcmVjbGFpbWVkOworCQkJSVdMX0RFQlVHX1RYX1JFUExZKHByaXYsICJOZXh0IHJl
Y2xhaW1lZCBwYWNrZXQ6JWQiLAorCQkJCQkJICBuZXh0X3JlY2xhaW1lZCk7CisJCX0KIAogCQkv
KndlIGNhbiBmcmVlIHVudGlsIHNzbiAlIHEubl9iZCBub3QgaW5jbHVzaXZlICovCiAJCVdBUk5f
T04oaXdsX3RyYW5zX3JlY2xhaW0odHJhbnMocHJpdiksIHN0YV9pZCwgdGlkLCB0eHFfaWQsCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10cmFucy1wY2llLmMg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10cmFucy1wY2llLmMKaW5kZXggYWE4
Nzk5NC4uZmExYjM2OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9p
d2wtdHJhbnMtcGNpZS5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXRy
YW5zLXBjaWUuYwpAQCAtMTU1MSw3ICsxNTUxLDcgQEAgc3RhdGljIGludCBpd2xfdHJhbnNfcGNp
ZV9yZWNsYWltKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLCBpbnQgc3RhX2lkLCBpbnQgdGlkLAog
CiAJdHhxLT50aW1lX3N0YW1wID0gamlmZmllczsKIAotCWlmICh1bmxpa2VseSh0eHFfaWQgPj0g
SVdMQUdOX0ZJUlNUX0FNUERVX1FVRVVFICYmCisJaWYgKHVubGlrZWx5KHRpZCAhPSBJV0xfTUFY
X1RJRF9DT1VOVCAmJiB0eHFfaWQgPj0gSVdMQUdOX0ZJUlNUX0FNUERVX1FVRVVFICYmCiAJCSAg
ICAgdHhxX2lkICE9IHRyYW5zX3BjaWUtPmFnZ190eHFbc3RhX2lkXVt0aWRdKSkgewogCQkvKgog
CQkgKiBGSVhNRTogdGhpcyBpcyBhIHVDb2RlIGJ1ZyB3aGljaCBuZWVkIHRvIGJlIGFkZHJlc3Nl
ZCwK
--f46d0442718217863704b767f040--
