Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069Ab0KPJTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:19:25 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58921 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934022Ab0KPJTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:19:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gnXqE5T9SfXTplPa32NpcHp/2ufTTtX7H68Q/cLO1RJrQL3Uezavv5EUfHwRFEs9nB
         XRQynWMUG50q246SqbOhg8Lb5kgduxCs1DZMSj0NS4JqV2ZfnDZ0TLXDSHVoQpYmukLq
         o1SAPBZjWQHe7BZrzE87cNMHdJkaXdx/LVr/A=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1011151707310.6448@xanadu.home>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<20101114151445.GB10871@n2100.arm.linux.org.uk>
	<AANLkTinuUCYMa8e7=ehhExFzBAhPZBKA16M1GVQ=RMMH@mail.gmail.com>
	<201011151047.37103.arnd@arndb.de>
	<AANLkTi=FFpCwEhSgs-zOh32JQvqQWqnaQVTitwJeDyzj@mail.gmail.com>
	<alpine.LFD.2.00.1011151707310.6448@xanadu.home>
Date: Tue, 16 Nov 2010 09:19:22 +0000
X-Google-Sender-Auth: W8ReQ1uYlXW-d52eQPXM7QvGdhk
Message-ID: <AANLkTikJvcpECTpRU-JA2YX8QFYPHV7PMkN5w49ji2TH@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] ARM: LPAE: use u32 instead of unsigned long for
 32-bit ptes
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2010 22:11, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Mon, 15 Nov 2010, Catalin Marinas wrote:
>
>> On 15 November 2010 09:47, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Monday 15 November 2010 10:39:30 Catalin Marinas wrote:
>> >> > There will be compiler warnings because u32 is unsigned int, and we
>> >> > print it as %08lx.  Generic code cases pte values to (long long) and
>> >> > prints them using %08llx.  We should do the same.
>> >>
>> >> We still need some kind of macro because with LPAE we need %016llx
>> >> since the phys address can go to 40-bit and there are some additional
>> >> bits in the top word. Unless you'd like to always print 16 characters
>> >> even for 32-bit ptes (or if there is some other printk magic I'm not
>> >> aware of).
>> >
>> > Why not just %010llx? That would just be two extra characters.
>>
>> We still have attributes (like XN, bit 54) stored in the top part of
>> the pte. This may be of interest when debugging.
>
> They will be printed if they exist. The %010 in front of llx only means
> to have a minimum of 10 zero-paded digits if the value is smaller than
> that.
>
> However, not having aligned values will be confusing.  A macro for the
> format might be the best compromize.

We thought about using something like

printk("%0*llx", sizeof(pteval_t) * 2, (long long)pte_val(pte));

but it complicates the code.

Anyway, since these are printed for debugging mainline, we can
probably cope with some lack of alignment (as Russell said, there may
not be any where it matters).

-- 
Catalin
