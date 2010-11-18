Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab0KRQDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:03:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129Ab0KRQDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:03:52 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Xoo90jiaQBMxchFkKXt0dgre0tWe-LnVR6aSD@mail.gmail.com>
References: <201011172159.oAHLx1tu001236@hera.kernel.org> <20101117140526.d532b373.randy.dunlap@oracle.com>
 <AANLkTimO6CN9wOQco_1bqRmwBS7KfWW1CvumKFuiOWGH@mail.gmail.com>
 <20101118094342.GA10382@elte.hu> <AANLkTi=Xoo90jiaQBMxchFkKXt0dgre0tWe-LnVR6aSD@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Nov 2010 08:02:58 -0800
Message-ID: <AANLkTikV+KVmwKg4jS2KPG+9EFdd9qD-VUak4qOgFgr4@mail.gmail.com>
Subject: Re: [build failure] Re: BKL: remove extraneous #include <smp_lock.h>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: multipart/mixed; boundary=0016e64ba1b4a3fff5049555edc8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64ba1b4a3fff5049555edc8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 18, 2010 at 7:57 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> How painful would it be to move lock_depth into thread_struct? I guess
> we don't have anything that cares about structure offsets in assembly
> for that thing. =A0I should just try.

Gaah, the only generic field there is the restart_block, so we'd have
to hide it there, or then add it to each architecture. So scratch
that.

I guess this is the simplest approach.

                         Linus

--0016e64ba1b4a3fff5049555edc8
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ggntxrbf0

IGluY2x1ZGUvbGludXgvaGFyZGlycS5oIHwgICAgMSArCiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2hh
cmRpcnEuaCBiL2luY2x1ZGUvbGludXgvaGFyZGlycS5oCmluZGV4IDcxNGRhN2UuLjMyZjlmZDYg
MTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvaGFyZGlycS5oCisrKyBiL2luY2x1ZGUvbGludXgv
aGFyZGlycS5oCkBAIC05NCw2ICs5NCw3IEBACiAjZGVmaW5lIGluX25taSgpCShwcmVlbXB0X2Nv
dW50KCkgJiBOTUlfTUFTSykKIAogI2lmIGRlZmluZWQoQ09ORklHX1BSRUVNUFQpICYmIGRlZmlu
ZWQoQ09ORklHX0JLTCkKKyMgaW5jbHVkZSA8bGludXgvc2NoZWQuaD4KICMgZGVmaW5lIFBSRUVN
UFRfSU5BVE9NSUNfQkFTRSAoY3VycmVudC0+bG9ja19kZXB0aCA+PSAwKQogI2Vsc2UKICMgZGVm
aW5lIFBSRUVNUFRfSU5BVE9NSUNfQkFTRSAwCg==
--0016e64ba1b4a3fff5049555edc8--
