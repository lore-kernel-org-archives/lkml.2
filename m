Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0HaGyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:54:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51910 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab0HaGyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:54:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Cc: kosaki.motohiro@jp.fujitsu.com, "M. Vefa Bicakci" <bicave@superonline.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20100831091909.87C1.A69D9226@jp.fujitsu.com>
References: <4C7BE25B.1020504@superonline.com> <20100831091909.87C1.A69D9226@jp.fujitsu.com>
Message-Id: <20100831155302.87E2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------_4C7CA6CE000000008B98_MULTIPART_MIXED_"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 31 Aug 2010 15:54:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------_4C7CA6CE000000008B98_MULTIPART_MIXED_
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit

> > === 8< ===
> > PM: Marking nosave pages: ...0009f000 - ...000100000
> > PM: basic memory bitmaps created
> > PM: Syncing filesystems ... done
> > Freezing user space processes ... (elapsed 0.01 seconds) done.
> > Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> > PM: Preallocating image memory...
> > shrink_all_memory start
> > PM: shrink memory: pass=1, req:310171 reclaimed:15492 free:360936
> > PM: shrink memory: pass=2, req:294679 reclaimed:28864 free:373981
> > PM: shrink memory: pass=3, req:265815 reclaimed:60311 free:405374
> > PM: shrink memory: pass=4, req:205504 reclaimed:97870 free:443024
> > PM: shrink memory: pass=5, req:107634 reclaimed:146948 free:492141
> > shrink_all_memory: req:107634 reclaimed:146948 free:492141
> > PM: preallocate_image_highmem 556658 278329
> > PM: preallocate_image_memory 103139 103139
> > PM: preallocate_highmem_fraction 183908 556658 760831 -> 183908
> > === >8 ===
> > 
> > According to your patch, the next output should have been
> > "preallocate_image_memory ...", but it never gets printed, so the
> > hang point should be that function.
> 
> Great!
> I've attached more verbose debug message patch and trial bug fixing patch.
> Could you please to try this?

Oops, please apply attached patch instead 0002-add-gfp_noretry.patch.

Thanks.

--------_4C7CA6CE000000008B98_MULTIPART_MIXED_
Content-Type: application/octet-stream;
 name="0001-do_try_to_free_pages-oom_killer_disabled.patch"
Content-Disposition: attachment;
 filename="0001-do_try_to_free_pages-oom_killer_disabled.patch"
Content-Transfer-Encoding: base64

RnJvbSA4ODM0OTIxNTg2Mjc4NWM0NDc3YWJjYjljMDc1NTVjZmI3NDU0Njk3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLT1NBS0kgTW90b2hpcm8gPGtvc2FraS5tb3RvaGlyb0BqcC5m
dWppdHN1LmNvbT4KRGF0ZTogTW9uLCAxNSBGZWIgMjA0NCAwMToxNzowOSArMDkwMApTdWJqZWN0
OiBbUEFUQ0hdIGRvX3RyeV90b19mcmVlX3BhZ2VzKCkgb29tX2tpbGxlcl9kaXNhYmxlZAoKU2ln
bmVkLW9mZi1ieTogS09TQUtJIE1vdG9oaXJvIDxrb3Nha2kubW90b2hpcm9AanAuZnVqaXRzdS5j
b20+Ci0tLQogbW0vdm1zY2FuLmMgfCAgICAzICsrLQogMSBmaWxlcyBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbW0vdm1zY2FuLmMgYi9tbS92
bXNjYW4uYwppbmRleCBiZTEzM2FjLi42OTgxMGFlIDEwMDY0NAotLS0gYS9tbS92bXNjYW4uYwor
KysgYi9tbS92bXNjYW4uYwpAQCAtNDAsNiArNDAsNyBAQAogI2luY2x1ZGUgPGxpbnV4L21lbWNv
bnRyb2wuaD4KICNpbmNsdWRlIDxsaW51eC9kZWxheWFjY3QuaD4KICNpbmNsdWRlIDxsaW51eC9z
eXNjdGwuaD4KKyNpbmNsdWRlIDxsaW51eC9vb20uaD4KIAogI2luY2x1ZGUgPGFzbS90bGJmbHVz
aC5oPgogI2luY2x1ZGUgPGFzbS9kaXY2NC5oPgpAQCAtMTkzMSw3ICsxOTMyLDcgQEAgb3V0Ogog
CQlyZXR1cm4gc2MtPm5yX3JlY2xhaW1lZDsKIAogCS8qIHRvcCBwcmlvcml0eSBzaHJpbmtfem9u
ZXMgc3RpbGwgaGFkIG1vcmUgdG8gZG8/IGRvbid0IE9PTSwgdGhlbiAqLwotCWlmIChzY2Fubmlu
Z19nbG9iYWxfbHJ1KHNjKSAmJiAhYWxsX3VucmVjbGFpbWFibGUpCisJaWYgKHNjYW5uaW5nX2ds
b2JhbF9scnUoc2MpICYmICFhbGxfdW5yZWNsYWltYWJsZSAmJiAhb29tX2tpbGxlcl9kaXNhYmxl
ZCkKIAkJcmV0dXJuIDE7CiAKIAlyZXR1cm4gMDsKLS0gCjEuNi41LjIKCg==
--------_4C7CA6CE000000008B98_MULTIPART_MIXED_--


