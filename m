Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0KOJjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:39:32 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33449 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0KOJjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:39:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rbeWC2ZcSFFzAb9VAB83cjU8x4kCvWO0CrbiTcNYuTFmkvpoWp0MZUNi8CsaxzOKMD
         0b0jlwC5lthSKDXlwplmp+aecAQ73UC6VZ+yUldzn+3sP9W/KB8fotGxHUe/3i9QJOHT
         HRfbkU0yxt7ddu+E46RYirxghwltAhkATxvTc=
MIME-Version: 1.0
In-Reply-To: <20101114151445.GB10871@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<1289584840-18097-4-git-send-email-catalin.marinas@arm.com>
	<20101114131941.GA10871@n2100.arm.linux.org.uk>
	<AANLkTimtSUNrO0wZBfyJJ+OJQCDLkXSOiUuzOD+ubv6O@mail.gmail.com>
	<AANLkTi=U+5uqLRSt9ObFdgTUc-v_+2Y3Qz90FG5aRTyb@mail.gmail.com>
	<20101114151445.GB10871@n2100.arm.linux.org.uk>
Date: Mon, 15 Nov 2010 09:39:30 +0000
X-Google-Sender-Auth: LKkFFCwgdE03prso9FgsHwZhhK4
Message-ID: <AANLkTinuUCYMa8e7=ehhExFzBAhPZBKA16M1GVQ=RMMH@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] ARM: LPAE: use u32 instead of unsigned long for
 32-bit ptes
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2010 15:14, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Nov 14, 2010 at 02:13:23PM +0000, Catalin Marinas wrote:
>> On Sunday, November 14, 2010, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> > On Sunday, November 14, 2010, Russell King - ARM Linux
>> > <linux@arm.linux.org.uk> wrote:
>> >> On Fri, Nov 12, 2010 at 06:00:23PM +0000, Catalin Marinas wrote:
>> >>> From: Will Deacon <will.deacon@arm.com>
>> >>>
>> >>> When using 2-level paging, pte_t and pmd_t are typedefs for
>> >>> unsigned long but phys_addr_t is a typedef for u32.
>> >>>
>> >>> This patch uses u32 for the page table entry types when
>> >>> phys_addr_t is not 64-bit, allowing the same conversion
>> >>> specifier to be used for physical addresses and page table
>> >>> entries regardless of LPAE.
>> >>
>> >> However, code which prints the value of page table entries assumes that
>> >> they are unsigned long, and places where we store the raw pte value also
>> >> uses 'unsigned long'.
>> >>
>> >> If we're going to make this change, we need to change more places than
>> >> this patch covers.  grep for pte_val to help find those places.
>> >
>> > Patch 19/20 introduces a common macro for formatting but we should
>> > probably order the patches a bit to avoid problems if anyone is
>> > bisecting  in the middle of the series.
>>
>> Actually not a problem since LPAE is only enabled by the last patch.
>> There may be some compiler warnings without 19/20, I need to check.
>
> There will be compiler warnings because u32 is unsigned int, and we
> print it as %08lx.  Generic code cases pte values to (long long) and
> prints them using %08llx.  We should do the same.

We still need some kind of macro because with LPAE we need %016llx
since the phys address can go to 40-bit and there are some additional
bits in the top word. Unless you'd like to always print 16 characters
even for 32-bit ptes (or if there is some other printk magic I'm not
aware of).

> In any case, this patch on its own introduces new compiler warnings.
> These need to be fixed in this patch, rather than relying on one later
> in the series.

Yes, we'll look into this.

-- 
Catalin
