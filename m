Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab2AIWlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:41:06 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46300 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755899Ab2AIWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:41:03 -0500
MIME-Version: 1.0
In-Reply-To: <4F0B569B.6050004@xenotime.net>
References: <20120109170457.4465dfc66a0eace4a2230fef@canb.auug.org.au> <4F0B569B.6050004@xenotime.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Jan 2012 15:40:39 -0700
Message-ID: <CAErSpo4+remnOA6gJXOz_54CsbbcOq_Yj=ua9gV_bq5dZ64ABA@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 9 (arch/x86/pci/amd_bus.c)
To: Randy Dunlap <rdunlap@xenotime.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
X-System-Of-Record: true
Content-Type: multipart/mixed; boundary=e89a8f22c691cdb6e604b6201787
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f22c691cdb6e604b6201787
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jan 9, 2012 at 2:05 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> on several i386 builds:
>
> amd_bus.c:(.init.text+0x134b): undefined reference to `amd_get_mmconfig_range'

This is my fault.  I moved some code from amd_bus.c to amd_nb.c, and builds with

        CONFIG_PCI=y
        # CONFIG_AMD_NB not set

now fail.  The attached patch should fix it.  I'll repost the series
("x86/PCI: amd: factor out MMCONFIG discovery") with the fix.

Yinghai, it looks to me like there's no reason to build amd_bus.o
unless we have CONFIG_AMD_NB=y, but speak up if I'm wrong :)

Bjorn

--e89a8f22c691cdb6e604b6201787
Content-Type: application/octet-stream; name="patch.amd-build-fix"
Content-Disposition: attachment; filename="patch.amd-build-fix"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx82rnqs0

Y29tbWl0IGM3NjJmZTU4MTVmMTIyMDE1OWYyNTdlYzRjZjc1MWI0N2JhYjk4ZmYKQXV0aG9yOiBC
am9ybiBIZWxnYWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPgpEYXRlOiAgIE1vbiBKYW4gOSAxMzo0
MjoxMiAyMDEyIC0wNzAwCgogICAgeDg2L1BDSTogYnVpbGQgYW1kX2J1cy5vIG9ubHkgd2hlbiBD
T05GSUdfQU1EX05CPXkKICAgIAogICAgV2Ugb25seSBuZWVkIGFtZF9idXMubyBmb3IgQU1EIHN5
c3RlbXMgd2l0aCBQQ0kuICBhcmNoL3g4Ni9wY2kvTWFrZWZpbGUKICAgIGFscmVhZHkgZGVwZW5k
cyBvbiBDT05GSUdfUENJPXksIHNvIHRoaXMgcGF0Y2gganVzdCBhZGRzIHRoZSBkZXBlbmRlbmN5
CiAgICBvbiBDT05GSUdfQU1EX05CLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBCam9ybiBIZWxn
YWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPgoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L3BjaS9NYWtl
ZmlsZSBiL2FyY2gveDg2L3BjaS9NYWtlZmlsZQppbmRleCA2Yjg3NTlmLi5kMjRkM2RhIDEwMDY0
NAotLS0gYS9hcmNoL3g4Ni9wY2kvTWFrZWZpbGUKKysrIGIvYXJjaC94ODYvcGNpL01ha2VmaWxl
CkBAIC0xOCw4ICsxOCw5IEBAIG9iai0kKENPTkZJR19YODZfTlVNQVEpCQkrPSBudW1hcV8zMi5v
CiBvYmotJChDT05GSUdfWDg2X01SU1QpCQkrPSBtcnN0Lm8KIAogb2JqLXkJCQkJKz0gY29tbW9u
Lm8gZWFybHkubwotb2JqLXkJCQkJKz0gYW1kX2J1cy5vIGJ1c19udW1hLm8KK29iai15CQkJCSs9
IGJ1c19udW1hLm8KIAorb2JqLSQoQ09ORklHX0FNRF9OQikJCSs9IGFtZF9idXMubwogb2JqLSQo
Q09ORklHX1BDSV9DTkIyMExFX1FVSVJLKQkrPSBicm9hZGNvbV9idXMubwogCiBpZmVxICgkKENP
TkZJR19QQ0lfREVCVUcpLHkpCg==
--e89a8f22c691cdb6e604b6201787--
