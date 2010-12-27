Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab0L0VC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 16:02:26 -0500
Received: from nm14.bullet.mail.ac4.yahoo.com ([98.139.52.211]:40174 "HELO
	nm14.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750846Ab0L0VCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 16:02:25 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Dec 2010 16:02:25 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 227862.6439.bm@omp1018.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=u8vTRN3Lte1ormYLbnhODwxA6/4GaS1SeuMvIwjNLZMztSdEukWpNAtTNhW8nwqFHChRQGEgQoZwwWG7OMUrTWQ9zjmGcOyqRetvu0Tnx+RUnaSOypB095GEfuUqFxv8xbDQ6SU3pDx+S2SA9BRy7R4QBak389Kdsp4rq03r3aQ=;
Message-ID: <87086.58416.qm@web65703.mail.ac4.yahoo.com>
X-YMail-OSG: bT3280UVM1l1mX_TTkahmnQK90ttlXInUB_Ed8zmuEEh2W9
 Ct41EpWpncNggRYF6HW63PoxrWhdro0._SUIAjGHu9m6I4DGocywGrXQpAFV
 R5kL7qOF_.IoV7fUm074Y3I8IxTZPb.lq_yDT6lRoKdQKfAquiRZEEN2.MDU
 DLqIIgPLhv7qLBfwrxiiZuoM8Uy4.hjIo.Ib10NuQMEmew4J5kwNPlexjv6q
 V2ppBhME7yTGKOWRflmk_MnMBtNr1dUbP.fVnJHsB74Va2gZpeMTw6YDe1tk
 v2t6yzwV64plwT3n3ofFtz_Cfdj2uBEaRDfsS3rbG7ih_BArnExlhMnC3KXA
 HCg6m2kPzJI2oNHLsYkvT_FWvokAH4KQboFJVM6fh3i3Byj.dCN92
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Mon, 27 Dec 2010 12:55:38 -0800 (PST)
From: Tsozik <tsozik@yahoo.com>
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and _get_icount functions
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1522773082-1293483338=:58416"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1522773082-1293483338=:58416
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Pete,=0A=0AYou're absolutely right. My apology again, I re-checked values o=
f MSR masks used to update icount counters and they all belong to upper MSR=
 nibble, so they indeed track changes (not states). I took out counter incr=
ements from mct_u232_msr_to_state function and encapsulated them in the new=
ly defined mct_u232_msr_to_icount function, effectively leaving the previou=
s implementation of mct_u232_msr_to_state function intact. mct_u232_msr_to_=
icount uses delta nibble to track state changes. RM-60 testing showed the s=
ame levels as measured by PDM-2 in close proximity to RM-60. Please let me =
know if anything else needs to be corrected to roll this out,=0A=0AThank yo=
u again for your expertise,=0A Vadim.=0A=0A--- On Mon, 12/27/10, Pete Zaitc=
ev <zaitcev@redhat.com> wrote:=0A=0A> From: Pete Zaitcev <zaitcev@redhat.co=
m>=0A> Subject: Re: [PATCH 1/1] mct_u232: added _ioctl and _get_icount func=
tions=0A> To: "Tsozik" <tsozik@yahoo.com>=0A> Cc: "Greg Kroah-Hartman" <gre=
gkh@suse.de>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org=0A> D=
ate: Monday, December 27, 2010, 12:08 PM=0A> On Sun, 26 Dec 2010 22:34:23 -=
0800=0A> (PST)=0A> Tsozik <tsozik@yahoo.com>=0A> wrote:=0A> =0A> > Usually =
MSR contains information about both states=0A> which are raised and=0A> > s=
tates which are changed. It looks like we use upper=0A> MSR nibble which=0A=
> > contains information about 4 states which were raised,=0A> not lower MS=
R=0A> > nibble which contains information about 4 states which=0A> were cha=
nged.=0A> =0A> Sure, I know how typical UART works. Does the MCT device=0A>=
 deliver the=0A> change states? If it does and you want to use those, go=0A=
> ahead.=0A> =0A> > I also researched implementations under usb/serial and=
=0A> saw that all of=0A> > them are rely on the current states (not change=
=0A> states) to increment=0A> > the respective counter variables.=0A> =0A> =
Here's drivers/usb/serial/io_edgeport.c:=0A> =0A> static void handle_new_ms=
r(struct edgeport_port *edge_port,=0A> __u8 newMsr)=0A> {=0A> =A0=A0=A0 str=
uct=A0 async_icount *icount;=0A> =0A> =A0=A0=A0 dbg("%s %02x", __func__, ne=
wMsr);=0A> =0A> =A0=A0=A0 if (newMsr & (EDGEPORT_MSR_DELTA_CTS=0A> | EDGEPO=
RT_MSR_DELTA_DSR |=0A> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=0A> EDGEPORT_MSR_DELTA=
_RI | EDGEPORT_MSR_DELTA_CD)) {=0A> =A0=A0=A0 =A0=A0=A0 icount =3D=0A> &edg=
e_port->icount;=0A> =0A> =A0=A0=A0 =A0=A0=A0 /* update input line=0A> count=
ers */=0A> =A0=A0=A0 =A0=A0=A0 if (newMsr &=0A> EDGEPORT_MSR_DELTA_CTS)=0A>=
 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=0A> icount->cts++;=0A> =A0=A0=A0 =A0=A0=A0 i=
f (newMsr &=0A> EDGEPORT_MSR_DELTA_DSR)=0A> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=
=0A> icount->dsr++;=0A> =A0=A0=A0 =A0=A0=A0 if (newMsr &=0A> EDGEPORT_MSR_D=
ELTA_CD)=0A> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=0A> icount->dcd++;=0A> =A0=A0=A0=
 =A0=A0=A0 if (newMsr &=0A> EDGEPORT_MSR_DELTA_RI)=0A> =A0=A0=A0 =A0=A0=A0 =
=A0=A0=A0=0A> icount->rng++;=0A> =A0=A0=A0 =A0=A0=A0=0A> wake_up_interrupti=
ble(&edge_port->delta_msr_wait);=0A> =A0=A0=A0 }=0A> =0A> Looks like it cou=
nts changes to me. And in any case, the=0A> gold standard=0A> is in drivers=
/serial/8250.c:=0A> =0A> static unsigned int check_modem_status(struct=0A> =
uart_8250_port *up)=0A> {=0A> =A0=A0=A0 unsigned int status =3D serial_in(u=
p,=0A> UART_MSR);=0A> =0A> =A0=A0=A0 status |=3D up->msr_saved_flags;=0A> =
=A0=A0=A0 up->msr_saved_flags =3D 0;=0A> =A0=A0=A0 if (status & UART_MSR_AN=
Y_DELTA=0A> && up->ier & UART_IER_MSI &&=0A> =A0=A0=A0 =A0 =A0 up->port.sta=
te !=3D NULL)=0A> {=0A> =A0=A0=A0 =A0=A0=A0 if (status &=0A> UART_MSR_TERI)=
=0A> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=0A> up->port.icount.rng++;=0A> =A0=A0=A0=
 =A0=A0=A0 if (status &=0A> UART_MSR_DDSR)=0A> =A0=A0=A0 =A0=A0=A0 =A0=A0=
=A0=0A> up->port.icount.dsr++;=0A> =A0=A0=A0 =A0=A0=A0 if (status &=0A> UAR=
T_MSR_DDCD)=0A> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=0A> uart_handle_dcd_change(&u=
p->port, status &=0A> UART_MSR_DCD);=0A> =A0=A0=A0 =A0=A0=A0 if (status &=
=0A> UART_MSR_DCTS)=0A> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=0A> uart_handle_cts_c=
hange(&up->port, status &=0A> UART_MSR_CTS);=0A> =0A> =A0=A0=A0 =A0=A0=A0=
=0A> wake_up_interruptible(&up->port.state->port.delta_msr_wait);=0A> =A0=
=A0=A0 }=0A> =0A> I only proposed accomplishing the same result by comparin=
g=0A> states=0A> in place of relying on hardware change reports like both o=
f=0A> the=0A> above do.=0A> =0A> -- Pete=0A>=0A=0A=0A      
--0-1522773082-1293483338=:58416
Content-Type: application/octet-stream; name="mct_u232.c.patch_v3"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="mct_u232.c.patch_v3"

LS0tIHVzYi9zZXJpYWwvbWN0X3UyMzIuYy5vcmlnCTIwMTAtMTItMjYgMTY6
NTQ6MTYuNjYwMjk0OTI0IC0wNTAwCisrKyB1c2Ivc2VyaWFsL21jdF91MjMy
LmMJMjAxMC0xMi0yNyAxNToyOTozMC44OTUxNDE3NTUgLTA1MDAKQEAgLTc4
LDYgKzc4LDggQEAKICNpbmNsdWRlIDxhc20vdW5hbGlnbmVkLmg+CiAjaW5j
bHVkZSA8bGludXgvdXNiLmg+CiAjaW5jbHVkZSA8bGludXgvdXNiL3Nlcmlh
bC5oPgorI2luY2x1ZGUgPGxpbnV4L3NlcmlhbC5oPgorI2luY2x1ZGUgPGxp
bnV4L2lvY3RsLmg+CiAjaW5jbHVkZSAibWN0X3UyMzIuaCIKIAogLyoKQEAg
LTEwNCw2ICsxMDYsMTAgQEAgc3RhdGljIHZvaWQgbWN0X3UyMzJfYnJlYWtf
Y3RsKHN0cnVjdCB0dAogc3RhdGljIGludCAgbWN0X3UyMzJfdGlvY21nZXQo
c3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwgc3RydWN0IGZpbGUgKmZpbGUpOwog
c3RhdGljIGludCAgbWN0X3UyMzJfdGlvY21zZXQoc3RydWN0IHR0eV9zdHJ1
Y3QgKnR0eSwgc3RydWN0IGZpbGUgKmZpbGUsCiAJCQl1bnNpZ25lZCBpbnQg
c2V0LCB1bnNpZ25lZCBpbnQgY2xlYXIpOworc3RhdGljIGludCAgbWN0X3Uy
MzJfaW9jdGwoc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwgc3RydWN0IGZpbGUg
KmZpbGUsCisJCQl1bnNpZ25lZCBpbnQgY21kLCB1bnNpZ25lZCBsb25nIGFy
Zyk7CitzdGF0aWMgaW50ICBtY3RfdTIzMl9nZXRfaWNvdW50KHN0cnVjdCB0
dHlfc3RydWN0ICp0dHksCisJCQlzdHJ1Y3Qgc2VyaWFsX2ljb3VudGVyX3N0
cnVjdCAqaWNvdW50KTsKIHN0YXRpYyB2b2lkIG1jdF91MjMyX3Rocm90dGxl
KHN0cnVjdCB0dHlfc3RydWN0ICp0dHkpOwogc3RhdGljIHZvaWQgbWN0X3Uy
MzJfdW50aHJvdHRsZShzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5KTsKIApAQCAt
MTUwLDkgKzE1NiwxMCBAQCBzdGF0aWMgc3RydWN0IHVzYl9zZXJpYWxfZHJp
dmVyIG1jdF91MjMyCiAJLnRpb2Ntc2V0ID0JICAgICBtY3RfdTIzMl90aW9j
bXNldCwKIAkuYXR0YWNoID0JICAgICBtY3RfdTIzMl9zdGFydHVwLAogCS5y
ZWxlYXNlID0JICAgICBtY3RfdTIzMl9yZWxlYXNlLAorCS5pb2N0bCA9ICAg
ICAgICAgICAgIG1jdF91MjMyX2lvY3RsLAorCS5nZXRfaWNvdW50ID0gICAg
ICAgIG1jdF91MjMyX2dldF9pY291bnQsCiB9OwogCi0KIHN0cnVjdCBtY3Rf
dTIzMl9wcml2YXRlIHsKIAlzcGlubG9ja190IGxvY2s7CiAJdW5zaWduZWQg
aW50CSAgICAgY29udHJvbF9zdGF0ZTsgLyogTW9kZW0gTGluZSBTZXR0aW5n
IChUSU9DTSkgKi8KQEAgLTE2MCw2ICsxNjcsOSBAQCBzdHJ1Y3QgbWN0X3Uy
MzJfcHJpdmF0ZSB7CiAJdW5zaWduZWQgY2hhcgkgICAgIGxhc3RfbHNyOyAg
ICAgIC8qIExpbmUgU3RhdHVzIFJlZ2lzdGVyICovCiAJdW5zaWduZWQgY2hh
cgkgICAgIGxhc3RfbXNyOyAgICAgIC8qIE1vZGVtIFN0YXR1cyBSZWdpc3Rl
ciAqLwogCXVuc2lnbmVkIGludAkgICAgIHJ4X2ZsYWdzOyAgICAgIC8qIFRo
cm90dGxpbmcgZmxhZ3MgKi8KKwlzdHJ1Y3QgYXN5bmNfaWNvdW50ICBpY291
bnQ7CisJd2FpdF9xdWV1ZV9oZWFkX3QgICAgbXNyX3dhaXQ7CS8qIGZvciBo
YW5kbGluZyBzbGVlcGluZyB3aGlsZSB3YWl0aW5nCisJCQkJCQlmb3IgbXNy
IGNoYW5nZSB0byBoYXBwZW4gKi8KIH07CiAKICNkZWZpbmUgVEhST1RUTEVE
CQkweDAxCkBAIC0zODYsNiArMzk2LDIwIEBAIHN0YXRpYyBpbnQgbWN0X3Uy
MzJfZ2V0X21vZGVtX3N0YXQoc3RydWMKIAlyZXR1cm4gcmM7CiB9IC8qIG1j
dF91MjMyX2dldF9tb2RlbV9zdGF0ICovCiAKK3N0YXRpYyB2b2lkIG1jdF91
MjMyX21zcl90b19pY291bnQoc3RydWN0IGFzeW5jX2ljb3VudCAqaWNvdW50
LAorCQkJCQkJdW5zaWduZWQgY2hhciBtc3IpCit7CisJLyogVHJhbnNsYXRl
IENvbnRyb2wgTGluZSBzdGF0ZXMgKi8KKwlpZiAobXNyICYgTUNUX1UyMzJf
TVNSX0REU1IpCisJCWljb3VudC0+ZHNyKys7CisJaWYgKG1zciAmIE1DVF9V
MjMyX01TUl9EQ1RTKQorCQlpY291bnQtPmN0cysrOworCWlmIChtc3IgJiBN
Q1RfVTIzMl9NU1JfRFJJKQorCQlpY291bnQtPnJuZysrOworCWlmIChtc3Ig
JiBNQ1RfVTIzMl9NU1JfRENEKQorCQlpY291bnQtPmRjZCsrOworfSAvKiBt
Y3RfdTIzMl9tc3JfdG9faWNvdW50ICovCisKIHN0YXRpYyB2b2lkIG1jdF91
MjMyX21zcl90b19zdGF0ZSh1bnNpZ25lZCBpbnQgKmNvbnRyb2xfc3RhdGUs
CiAJCQkJCQl1bnNpZ25lZCBjaGFyIG1zcikKIHsKQEAgLTQyMiw2ICs0NDYs
NyBAQCBzdGF0aWMgaW50IG1jdF91MjMyX3N0YXJ0dXAoc3RydWN0IHVzYl9z
CiAJaWYgKCFwcml2KQogCQlyZXR1cm4gLUVOT01FTTsKIAlzcGluX2xvY2tf
aW5pdCgmcHJpdi0+bG9jayk7CisJaW5pdF93YWl0cXVldWVfaGVhZCgmcHJp
di0+bXNyX3dhaXQpOwogCXVzYl9zZXRfc2VyaWFsX3BvcnRfZGF0YShzZXJp
YWwtPnBvcnRbMF0sIHByaXYpOwogCiAJaW5pdF93YWl0cXVldWVfaGVhZCgm
c2VyaWFsLT5wb3J0WzBdLT53cml0ZV93YWl0KTsKQEAgLTYyMSw2ICs2NDYs
OCBAQCBzdGF0aWMgdm9pZCBtY3RfdTIzMl9yZWFkX2ludF9jYWxsYmFjayhz
CiAJLyogUmVjb3JkIENvbnRyb2wgTGluZSBzdGF0ZXMgKi8KIAltY3RfdTIz
Ml9tc3JfdG9fc3RhdGUoJnByaXYtPmNvbnRyb2xfc3RhdGUsIHByaXYtPmxh
c3RfbXNyKTsKIAorCW1jdF91MjMyX21zcl90b19pY291bnQoJnByaXYtPmlj
b3VudCwgcHJpdi0+bGFzdF9tc3IpOworCiAjaWYgMAogCS8qIE5vdCB5ZXQg
aGFuZGxlZC4gU2VlIGJlbGtpbl9zYS5jIGZvciBmdXJ0aGVyIGluZm9ybWF0
aW9uICovCiAJLyogTm93IHRvIHJlcG9ydCBhbnkgZXJyb3JzICovCkBAIC02
NDcsNiArNjc0LDcgQEAgc3RhdGljIHZvaWQgbWN0X3UyMzJfcmVhZF9pbnRf
Y2FsbGJhY2socwogCQl0dHlfa3JlZl9wdXQodHR5KTsKIAl9CiAjZW5kaWYK
Kwl3YWtlX3VwX2ludGVycnVwdGlibGUoJnByaXYtPm1zcl93YWl0KTsKIAlz
cGluX3VubG9ja19pcnFyZXN0b3JlKCZwcml2LT5sb2NrLCBmbGFncyk7CiBl
eGl0OgogCXJldHZhbCA9IHVzYl9zdWJtaXRfdXJiKHVyYiwgR0ZQX0FUT01J
Qyk7CkBAIC04MjYsNyArODU0LDYgQEAgc3RhdGljIHZvaWQgbWN0X3UyMzJf
dGhyb3R0bGUoc3RydWN0IHR0eQogCX0KIH0KIAotCiBzdGF0aWMgdm9pZCBt
Y3RfdTIzMl91bnRocm90dGxlKHN0cnVjdCB0dHlfc3RydWN0ICp0dHkpCiB7
CiAJc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCA9IHR0eS0+ZHJpdmVy
X2RhdGE7CkBAIC04NDcsNiArODc0LDgyIEBAIHN0YXRpYyB2b2lkIG1jdF91
MjMyX3VudGhyb3R0bGUoc3RydWN0IHQKIAl9CiB9CiAKK3N0YXRpYyBpbnQg
IG1jdF91MjMyX2lvY3RsKHN0cnVjdCB0dHlfc3RydWN0ICp0dHksIHN0cnVj
dCBmaWxlICpmaWxlLAorCQkJdW5zaWduZWQgaW50IGNtZCwgdW5zaWduZWQg
bG9uZyBhcmcpCit7CisJREVGSU5FX1dBSVQod2FpdCk7CisJc3RydWN0IHVz
Yl9zZXJpYWxfcG9ydCAqcG9ydCA9IHR0eS0+ZHJpdmVyX2RhdGE7CisJc3Ry
dWN0IG1jdF91MjMyX3ByaXZhdGUgKm1jdF91MjMyX3BvcnQgPSB1c2JfZ2V0
X3NlcmlhbF9wb3J0X2RhdGEocG9ydCk7CisJc3RydWN0IGFzeW5jX2ljb3Vu
dCBjbm93LCBjcHJldjsKKwl1bnNpZ25lZCBsb25nIGZsYWdzOworCisJZGJn
KCIlcyAtIHBvcnQgJWQsIGNtZCA9IDB4JXgiLCBfX2Z1bmNfXywgcG9ydC0+
bnVtYmVyLCBjbWQpOworCisJc3dpdGNoIChjbWQpIHsKKworCWNhc2UgVElP
Q01JV0FJVDoKKworCQlkYmcoIiVzICglZCkgVElPQ01JV0FJVCIsIF9fZnVu
Y19fLCAgcG9ydC0+bnVtYmVyKTsKKworCQlzcGluX2xvY2tfaXJxc2F2ZSgm
bWN0X3UyMzJfcG9ydC0+bG9jaywgZmxhZ3MpOworCQljcHJldiA9IG1jdF91
MjMyX3BvcnQtPmljb3VudDsKKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
bWN0X3UyMzJfcG9ydC0+bG9jaywgZmxhZ3MpOworCQlmb3IgKCA7IDsgKSB7
CisJCQlwcmVwYXJlX3RvX3dhaXQoJm1jdF91MjMyX3BvcnQtPm1zcl93YWl0
LAorCQkJCQkmd2FpdCwgVEFTS19JTlRFUlJVUFRJQkxFKTsKKwkJCXNjaGVk
dWxlKCk7CisJCQlmaW5pc2hfd2FpdCgmbWN0X3UyMzJfcG9ydC0+bXNyX3dh
aXQsICZ3YWl0KTsKKwkJCS8qIHNlZSBpZiBhIHNpZ25hbCBkaWQgaXQgKi8K
KwkJCWlmIChzaWduYWxfcGVuZGluZyhjdXJyZW50KSkKKwkJCQlyZXR1cm4g
LUVSRVNUQVJUU1lTOworCQkJc3Bpbl9sb2NrX2lycXNhdmUoJm1jdF91MjMy
X3BvcnQtPmxvY2ssIGZsYWdzKTsKKwkJCWNub3cgPSBtY3RfdTIzMl9wb3J0
LT5pY291bnQ7CisJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZtY3RfdTIz
Ml9wb3J0LT5sb2NrLCBmbGFncyk7CisJCQlpZiAoY25vdy5ybmcgPT0gY3By
ZXYucm5nICYmIGNub3cuZHNyID09IGNwcmV2LmRzciAmJgorCQkJICAgIGNu
b3cuZGNkID09IGNwcmV2LmRjZCAmJiBjbm93LmN0cyA9PSBjcHJldi5jdHMp
CisJCQkJcmV0dXJuIC1FSU87IC8qIG5vIGNoYW5nZSA9PiBlcnJvciAqLwor
CQkJaWYgKCgoYXJnICYgVElPQ01fUk5HKSAmJiAoY25vdy5ybmcgIT0gY3By
ZXYucm5nKSkgfHwKKwkJCSAgICAoKGFyZyAmIFRJT0NNX0RTUikgJiYgKGNu
b3cuZHNyICE9IGNwcmV2LmRzcikpIHx8CisJCQkgICAgKChhcmcgJiBUSU9D
TV9DRCkgICYmIChjbm93LmRjZCAhPSBjcHJldi5kY2QpKSB8fAorCQkJICAg
ICgoYXJnICYgVElPQ01fQ1RTKSAmJiAoY25vdy5jdHMgIT0gY3ByZXYuY3Rz
KSkpIHsKKwkJCQlyZXR1cm4gMDsKKwkJCX0KKwkJCWNwcmV2ID0gY25vdzsK
KwkJfQorCisJfQorCXJldHVybiAtRU5PSU9DVExDTUQ7Cit9CisKK3N0YXRp
YyBpbnQgIG1jdF91MjMyX2dldF9pY291bnQoc3RydWN0IHR0eV9zdHJ1Y3Qg
KnR0eSwKKwkJCXN0cnVjdCBzZXJpYWxfaWNvdW50ZXJfc3RydWN0ICppY291
bnQpCit7CisJc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9ydCA9IHR0eS0+
ZHJpdmVyX2RhdGE7CisJc3RydWN0IG1jdF91MjMyX3ByaXZhdGUgKm1jdF91
MjMyX3BvcnQgPSB1c2JfZ2V0X3NlcmlhbF9wb3J0X2RhdGEocG9ydCk7CisJ
c3RydWN0IGFzeW5jX2ljb3VudCAqaWMgPSAmbWN0X3UyMzJfcG9ydC0+aWNv
dW50OworCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CisKKwlzcGluX2xvY2tfaXJx
c2F2ZSgmbWN0X3UyMzJfcG9ydC0+bG9jaywgZmxhZ3MpOworCisJaWNvdW50
LT5jdHMgPSBpYy0+Y3RzOworCWljb3VudC0+ZHNyID0gaWMtPmRzcjsKKwlp
Y291bnQtPnJuZyA9IGljLT5ybmc7CisJaWNvdW50LT5kY2QgPSBpYy0+ZGNk
OworCWljb3VudC0+cnggPSBpYy0+cng7CisJaWNvdW50LT50eCA9IGljLT50
eDsKKwlpY291bnQtPmZyYW1lID0gaWMtPmZyYW1lOworCWljb3VudC0+b3Zl
cnJ1biA9IGljLT5vdmVycnVuOworCWljb3VudC0+cGFyaXR5ID0gaWMtPnBh
cml0eTsKKwlpY291bnQtPmJyayA9IGljLT5icms7CisJaWNvdW50LT5idWZf
b3ZlcnJ1biA9IGljLT5idWZfb3ZlcnJ1bjsKKworCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJm1jdF91MjMyX3BvcnQtPmxvY2ssIGZsYWdzKTsKKworCWRi
ZygiJXMgKCVkKSBUSU9DR0lDT1VOVCBSWD0lZCwgVFg9JWQiLAorCQlfX2Z1
bmNfXywgIHBvcnQtPm51bWJlciwgaWNvdW50LT5yeCwgaWNvdW50LT50eCk7
CisJcmV0dXJuIDA7Cit9CisKIHN0YXRpYyBpbnQgX19pbml0IG1jdF91MjMy
X2luaXQodm9pZCkKIHsKIAlpbnQgcmV0dmFsOwo=

--0-1522773082-1293483338=:58416--
