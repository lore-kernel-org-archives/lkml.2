Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab0EAXZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 19:25:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33842 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab0EAXZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 19:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kUMJ4BmtkXpHGI7haQD2UP80+2JH7oZh8HN0ZQKAtvgTL219T4TtpuLu79o1XLOhr1
         q5/179Qu73OJTpUlh/HsgLb3E/Vg2wfEAu7TfpMjZ831rcD8C9orpBfn+QQXqG8hsh6C
         zSZOPb1fhdrDv9P/Hoo7r1NhoeMn0fY0B3QQA=
MIME-Version: 1.0
In-Reply-To: <20100501224429.GA17693@n2100.arm.linux.org.uk>
References: <1270681920-4461-1-git-send-email-linus.walleij@stericsson.com>
	 <v2se9c3a7c21004071645u8180f4d7p3b4b1f96de11303e@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A03A50F78@EXDCVYMBSTM006.EQ1STM.local>
	 <t2qe9c3a7c21004141815x70ecf123p4364802681417da9@mail.gmail.com>
	 <q2o63386a3d1004162158v296379fat2b376d5c4c087378@mail.gmail.com>
	 <20100422110025.GC20008@n2100.arm.linux.org.uk>
	 <g2qe9c3a7c21005011500l11511d43i12d971775b139c3b@mail.gmail.com>
	 <20100501224429.GA17693@n2100.arm.linux.org.uk>
Date: Sat, 1 May 2010 16:25:52 -0700
X-Google-Sender-Auth: 71da49ad79b97688
Message-ID: <h2ue9c3a7c21005011625u4a523dbbs5bdc6869a0bcc71@mail.gmail.com>
Subject: Re: [PATCH 00/11] ARM: PrimeCell DMA Interface v5
From: Dan Williams <dan.j.williams@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 1, 2010 at 3:44 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, May 01, 2010 at 03:00:09PM -0700, Dan Williams wrote:
>> Just to clarify are you nak'ing these patches for upstream inclusion
>> until this testing occurs?  Or do we just need a !ARCH_VERSATILE
>> somewhere to allow any incompatibilities to be worked out later
>> in-tree?
>
> What I don't want to do is to get into the situation where we throw
> this patchset into the kernel and then find that we have to invent a
> whole new implementation in the various primecell drivers to support
> the Versatile hardware.
>
> Versatile has some MUXing on three of the DMA signals, so (eg) we
> really don't want UARTs claiming DMAs just because they're in existence
> and not in use - that would prevent DMAs from being used for (eg) AACI
> or MMC.
>
> The alternative is that we could just take the attitude that Versatile/
> Realview will never have DMA support implemented, but that seems rather
> silly, as they've tended to be the first platforms I get new CPU
> architectures for.  (This is why DMA coherency stuff on new architectures
> tends to be left for others to do...)

Ok, it will be good to have this approach vetted on a challenging
arch.  We'll see where things stand when the merge window opens.

--
Dan
