Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1HHVhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:37:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61696 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1HHVhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:37:54 -0400
MIME-Version: 1.0
In-Reply-To: <1312826703.5589.155.camel@localhost.localdomain>
References: <1312826703.5589.155.camel@localhost.localdomain>
Date: Mon, 8 Aug 2011 14:37:53 -0700
X-Google-Sender-Auth: WtUUIPKyUatAOu0HyqfI5iQswUQ
Message-ID: <CA+8MBbJDLrNHD0kGdYNv1WPnRh8G1aEY-T3xcS_wMpciTVcy7A@mail.gmail.com>
Subject: Re: Missing put_cpu() in arch/ia64/sn/kernel/sn2/sn_hwperf.c?
From: Tony Luck <tony.luck@intel.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jes.Sorensen@redhat.com, Julia Lawall <julia@diku.dk>
Content-Type: multipart/mixed; boundary=20cf301d3d1e74312604aa0542ac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf301d3d1e74312604aa0542ac
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Aug 8, 2011 at 11:05 AM, Thomas Meyer <thomas@m3y3r.de> wrote:
> The function sn_hwperf_op_cpu() seems to miss a corresponding put_cpu().
>
> Or is this done in another function? I didn't find it.

It would be hard to do it elsewhere - this function may not have done
a get_cpu() [in the cpu == SN_HWPERF_ARG_ANY_CPU case].

The logic is a bit tortuous here ... perhaps simpler to split the tests
up.  Does the attached patch look right?

-Tony

--20cf301d3d1e74312604aa0542ac
Content-Type: text/x-patch; charset=US-ASCII; name="sn_hwperf_op_cpu.patch"
Content-Disposition: attachment; filename="sn_hwperf_op_cpu.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gr3ykrv70

ZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9zbi9rZXJuZWwvc24yL3NuX2h3cGVyZi5jIGIvYXJjaC9p
YTY0L3NuL2tlcm5lbC9zbjIvc25faHdwZXJmLmMKaW5kZXggMzA4NjJjMC4uMmRlNDFkNCAxMDA2
NDQKLS0tIGEvYXJjaC9pYTY0L3NuL2tlcm5lbC9zbjIvc25faHdwZXJmLmMKKysrIGIvYXJjaC9p
YTY0L3NuL2tlcm5lbC9zbjIvc25faHdwZXJmLmMKQEAgLTYxNSwxMSArNjE1LDE1IEBAIHN0YXRp
YyBpbnQgc25faHdwZXJmX29wX2NwdShzdHJ1Y3Qgc25faHdwZXJmX29wX2luZm8gKm9wX2luZm8p
CiAJCX0KIAl9CiAKLQlpZiAoY3B1ID09IFNOX0hXUEVSRl9BUkdfQU5ZX0NQVSB8fCBjcHUgPT0g
Z2V0X2NwdSgpKSB7Ci0JCS8qIGRvbid0IGNhcmUsIG9yIGFscmVhZHkgb24gY29ycmVjdCBjcHUg
Ki8KKwlpZiAoY3B1ID09IFNOX0hXUEVSRl9BUkdfQU5ZX0NQVSkgeworCQkvKiBkb24ndCBjYXJl
IHdoaWNoIGNwdSAqLwogCQlzbl9od3BlcmZfY2FsbF9zYWwob3BfaW5mbyk7Ci0JfQotCWVsc2Ug
eworCX0gZWxzZSBpZiAoY3B1ID09IGdldF9jcHUoKSkgeworCQkvKiBhbHJlYWR5IG9uIGNvcnJl
Y3QgY3B1ICovCisJCXNuX2h3cGVyZl9jYWxsX3NhbChvcF9pbmZvKTsKKwkJcHV0X2NwdSgpOwor
CX0gZWxzZSB7CisJCXB1dF9jcHUoKTsKIAkJaWYgKHVzZV9pcGkpIHsKIAkJCS8qIHVzZSBhbiBp
bnRlcnByb2Nlc3NvciBpbnRlcnJ1cHQgdG8gY2FsbCBTQUwgKi8KIAkJCXNtcF9jYWxsX2Z1bmN0
aW9uX3NpbmdsZShjcHUsIHNuX2h3cGVyZl9jYWxsX3NhbCwK
--20cf301d3d1e74312604aa0542ac--
