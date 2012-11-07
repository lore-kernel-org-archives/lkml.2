Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab2KGNOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 08:14:23 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47859 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2KGNOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 08:14:21 -0500
MIME-Version: 1.0
In-Reply-To: <20121106112751.GD11931@arwen.pp.htv.fi>
References: <50929233.7030609@gmail.com> <50967BFD.6000308@gmail.com> <20121106112751.GD11931@arwen.pp.htv.fi>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Wed, 7 Nov 2012 14:14:00 +0100
X-Google-Sender-Auth: M9CbqsaFyXnEpHm1i9aZyzyi_ns
Message-ID: <CAOUdcc_z=LbvNmapSKA0n7bny6wO+Ke67BQtF9J87TkV=ygSbw@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae9340ddf24cf6c04cde77ff0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9340ddf24cf6c04cde77ff0
Content-Type: text/plain; charset=ISO-8859-1

Unfortunately I have some issues with git send-email.
I've attached the patch itself ..

regards,
-- dmytro

On Tue, Nov 6, 2012 at 12:27 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Sun, Nov 04, 2012 at 03:30:21PM +0100, Dmytro Milinevskyy wrote:
>> Convert USB descriptor's fields to CPU byte order before using locally in USB NCM gadget driver.
>> Tested on MIPS32 big-endian device.
>>
>> Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
>
> doesn't apply:
>
> $ patch -p1 --dry-run < patch.diff
> patching file drivers/usb/gadget/f_ncm.c
> patch: **** malformed patch at line 31: @@ -869,15 +869,19 @@ static struct sk_buff *ncm_wrap_ntb(struct gether *port,
>
> can you use git-send-email ?
>
>> ---
>>  drivers/usb/gadget/f_ncm.c | 12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
>> index b651b52..a7cdd47 100644
>> --- a/drivers/usb/gadget/f_ncm.c
>> +++ b/drivers/usb/gadget/f_ncm.c
>> @@ -102,7 +102,7 @@ static inline unsigned ncm_bitrate(struct usb_gadget *g)
>>                                USB_CDC_NCM_NTB32_SUPPORTED)
>>  static struct usb_cdc_ncm_ntb_parameters ntb_parameters = {
>> -     .wLength = sizeof ntb_parameters,
>> +     .wLength = cpu_to_le16(sizeof(ntb_parameters)),
>>       .bmNtbFormatsSupported = cpu_to_le16(FORMATS_SUPPORTED),
>>       .dwNtbInMaxSize = cpu_to_le32(NTB_DEFAULT_IN_SIZE),
>>       .wNdpInDivisor = cpu_to_le16(4),
>> @@ -869,15 +869,19 @@ static struct sk_buff *ncm_wrap_ntb(struct gether *port,
>>       struct sk_buff  *skb2;
>>       int             ncb_len = 0;
>>       __le16          *tmp;
>> -     int             div = ntb_parameters.wNdpInDivisor;
>> -     int             rem = ntb_parameters.wNdpInPayloadRemainder;
>> +     int             div;
>> +     int             rem;
>>       int             pad;
>> -     int             ndp_align = ntb_parameters.wNdpInAlignment;
>> +     int             ndp_align;
>>       int             ndp_pad;
>>       unsigned        max_size = ncm->port.fixed_in_len;
>>       struct ndp_parser_opts *opts = ncm->parser_opts;
>>       unsigned        crc_len = ncm->is_crc ? sizeof(uint32_t) : 0;
>> +     div = le16_to_cpu(ntb_parameters.wNdpInDivisor);
>> +     rem = le16_to_cpu(ntb_parameters.wNdpInPayloadRemainder);
>> +     ndp_align = le16_to_cpu(ntb_parameters.wNdpInAlignment);
>> +
>>       ncb_len += opts->nth_size;
>>       ndp_pad = ALIGN(ncb_len, ndp_align) - ncb_len;
>>       ncb_len += ndp_pad;
>> --
>> 1.8.0
>>
>>
>
> --
> balbi

--14dae9340ddf24cf6c04cde77ff0
Content-Type: application/octet-stream; 
	name="0001-usb-gadget-ncm-correct-endianess-conversion.patch"
Content-Disposition: attachment; 
	filename="0001-usb-gadget-ncm-correct-endianess-conversion.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h98gy7sp1

RnJvbSBhYzViNWFhMDFjMDcwZTVjYTkwMDE5MDU3MzJmYTllYTk2MTEyNzg3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEbXl0cm8gTWlsaW5ldnNreXkgPG1pbGluZXZza3l5QGdtYWls
LmNvbT4KRGF0ZTogRnJpLCA1IE9jdCAyMDEyIDAxOjQ0OjA0ICswMzAwClN1YmplY3Q6IFtQQVRD
SF0gdXNiOiBnYWRnZXQ6IG5jbTogY29ycmVjdCBlbmRpYW5lc3MgY29udmVyc2lvbgoKQ29udmVy
dCBVU0IgZGVzY3JpcHRvcidzIGZpZWxkcyB0byBDUFUgYnl0ZSBvcmRlciBiZWZvcmUgdXNpbmcg
bG9jYWxseSBpbiBVU0IgTkNNIGdhZGdldCBkcml2ZXIuClRlc3RlZCBvbiBNSVBTMzIgYmlnLWVu
ZGlhbiBkZXZpY2UuCgpTaWduZWQtb2ZmLWJ5OiBEbXl0cm8gTWlsaW5ldnNreXkgPG1pbGluZXZz
a3l5QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL3VzYi9nYWRnZXQvZl9uY20uYyB8IDEyICsrKysr
KysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9nYWRnZXQvZl9uY20uYyBiL2RyaXZlcnMvdXNiL2dh
ZGdldC9mX25jbS5jCmluZGV4IGI2NTFiNTIuLmE3Y2RkNDcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
dXNiL2dhZGdldC9mX25jbS5jCisrKyBiL2RyaXZlcnMvdXNiL2dhZGdldC9mX25jbS5jCkBAIC0x
MDIsNyArMTAyLDcgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBuY21fYml0cmF0ZShzdHJ1Y3Qg
dXNiX2dhZGdldCAqZykKIAkJCQkgVVNCX0NEQ19OQ01fTlRCMzJfU1VQUE9SVEVEKQogCiBzdGF0
aWMgc3RydWN0IHVzYl9jZGNfbmNtX250Yl9wYXJhbWV0ZXJzIG50Yl9wYXJhbWV0ZXJzID0gewot
CS53TGVuZ3RoID0gc2l6ZW9mIG50Yl9wYXJhbWV0ZXJzLAorCS53TGVuZ3RoID0gY3B1X3RvX2xl
MTYoc2l6ZW9mKG50Yl9wYXJhbWV0ZXJzKSksCiAJLmJtTnRiRm9ybWF0c1N1cHBvcnRlZCA9IGNw
dV90b19sZTE2KEZPUk1BVFNfU1VQUE9SVEVEKSwKIAkuZHdOdGJJbk1heFNpemUgPSBjcHVfdG9f
bGUzMihOVEJfREVGQVVMVF9JTl9TSVpFKSwKIAkud05kcEluRGl2aXNvciA9IGNwdV90b19sZTE2
KDQpLApAQCAtODY5LDE1ICs4NjksMTkgQEAgc3RhdGljIHN0cnVjdCBza19idWZmICpuY21fd3Jh
cF9udGIoc3RydWN0IGdldGhlciAqcG9ydCwKIAlzdHJ1Y3Qgc2tfYnVmZgkqc2tiMjsKIAlpbnQJ
CW5jYl9sZW4gPSAwOwogCV9fbGUxNgkJKnRtcDsKLQlpbnQJCWRpdiA9IG50Yl9wYXJhbWV0ZXJz
LndOZHBJbkRpdmlzb3I7Ci0JaW50CQlyZW0gPSBudGJfcGFyYW1ldGVycy53TmRwSW5QYXlsb2Fk
UmVtYWluZGVyOworCWludAkJZGl2OworCWludAkJcmVtOwogCWludAkJcGFkOwotCWludAkJbmRw
X2FsaWduID0gbnRiX3BhcmFtZXRlcnMud05kcEluQWxpZ25tZW50OworCWludAkJbmRwX2FsaWdu
OwogCWludAkJbmRwX3BhZDsKIAl1bnNpZ25lZAltYXhfc2l6ZSA9IG5jbS0+cG9ydC5maXhlZF9p
bl9sZW47CiAJc3RydWN0IG5kcF9wYXJzZXJfb3B0cyAqb3B0cyA9IG5jbS0+cGFyc2VyX29wdHM7
CiAJdW5zaWduZWQJY3JjX2xlbiA9IG5jbS0+aXNfY3JjID8gc2l6ZW9mKHVpbnQzMl90KSA6IDA7
CiAKKwlkaXYgPSBsZTE2X3RvX2NwdShudGJfcGFyYW1ldGVycy53TmRwSW5EaXZpc29yKTsKKwly
ZW0gPSBsZTE2X3RvX2NwdShudGJfcGFyYW1ldGVycy53TmRwSW5QYXlsb2FkUmVtYWluZGVyKTsK
KwluZHBfYWxpZ24gPSBsZTE2X3RvX2NwdShudGJfcGFyYW1ldGVycy53TmRwSW5BbGlnbm1lbnQp
OworCiAJbmNiX2xlbiArPSBvcHRzLT5udGhfc2l6ZTsKIAluZHBfcGFkID0gQUxJR04obmNiX2xl
biwgbmRwX2FsaWduKSAtIG5jYl9sZW47CiAJbmNiX2xlbiArPSBuZHBfcGFkOwotLSAKMS44LjAK
Cg==
--14dae9340ddf24cf6c04cde77ff0--
