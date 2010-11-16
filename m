Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126Ab0KPKCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:02:47 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35000 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab0KPKCq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:02:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oB8T17EdkQv1MaIeb46uKmxeVQw1v0H3Vu8PCf2391uBPZX9HIYr17H8+bVS0m1Cjb
         cYffgrPQK15tXTQk9yWmsQ6o3CIiN/pEaCYPCl6Wy0rgZkfiHhiUP7XYa/QNCLretzgO
         gprd74wkEmnbwCAbn+CPLcnoL9uFC0UAqfDtU=
MIME-Version: 1.0
In-Reply-To: <20101116095938.GA12891@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<1289584840-18097-3-git-send-email-catalin.marinas@arm.com>
	<20101115233129.GG31421@n2100.arm.linux.org.uk>
	<AANLkTikrz+yM6idm-aij10vsKZMVSOBfZSdeEJbDRwiC@mail.gmail.com>
	<20101116095938.GA12891@n2100.arm.linux.org.uk>
Date: Tue, 16 Nov 2010 10:02:44 +0000
X-Google-Sender-Auth: 70pcf23TL9KFaDAH8wosO2audHk
Message-ID: <AANLkTikXtb2KsoW72DKkJ4ER5E=HNtfC9CGUhLWGfvwK@mail.gmail.com>
Subject: Re: [PATCH v2 02/20] ARM: LPAE: Factor out 2-level page table
 definitions into separate files
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2010 09:59, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 16, 2010 at 09:14:52AM +0000, Catalin Marinas wrote:
>> On 15 November 2010 23:31, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > This should become:
>> >
>> > typedef struct { pteval_t pte; } pte_t;
>> >
>> > L_PTE_* can then be declared using linux/const.h stuff to typedef them
>> > to pteval_t.
>>
>> I already do this for LPAE but can be done for the 2-level definitions
>> for consistency.
>
> No you don't.  You define the 2nd level definitions using pmd_t which
> is _wrong_.  pmd_t is the type of the pmd container, not the pmd value.

I was only referring to L_PTE_*. The PMD_* definitions are wrong indeed.

-- 
Catalin
