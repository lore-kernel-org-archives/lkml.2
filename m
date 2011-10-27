Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1J0JCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 05:02:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60843 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab1J0JCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 05:02:05 -0400
MIME-Version: 1.0
Date: Thu, 27 Oct 2011 11:02:04 +0200
Message-ID: <CAH+fs=-WkbLgB-wsNEPS_OnvqwK9eChMCrMOudjtg7bu2ZtqHg@mail.gmail.com>
Subject: [PATCH]: expose FORCE_MAX_ZONEORDER on x86
From: Marc Leeman <marc.leeman@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Content-Type: multipart/mixed; boundary=20cf3079bfeec9c79504b044061b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3079bfeec9c79504b044061b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Larger blocks of memory can be required for e.g. higher resolutions on
some capture card drivers; this patch just enables an already
available configuration option on x86 (it was already exposed on other
architectures).

The default is set to 11, as in
./include/linux/mmzone.h

[barco@nmgserver001 linux-3.0]$ find . -name Kconfig | xargs grep
FORCE_MAX_ZONEORDER
./arch/ia64/Kconfig:config FORCE_MAX_ZONEORDER
./arch/cris/Kconfig:config FORCE_MAX_ZONEORDER
./arch/arm/Kconfig:config FORCE_MAX_ZONEORDER
./arch/s390/Kconfig:config FORCE_MAX_ZONEORDER
./arch/mips/Kconfig:config FORCE_MAX_ZONEORDER
./arch/sh/mm/Kconfig:config FORCE_MAX_ZONEORDER
./arch/blackfin/Kconfig:config FORCE_MAX_ZONEORDER
./arch/powerpc/Kconfig:config FORCE_MAX_ZONEORDER



--=20
br, marc

The best approach for you requires two steps. The first step is
reading the Manual.
=A0 =A0 Wolfgang Denk - u-boot mailing list

--20cf3079bfeec9c79504b044061b
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-KConfig-x86-enable-FORCE_MAX_ZONEORDER.patch"
Content-Disposition: attachment; 
	filename="0001-KConfig-x86-enable-FORCE_MAX_ZONEORDER.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gu9i334c0

RnJvbSA4YWQ2NGVkYmY5MmFjOGUwMjUzNjc3YmQzZjlhZDM3NmNlM2JlN2QxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJjIExlZW1hbiA8bWFyYy5sZWVtYW5AZ21haWwuY29tPgpE
YXRlOiBXZWQsIDI2IE9jdCAyMDExIDEwOjM1OjI0ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gS0Nv
bmZpZyB4ODY6IGVuYWJsZSBGT1JDRV9NQVhfWk9ORU9SREVSCgotLS0KIGFyY2gveDg2L0tjb25m
aWcgfCAgIDE2ICsrKysrKysrKysrKysrKysKIDEgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9u
cygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9LY29uZmlnIGIvYXJj
aC94ODYvS2NvbmZpZwppbmRleCA5YTRhMjY3Li42OGE5OGU4IDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9LY29uZmlnCisrKyBiL2FyY2gveDg2L0tjb25maWcKQEAgLTEyNzMsNiArMTI3MywyMiBAQCBj
b25maWcgSUxMRUdBTF9QT0lOVEVSX1ZBTFVFCiAKIHNvdXJjZSAibW0vS2NvbmZpZyIKIAorY29u
ZmlnIEZPUkNFX01BWF9aT05FT1JERVIKKwlpbnQgIk1heGltdW0gem9uZSBvcmRlciIgCisJcmFu
Z2UgMTEgNjQKKwlkZWZhdWx0ICIxMSIKKwloZWxwCisJICBUaGUga2VybmVsIG1lbW9yeSBhbGxv
Y2F0b3IgZGl2aWRlcyBwaHlzaWNhbGx5IGNvbnRpZ3VvdXMgbWVtb3J5CisJICBibG9ja3MgaW50
byAiem9uZXMiLCB3aGVyZSBlYWNoIHpvbmUgaXMgYSBwb3dlciBvZiB0d28gbnVtYmVyIG9mCisJ
ICBwYWdlcy4gIFRoaXMgb3B0aW9uIHNlbGVjdHMgdGhlIGxhcmdlc3QgcG93ZXIgb2YgdHdvIHRo
YXQgdGhlIGtlcm5lbAorCSAga2VlcHMgaW4gdGhlIG1lbW9yeSBhbGxvY2F0b3IuICBJZiB5b3Ug
bmVlZCB0byBhbGxvY2F0ZSB2ZXJ5IGxhcmdlCisJICBibG9ja3Mgb2YgcGh5c2ljYWxseSBjb250
aWd1b3VzIG1lbW9yeSwgdGhlbiB5b3UgbWF5IG5lZWQgdG8KKwkgIGluY3JlYXNlIHRoaXMgdmFs
dWUuCisKKwkgIFRoaXMgY29uZmlnIG9wdGlvbiBpcyBhY3R1YWxseSBtYXhpbXVtIG9yZGVyIHBs
dXMgb25lLiBGb3IgZXhhbXBsZSwKKwkgIGEgdmFsdWUgb2YgMTEgbWVhbnMgdGhhdCB0aGUgbGFy
Z2VzdCBmcmVlIG1lbW9yeSBibG9jayBpcyAyXjEwIHBhZ2VzLgorCisKIGNvbmZpZyBISUdIUFRF
CiAJYm9vbCAiQWxsb2NhdGUgM3JkLWxldmVsIHBhZ2V0YWJsZXMgZnJvbSBoaWdobWVtIgogCWRl
cGVuZHMgb24gSElHSE1FTQotLSAKMS43LjIuNQoK
--20cf3079bfeec9c79504b044061b--
