Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab0KOJvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:51:04 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45147 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab0KOJvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:51:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U7hykvZ6WYejTrkOeggUi5C4Qc0ZHR5ch0qo+6QMwlfIF48pzEfDO7eOQ6MdgpgbCp
         3Qa2xTMzRrbbPerDGkbYOkqPc4/DNHZCIaqruPz7DoFKyvUYVIXhKcUe/Ih764OU/gZW
         51R6fCu8o+1Hjxol6kAJDvmYYq07US7rAY+7I=
MIME-Version: 1.0
In-Reply-To: <201011151047.37103.arnd@arndb.de>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<20101114151445.GB10871@n2100.arm.linux.org.uk>
	<AANLkTinuUCYMa8e7=ehhExFzBAhPZBKA16M1GVQ=RMMH@mail.gmail.com>
	<201011151047.37103.arnd@arndb.de>
Date: Mon, 15 Nov 2010 09:51:01 +0000
X-Google-Sender-Auth: xgOtkkWD7BN3ROFIHJcwaLokxF0
Message-ID: <AANLkTi=FFpCwEhSgs-zOh32JQvqQWqnaQVTitwJeDyzj@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] ARM: LPAE: use u32 instead of unsigned long for
 32-bit ptes
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2010 09:47, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 15 November 2010 10:39:30 Catalin Marinas wrote:
>> > There will be compiler warnings because u32 is unsigned int, and we
>> > print it as %08lx.  Generic code cases pte values to (long long) and
>> > prints them using %08llx.  We should do the same.
>>
>> We still need some kind of macro because with LPAE we need %016llx
>> since the phys address can go to 40-bit and there are some additional
>> bits in the top word. Unless you'd like to always print 16 characters
>> even for 32-bit ptes (or if there is some other printk magic I'm not
>> aware of).
>
> Why not just %010llx? That would just be two extra characters.

We still have attributes (like XN, bit 54) stored in the top part of
the pte. This may be of interest when debugging.

-- 
Catalin
