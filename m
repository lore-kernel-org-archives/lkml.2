Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab1JFWaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:30:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63924 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1JFWaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:30:21 -0400
MIME-Version: 1.0
Date: Thu, 6 Oct 2011 15:30:19 -0700
Message-ID: <CAO3ZPq18MfYTu_6_RLZvvB0_0aFwTR3AfzKbKMRp5Bzt62Frnw@mail.gmail.com>
Subject: MODULE_LICENSE("GPL") not working for me
From: Stephen Williams <steveicarus@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0ce0f5989b680d04aea8de99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0ce0f5989b680d04aea8de99
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have some large drivers for use in embedded arm systems, and
I want them to be GPL, because I want to use some symbols exported
as GPL, and also because I just wanna. But it is not working for
me. I've attached my Makefile. I'm building from outside the kernel
tree, but that should be OK. (right?) I'm using the following script to
actually build:

SE0=3D/home/u/wing/steve/picturel/SE0
CROSS_COMPILE=3D/opt/CodeSourcery/Sourcery_G++_Lite/bin/arm-none-linux-gnue=
abi-
export CROSS_COMPILE
make KERNELDIR=3D$SE0/linux-2.6.33-quatro ARCH=3Darm modules

But no matter what I do, when I try to load my module, I get
errors line this:

# insmod ./vidfor2.ko
vidfor: module license 'unspecified' taints kernel.
Disabling lock debugging due to kernel taint
vidfor: Unknown symbol driver_remove_file
vidfor: Unknown symbol driver_create_file
insmod: can't insert './vidfor2.ko': unknown symbol in module or
invalid parameter

I have a MODULE_LICENSE("GPL"); line in the "linux.c" source file,
and the pertinent parts of the makefile are here:

OBJ :=3D linux.o ops.o console.o sysfs.o ident_tables.o
LIBOBJ :=3D vidforio.o init.o format.o video.o isr.o version.o

ifneq ($(KERNELRELEASE),)

EXTRA_CFLAGS +=3D -I$(M)/../libvidforio
obj-m +=3D vidfor.o
vidfor-objs :=3D $(OBJ) $(patsubst %,../libvidforio/%,$(LIBOBJ))

else
[...]

What's the trick for getting the MODULE_LICENSE successfully stamped
into my generated .ko file?

I've googled the list and the internet in general, and found
as many relevant examples as I could in the kernel source, but
I'm at wit's end. I'm not subscribed, so please CC responses,
although I will check back often.



--=20
Steve Williams=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "The woods are lovely, dark a=
nd deep.
steve at icarus.com=A0 =A0 =A0 =A0 =A0=A0 But I have promises to keep,
http://www.icarus.com=A0 =A0 =A0 =A0=A0 and lines to code before I sleep,
http://www.picturel.com=A0 =A0 =A0=A0 And lines to code before I sleep."

--000e0ce0f5989b680d04aea8de99
Content-Type: application/octet-stream; name=Makefile
Content-Disposition: attachment; filename=Makefile
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtgbhago0

CgpEUlZPQkogOj0gbGludXgubyBvcHMubyBjb25zb2xlLm8gc3lzZnMubyBpZGVudF90YWJsZXMu
bwpMSUJPQkogOj0gdmlkZm9yaW8ubyBpbml0Lm8gZm9ybWF0Lm8gdmlkZW8ubyBpc3IubyB2ZXJz
aW9uLm8KCmlmbmVxICgkKEtFUk5FTFJFTEVBU0UpLCkKCkVYVFJBX0NGTEFHUyArPSAtSSQoTSkv
Li4vbGlidmlkZm9yaW8Kb2JqLW0gKz0gdmlkZm9yLm8KdmlkZm9yLW9ianMgOj0gJChEUlZPQkop
ICQocGF0c3Vic3QgJSwuLi9saWJ2aWRmb3Jpby8lLCQoTElCT0JKKSkKCmVsc2UKCktFUk5FTERJ
UiA/PSAvbGliL21vZHVsZXMvJChzaGVsbCB1bmFtZSAtcikvYnVpbGQKUFdEIDo9ICQoc2hlbGwg
cHdkKQoKdmVyc2lvbiBpZGVudF90YWJsZXMuYzoKCUBlY2hvICcgLyogTUFDSElORSBHRU5FUkFU
RUQgLS0gRE8gTk9UIEVESVQgKi8nID4gdG1wLmMKCUBlY2hvICdjb25zdCBjaGFyIHZpZGZvcl9i
dWlsZF9zdGFtcFtdID0nID4+IHRtcC5jCglAZWNobyAnIidgZ2l0IGRlc2NyaWJlIC0tdGFncyAt
LWxvbmcgLS1hbHdheXMgLS1tYXRjaCBzeXMtXCpgJyI7JyA+PiB0bXAuYwoJQGRpZmYgdG1wLmMg
aWRlbnRfdGFibGVzLmMgPiAvZGV2L251bGwgMj4mMSB8fCAoZWNobyAidXBkYXRpbmcgaWRlbnRf
dGFibGVzLmMiOyBjcCB0bXAuYyBpZGVudF90YWJsZXMuYykKCUBybSAtZiB0bXAuYwoKbW9kdWxl
czoKCSQoTUFLRSkgLUMgLi4vbGlidmlkZm9yaW8gdmVyc2lvbgoJJChNQUtFKSB2ZXJzaW9uCgkk
KE1BS0UpIC1DICQoS0VSTkVMRElSKSBNPSQoUFdEKSBtb2R1bGVzCgptb2R1bGVzX2luc3RhbGw6
CgkkKE1BS0UpIC1DICQoS0VSTkVMRElSKSBNPSQoUFdEKSBtb2R1bGVzX2luc3RhbGwKCmNsZWFu
OgoJJChNQUtFKSAtQyAkKEtFUk5FTERJUikgTT0kKFBXRCkgY2xlYW4KCmVuZGlmCg==
--000e0ce0f5989b680d04aea8de99--
