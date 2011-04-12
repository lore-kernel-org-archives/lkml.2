Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab1DLUjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:39:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42313 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab1DLUjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TTpv8XdfmUthtawgf81u0jtyudJrFL4rbsBuboazd9lucmUs8jNaxrUsIcxM6fWTlf
         L/DbPXF/riKJAgkz8p4dNmZ7tROu1Bc0pxwf3amqtH34vo+RYgxgu/28EdAVWqFuNjc8
         i2xISUh3l3xqNhATWWijqNZKF3whRJCN5skUY=
MIME-Version: 1.0
In-Reply-To: <20110412193943.GA30089@elf.ucw.cz>
References: <20110315192111.GA2983@ucw.cz>
	<AANLkTikJD3+HSoHbq2BxAyYbtGik8QizuRv=rkPEtJXN@mail.gmail.com>
	<20110412193943.GA30089@elf.ucw.cz>
Date: Wed, 13 Apr 2011 00:39:40 +0400
Message-ID: <BANLkTimTmhXYHYOQwh_Q1uohFJdaKecJkA@mail.gmail.com>
Subject: Re: [Zaurus-devel] 8250 vs pxa_serial (was Re: pxa27x/spitz: serials
 in recent kernels)
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Zaurus PDA developers list <zaurus-devel@www.linuxtogo.org>
Cc: Pavel Machek <pavel@ucw.cz>, Andrea Adami <andrea.adami@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001636d34fbfff1abc04a0beb02e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636d34fbfff1abc04a0beb02e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, Apr 12, 2011 at 11:39 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > I cculd not get serial port to work in recent kernels (2.6.35 was
>> > oldest I tried). I know they are little used but still very useful for
>> > debugging.
>> >
>> > Is there some special config that needs to be done?
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Pavel
>>
>> I have output on ttyS0 using the Sharp cable, never had issues.
>> Remember that bootloader is 9600n8 while kernels are usually 115200n8.
>
> Ok, I know what is going on. I need both PXA_SERIAL and 8250... and
> these two don't go well together.
>
> I tried:
>
> CONFIG_SERIAL_8250=3Dy
> # CONFIG_SERIAL_8250_CONSOLE is not set
> CONFIG_SERIAL_8250_CS=3Dy
> CONFIG_SERIAL_8250_NR_UARTS=3D1
> CONFIG_SERIAL_8250_RUNTIME_UARTS=3D0
> # CONFIG_SERIAL_8250_EXTENDED is not set
>
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MAX3100 is not set
> # CONFIG_SERIAL_MAX3107 is not set
> CONFIG_SERIAL_PXA=3Dy
> CONFIG_SERIAL_PXA_CONSOLE=3Dy
> CONFIG_SERIAL_CORE=3Dy
> CONFIG_SERIAL_CORE_CONSOLE=3Dy
>
> (BTW should 8250_RUNTIME_UARTS be called "boottime uarts"? That's what
> help says).
>
> ...but no luck. As soon as I enable 8250, pxa serials stop working
> :-(.

Please try attached patch (then PXA consoles become ttySA0-3)




--=20
With best wishes
Dmitry

--001636d34fbfff1abc04a0beb02e
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-pxa-rename-serials-to-reuse-ttySA-naming.patch"
Content-Disposition: attachment; 
	filename="0001-pxa-rename-serials-to-reuse-ttySA-naming.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmfaoriu0

RnJvbSBhMzI1ZWYzN2FhZTFjMTU1NjcyZjE1MDJiYzk4NjRjMGVlODdjYmQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEbWl0cnkgRXJlbWluLVNvbGVuaWtvdiA8ZGJhcnlzaGtvdkBn
bWFpbC5jb20+CkRhdGU6IFR1ZSwgNCBKYW4gMjAxMSAyMzozMzo0NCArMDMwMApTdWJqZWN0OiBb
UEFUQ0hdIHB4YTogcmVuYW1lIHNlcmlhbHMgdG8gcmV1c2UgdHR5U0EgbmFtaW5nCgpTaWduZWQt
b2ZmLWJ5OiBEbWl0cnkgRXJlbWluLVNvbGVuaWtvdiA8ZGJhcnlzaGtvdkBnbWFpbC5jb20+Ci0t
LQogZHJpdmVycy90dHkvc2VyaWFsL3B4YS5jIHwgICAgNiArKystLS0KIDEgZmlsZXMgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dHR5L3NlcmlhbC9weGEuYyBiL2RyaXZlcnMvdHR5L3NlcmlhbC9weGEuYwppbmRleCAxMTAyYTM5
Li4xNGZiNTY2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3R0eS9zZXJpYWwvcHhhLmMKKysrIGIvZHJp
dmVycy90dHkvc2VyaWFsL3B4YS5jCkBAIC02OTIsNyArNjkyLDcgQEAgc2VyaWFsX3B4YV9jb25z
b2xlX3NldHVwKHN0cnVjdCBjb25zb2xlICpjbywgY2hhciAqb3B0aW9ucykKIH0KIAogc3RhdGlj
IHN0cnVjdCBjb25zb2xlIHNlcmlhbF9weGFfY29uc29sZSA9IHsKLQkubmFtZQkJPSAidHR5UyIs
CisJLm5hbWUJCT0gInR0eVNBIiwKIAkud3JpdGUJCT0gc2VyaWFsX3B4YV9jb25zb2xlX3dyaXRl
LAogCS5kZXZpY2UJCT0gdWFydF9jb25zb2xlX2RldmljZSwKIAkuc2V0dXAJCT0gc2VyaWFsX3B4
YV9jb25zb2xlX3NldHVwLApAQCAtNzI5LDggKzcyOSw4IEBAIHN0cnVjdCB1YXJ0X29wcyBzZXJp
YWxfcHhhX3BvcHMgPSB7CiBzdGF0aWMgc3RydWN0IHVhcnRfZHJpdmVyIHNlcmlhbF9weGFfcmVn
ID0gewogCS5vd25lcgkJPSBUSElTX01PRFVMRSwKIAkuZHJpdmVyX25hbWUJPSAiUFhBIHNlcmlh
bCIsCi0JLmRldl9uYW1lCT0gInR0eVMiLAotCS5tYWpvcgkJPSBUVFlfTUFKT1IsCisJLmRldl9u
YW1lCT0gInR0eVNBIiwKKwkubWFqb3IJCT0gMjA0LAogCS5taW5vcgkJPSA2NCwKIAkubnIJCT0g
NCwKIAkuY29ucwkJPSBQWEFfQ09OU09MRSwKLS0gCjEuNy40LjEKCg==
--001636d34fbfff1abc04a0beb02e--
