Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1INI4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:56:20 -0400
Received: from mail.ss.pku.edu.cn ([211.101.48.138]:54109 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab1INI4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:56:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1109111837200.19558@p34.internal.lan>
References: <alpine.DEB.2.02.1109111815520.19558@p34.internal.lan>
	<alpine.DEB.2.02.1109111837200.19558@p34.internal.lan>
Date: Wed, 14 Sep 2011 16:56:15 +0800
Message-ID: <CAF1ivSZQ=KKC0gAk93eMVwLSCbeEWr=k6YszuE=sb1+Ue521vw@mail.gmail.com>
Subject: Re: 3.0.1: pagevec_lookup+0x1d/0x30, SLAB issues?
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "Li, Shaohua" <shaohua.li@intel.com>, Andrew Morton <akpm@google.com>
Content-Type: multipart/mixed; boundary=0016363b965ec8902604ace2eeef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016363b965ec8902604ace2eeef
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 12, 2011 at 6:44 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wr=
ote:
>
>
> On Sun, 11 Sep 2011, Justin Piszcz wrote:
>
>> Hi,
>>
>> With 3.0.1 now and all options compiled in and threadirqs removed, I get
>> the same error this user is seeing:
>> http://www.gossamer-threads.com/lists/linux/kernel/1424997
>>
>
> Hello Lin,
>
> I missed your mail (sender IP is in a CIDR blacklist), disabled &
> whitelisted for now:
> http://marc.info/?l=3Dlinux-kernel&m=3D131567477126674&w=3D2
>
> I've enabled this and I will post a new e-mail / output if it happens
> again with debug enabled for SLAB.
>
> Response to your e-mail:
>
>> Could you tell how to reproduce this?
>
> Running a lot of processes at the same time (memory/cpu+i/o)
>
>> And would you please turn on more debug options to capture more info?
>
> Yup, done now; however, I am using SLAB, not SLUB; so I've enabled:
>
> -> [*] Debug slab memory allocations -> [*] =A0 Memory leak debugging -> =
[*]
> Debug VM
>
>> CONFIG_SLUB_DEBUG=3Dy
>> CONFIG_SLUB_DEBUG_ON=3Dy
>> CONFIG_DEBUG_VM=3Dy
>
> Please let me know if there are any other options you think would be usef=
ul
> to enable or if this should be good, if it recurs again-- as noted above
> I will post an update.

Hi, Justin

There is a similar bug report at:
http://marc.info/?t=3D131594190600005&r=3D1&w=3D2

The attached patch from Shaohua fixed the bug.

Could you have a try it?

Lin Ming

--0016363b965ec8902604ace2eeef
Content-Type: text/x-patch; charset=US-ASCII; name="filemap-dbg.patch"
Content-Disposition: attachment; filename="filemap-dbg.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsk2ryfp0

ZGlmZiAtLWdpdCBhL21tL2ZpbGVtYXAuYyBiL21tL2ZpbGVtYXAuYwppbmRleCA2NDVhMDgwLi5m
MTc3ZTk2IDEwMDY0NAotLS0gYS9tbS9maWxlbWFwLmMKKysrIGIvbW0vZmlsZW1hcC5jCkBAIC04
MjcsMTMgKzgyNywxNCBAQCB1bnNpZ25lZCBmaW5kX2dldF9wYWdlcyhzdHJ1Y3QgYWRkcmVzc19z
cGFjZSAqbWFwcGluZywgcGdvZmZfdCBzdGFydCwKIHsKIAl1bnNpZ25lZCBpbnQgaTsKIAl1bnNp
Z25lZCBpbnQgcmV0OwotCXVuc2lnbmVkIGludCBucl9mb3VuZDsKKwl1bnNpZ25lZCBpbnQgbnJf
Zm91bmQsIG5yX3NraXA7CiAKIAlyY3VfcmVhZF9sb2NrKCk7CiByZXN0YXJ0OgogCW5yX2ZvdW5k
ID0gcmFkaXhfdHJlZV9nYW5nX2xvb2t1cF9zbG90KCZtYXBwaW5nLT5wYWdlX3RyZWUsCiAJCQkJ
KHZvaWQgKioqKXBhZ2VzLCBOVUxMLCBzdGFydCwgbnJfcGFnZXMpOwogCXJldCA9IDA7CisJbnJf
c2tpcCA9IDA7CiAJZm9yIChpID0gMDsgaSA8IG5yX2ZvdW5kOyBpKyspIHsKIAkJc3RydWN0IHBh
Z2UgKnBhZ2U7CiByZXBlYXQ6CkBAIC04NTYsNiArODU3LDcgQEAgcmVwZWF0OgogCQkJICogaGVy
ZSBhcyBhbiBleGNlcHRpb25hbCBlbnRyeTogc28gc2tpcCBvdmVyIGl0IC0KIAkJCSAqIHdlIG9u
bHkgcmVhY2ggdGhpcyBmcm9tIGludmFsaWRhdGVfbWFwcGluZ19wYWdlcygpLgogCQkJICovCisJ
CQlucl9za2lwKys7CiAJCQljb250aW51ZTsKIAkJfQogCkBAIC04NzYsNyArODc4LDcgQEAgcmVw
ZWF0OgogCSAqIElmIGFsbCBlbnRyaWVzIHdlcmUgcmVtb3ZlZCBiZWZvcmUgd2UgY291bGQgc2Vj
dXJlIHRoZW0sCiAJICogdHJ5IGFnYWluLCBiZWNhdXNlIGNhbGxlcnMgc3RvcCB0cnlpbmcgb25j
ZSAwIGlzIHJldHVybmVkLgogCSAqLwotCWlmICh1bmxpa2VseSghcmV0ICYmIG5yX2ZvdW5kKSkK
KwlpZiAodW5saWtlbHkoIXJldCAmJiBucl9mb3VuZCAmJiAobnJfZm91bmQgIT0gbnJfc2tpcCkp
KQogCQlnb3RvIHJlc3RhcnQ7CiAJcmN1X3JlYWRfdW5sb2NrKCk7CiAJcmV0dXJuIHJldDsK
--0016363b965ec8902604ace2eeef--
