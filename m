Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab2JYOdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:33:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51013 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450Ab2JYOde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:33:34 -0400
MIME-Version: 1.0
In-Reply-To: <20121025075508.GD3712@gmail.com>
References: <20121024195311.GB11779@jshin-Toonie>
	<tip-844ab6f993b1d32eb40512503d35ff6ad0c57030@git.kernel.org>
	<CAE9FiQX0MvxAsZKFwH50joR5qz1oGhbXz+BD9W-QC_BrD9zKFQ@mail.gmail.com>
	<20121025075508.GD3712@gmail.com>
Date: Thu, 25 Oct 2012 07:33:32 -0700
X-Google-Sender-Auth: VFahMsXX47m5FNpcdPGH0bN7eTE
Message-ID: <CAE9FiQW_vuaYQbmagVnxT2DGsYc=9tNeAbdBq53sYkitPOwxSQ@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, mm: Find_early_table_space based on ranges
 that are actually being mapped
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, jacob.shin@amd.com,
        tglx@linutronix.de, trini@ti.com, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd1d1246e24aa04cce316d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd1d1246e24aa04cce316d6
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Oct 25, 2012 at 12:55 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> > -               ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
>> > +                       /* The first 2/4M doesn't use large pages. */
>> > +                       if (mr[i].start < PMD_SIZE)
>> > +                               extra += range;
>>
>> those three lines should be added back.

missed "not" ...

>>
>> it just get reverted in 7b16bbf9
>
> Could you please send a delta patch against tip:x86/urgent?

please check attached one.

Thanks

Yinghai

--000e0cd1d1246e24aa04cce316d6
Content-Type: application/octet-stream; name="remove_wrong_addback.patch"
Content-Disposition: attachment; filename="remove_wrong_addback.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8pz1w3t0

U3ViamVjdDogW1BBVENIXSB4ODYsIG1tOiBSZW1vdmUgd3JvbmcgYWRkIGJhY2sKCmNvbW1pdCA4
NDRhYjZmOQogICAgeDg2LCBtbTogRmluZF9lYXJseV90YWJsZV9zcGFjZSBiYXNlZCBvbiByYW5n
ZXMgdGhhdCBhcmUgYWN0dWFsbHkgYmVpbmcgbWFwcGVkCmFkZCBiYWNrIHNvbWUgbGluZXMgYmFj
ayB3cm9uZ2x5IHRoYXQgaGFzIGJlZW4gcmV2ZXJ0ZWQgaW4gY29tbWl0IDdiMTZiYmY5NwogICAg
UmV2ZXJ0ICJ4ODYvbW06IEZpeCB0aGUgc2l6ZSBjYWxjdWxhdGlvbiBvZiBtYXBwaW5nIHRhYmxl
cyIKCnJlbW92ZSB0aGVtIGFnYWluLgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hh
aUBrZXJuZWwub3JnPgoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL2luaXQuYyBiL2FyY2gveDg2
L21tL2luaXQuYwppbmRleCBiYzI4N2Q2Li5kN2FlYTQxIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9t
bS9pbml0LmMKKysrIGIvYXJjaC94ODYvbW0vaW5pdC5jCkBAIC02NSwxMCArNjUsNiBAQCBzdGF0
aWMgdm9pZCBfX2luaXQgZmluZF9lYXJseV90YWJsZV9zcGFjZShzdHJ1Y3QgbWFwX3JhbmdlICpt
ciwgaW50IG5yX3JhbmdlKQogI2lmZGVmIENPTkZJR19YODZfMzIKIAkJCWV4dHJhICs9IFBNRF9T
SVpFOwogI2VuZGlmCi0JCQkvKiBUaGUgZmlyc3QgMi80TSBkb2Vzbid0IHVzZSBsYXJnZSBwYWdl
cy4gKi8KLQkJCWlmIChtcltpXS5zdGFydCA8IFBNRF9TSVpFKQotCQkJCWV4dHJhICs9IHJhbmdl
OwotCiAJCQlwdGVzICs9IChleHRyYSArIFBBR0VfU0laRSAtIDEpID4+IFBBR0VfU0hJRlQ7CiAJ
CX0gZWxzZSB7CiAJCQlwdGVzICs9IChyYW5nZSArIFBBR0VfU0laRSAtIDEpID4+IFBBR0VfU0hJ
RlQ7Cg==
--000e0cd1d1246e24aa04cce316d6--
