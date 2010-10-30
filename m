Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab0J3Czw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 22:55:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61860 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0J3Czu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 22:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=l1UrjCzrCEClFUMvaCWYY/s1nYsDzsJ1GUiNIAsudAk/b2uEoGwWimhjT2BoboI+Ay
         ne6kXC8cwG/rkOM6o39hgwGDecxVuLzQn/K7/nJtWghxI3LXuEjVlR/uqBoY3cMGspkS
         7v3FqjBJh1zyz933IcpbVKLMjL6gOEZVJXGQ8=
MIME-Version: 1.0
In-Reply-To: <20101030015050.GA9557@sgi.com>
References: <20101029222227.GJ32456@sgi.com>
	<1288399062.2690.169.camel@sbsiddha-MOBL3.sc.intel.com>
	<20101030015050.GA9557@sgi.com>
Date: Fri, 29 Oct 2010 19:55:49 -0700
X-Google-Sender-Auth: N1I4GclxrMWMd11CGuEulNmDp0E
Message-ID: <AANLkTi=Ct+NXV_pvPNbn+j-j=hHXmUxaqa=XEaga=+Pq@mail.gmail.com>
Subject: Re: [BUG] intr_remap: Simplify the code further
From: Yinghai Lu <yinghai@kernel.org>
To: Russ Anderson <rja@sgi.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, rja@americas.sgi.com
Content-Type: multipart/mixed; boundary=0015175cbac26170db0493ccb6f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015175cbac26170db0493ccb6f3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 29, 2010 at 6:50 PM, Russ Anderson <rja@sgi.com> wrote:
> On Fri, Oct 29, 2010 at 05:37:42PM -0700, Suresh Siddha wrote:
>> On Fri, 2010-10-29 at 15:22 -0700, Russ Anderson wrote:
>> > There is a regression that is causing a NULL pointer dereference
>> > in free_irte when shutting down xpc. =A0git bisect narrowed it down
>> > to git commit d585d060b42bd36f6f0b23ff327d3b91f80c7139, which
>> > changed free_irte(). =A0Reverse applying the patch fixes the problem.
>> >
>>
>> Russ, Is this with !CONFIG_SPARSE_IRQ?
>
>
> CONFIG_SPARSE_IRQ=3Dy
>

can you try attached patch?

Yinghai

--0015175cbac26170db0493ccb6f3
Content-Type: text/x-patch; charset=US-ASCII; name="fix_uv_free_irte.patch"
Content-Disposition: attachment; filename="fix_uv_free_irte.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gfvwfopn0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9hcGljL2lvX2FwaWMuYyBiL2FyY2gveDg2L2tl
cm5lbC9hcGljL2lvX2FwaWMuYwppbmRleCA1ZTQzNTAyLi4zODNmNGJiIDEwMDY0NAotLS0gYS9h
cmNoL3g4Ni9rZXJuZWwvYXBpYy9pb19hcGljLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2FwaWMv
aW9fYXBpYy5jCkBAIC0zMTA5LDcgKzMxMDksNyBAQCB2b2lkIGRlc3Ryb3lfaXJxKHVuc2lnbmVk
IGludCBpcnEpCiAKIAlpcnFfc2V0X3N0YXR1c19mbGFncyhpcnEsIElSUV9OT1JFUVVFU1R8SVJR
X05PUFJPQkUpOwogCi0JaWYgKGludHJfcmVtYXBwaW5nX2VuYWJsZWQpCisJaWYgKGlycV9yZW1h
cHBlZChnZXRfaXJxX2NoaXBfZGF0YShpcnEpKSkKIAkJZnJlZV9pcnRlKGlycSk7CiAJcmF3X3Nw
aW5fbG9ja19pcnFzYXZlKCZ2ZWN0b3JfbG9jaywgZmxhZ3MpOwogCV9fY2xlYXJfaXJxX3ZlY3Rv
cihpcnEsIGNmZyk7Cg==
--0015175cbac26170db0493ccb6f3--
