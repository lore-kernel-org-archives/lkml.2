Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab0JUVaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:30:52 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37935 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238Ab0JUVau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:30:50 -0400
Message-Id: <1287696649.20421.1401306095@webmail.messagingengine.com>
X-Sasl-Enc: 9e1p5wtFHG/pAXifACOcLEIKLGgrFBNWmIEgcE2sOzBo 1287696649
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>, mingo@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Jan Beulich" <jbeulich@novell.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_1287696649204210"
X-Mailer: MessagingEngine.com Webmail Interface
References: <4CBDBEBA020000780001E05A@vpn.id2.novell.com><tip-3234282f33b29d349bcada40204fc7c8fda7fe72@git.kernel.org>
 <20101021101605.GA21465@elte.hu>
Subject: Re: [tip:x86/debug] x86, asm: Fix CFI macro invocations to deal with
 shortcomings in gas
In-Reply-To: <20101021101605.GA21465@elte.hu>
Date: Thu, 21 Oct 2010 23:30:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--_----------=_1287696649204210
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 17:30:49 -0400
X-Mailer: MessagingEngine.com Webmail Interface

On Thu, 21 Oct 2010 12:16 +0200, "Ingo Molnar" <mingo@elte.hu> wrote:
>=20
> * tip-bot for Jan Beulich <JBeulich@novell.com> wrote:
>=20
> > Commit-ID:  3234282f33b29d349bcada40204fc7c8fda7fe72
> > Gitweb:     http://git.kernel.org/tip/3234282f33b29d349bcada40204fc7c8f=
da7fe72
> > Author:     Jan Beulich <JBeulich@novell.com>
> > AuthorDate: Tue, 19 Oct 2010 14:52:26 +0100
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Tue, 19 Oct 2010 14:28:02 -0700
> >=20
> > x86, asm: Fix CFI macro invocations to deal with shortcomings in gas
>=20
> This commit broke the UML build (see the full error log below).
>=20
> 	Ingo
>=20
> /home/mingo/tip/arch/um/os-Linux/irq.c: In function
> =E2=80=98os_waiting_for_events=E2=80=99:
> /home/mingo/tip/arch/um/os-Linux/irq.c:35: error: expected =E2=80=98)=E2=
=80=99 before
> string constant
> /home/mingo/tip/arch/um/os-Linux/irq.c: In function =E2=80=98os_free_irq_=
by_cb=E2=80=99:
> /home/mingo/tip/arch/um/os-Linux/irq.c:94: error: expected =E2=80=98)=E2=
=80=99 before
> string constant

Hi all,

It turns out to generate something like this:
    printk ( ("<3>") "something");
The extra parentheses here break the compile.

Change the sed-program to add the parentheses only for numbers.

Greetings,
    Alexander

--_----------=_1287696649204210
MIME-Version: 1.0
Content-Disposition: attachment; filename="sedpatch.patch"
Content-Id: <P+dVp0nCtZfvrmpabmSP+wcE1ng@messagingengine.com>
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="sedpatch.patch"
X-Mailer: MIME::Lite 3.021 (F2.76; T1.24; A2.03; B3.07_01; Q3.07)
Date: Thu, 21 Oct 2010 17:30:49 -0400

Rml4IGZvciAieDg2LCBhc206IEZpeCBDRkkgbWFjcm8gaW52b2NhdGlvbnMg
dG8gZGVhbCB3aXRoIHNob3J0Y29taW5ncyBpbiBnYXMiCgpJdCB0dXJucyBv
dXQgdG8gZ2VuZXJhdGUgc29tZXRoaW5nIGxpa2UgdGhpczoKICAgIHByaW50
ayAoICgiPDM+IikgInNvbWV0aGluZyIpOwpUaGUgZXh0cmEgcGFyZW50aGVz
ZXMgaGVyZSBicmVhayB0aGUgY29tcGlsZS4KCkNoYW5nZSB0aGUgc2VkLXBy
b2dyYW0gdG8gYWRkIHRoZSBwYXJlbnRoZXNlcyBvbmx5IGZvciBudW1iZXJz
LgoKClNpZ25lZC1vZmYtYnk6IEFsZXhhbmRlciB2YW4gSGV1a2VsdW0gPGhl
dWtlbHVtQGZhc3RtYWlsLmZtPgoKZGlmZiAtLWdpdCBhL0tidWlsZCBiL0ti
dWlsZAppbmRleCAzOTk1OTM5Li40MzFmN2NhIDEwMDY0NAotLS0gYS9LYnVp
bGQKKysrIGIvS2J1aWxkCkBAIC01Myw3ICs1Myw4IEBAIHRhcmdldHMgKz0g
YXJjaC8kKFNSQ0FSQ0gpL2tlcm5lbC9hc20tb2Zmc2V0cy5zCiAjIERlZmF1
bHQgc2VkIHJlZ2V4cCAtIG11bHRpbGluZSBkdWUgdG8gc3ludGF4IGNvbnN0
cmFpbnRzCiBkZWZpbmUgc2VkLXkKIAkiL14tPi97czotPiNcKC4qXCk6Lyog
XDEgKi86OyBcCi0JczpeLT5cKFteIF0qXCkgW1wkJCNdKlwoW14gXSpcKSBc
KC4qXCk6I2RlZmluZSBcMSAoXDIpIC8qIFwzICovOjsgXAorCXM6Xi0+XChb
XiBdKlwpIFtcJCQjXSpcKFstMC05XSpcKSBcKC4qXCk6I2RlZmluZSBcMSAo
XDIpIC8qIFwzICovOjsgXAorCXM6Xi0+XChbXiBdKlwpIFtcJCQjXSpcKFte
IF0qXCkgXCguKlwpOiNkZWZpbmUgXDEgXDIgLyogXDMgKi86OyBcCiAJczot
Pjo6OyBwO30iCiBlbmRlZgogCg==

--_----------=_1287696649204210--

