Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481Ab1ESQQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:16:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40299 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732Ab1ESQQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=LPXkmY5Vlf1THONKBpm+bKHK9jfpuhci8307XZWe0rboND6nxnJDGK2nBfD+svj8qg
         HlLMG/6IvHFrHB5MYKFdpqMxuSKOomRzYiebtdYKZKzdmpL/67iWNH6m1x7Fge06IaKs
         mjWDCJj8JizFkbJnDWm4NMUV7sbxutgspJ+Xc=
MIME-Version: 1.0
In-Reply-To: <4DD53AE5.8020103@teksavvy.com>
References: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com>
	<4DD53AE5.8020103@teksavvy.com>
Date: Thu, 19 May 2011 17:16:32 +0100
X-Google-Sender-Auth: sYlMqIp5jU5s3nzk2LNxwK4uLkA
Message-ID: <BANLkTi=7v40xpM6-jQ2CS09fEb0noFLYPg@mail.gmail.com>
Subject: Re: Linux 2.6.39
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 May 2011 16:44, Mark Lord <kernel@teksavvy.com> wrote:
> Here's some more funny business that was new after rc7-git12:
>
> warning: (AX88796_93CX6 && RTL8180 && RTL8187 && ADM8211 && RT2400PCI &&
> RT2500PCI && RT61PCI && RT2800PCI && R8187SE) selects EEPROM_93CX6 which has
> unmet direct dependencies (MISC_DEVICES)
> warning: (ACPI_APEI) selects PSTORE which has unmet direct dependencies
> (MISC_FILESYSTEMS)
>
> The exact same .config didn't do that with rc7-git12,
> but does do it with 2.6.39 final.
>
> Odd thing is, if I select both MISC_DEVICES and MISC_FILESYSTEMS,
> but do NOT select anything from under either of those,
> the warnings go away.
>
> Which likely means the warnings are totally bogus.

The problem is:

AX88796_93CX6 selects EEPROM_93CX6
EEPROM_93CX6 depends on MISC_DEVICES (as part of the EEPROM menu which
is only included if MISC_DEVICES)

By enabling MISC_DEVICES, you allow AX88796_93CX6 to select
EEPROM_93CX6 without any warning as it has the dependencies met.

The issue here is that EEPROM_93CX6 doesn't really depend on any
MISC_DEVICES infrastructure. That's just a directory for various
drivers and MISC_DEVICES only has a visibility role. There was a
proposal last year for kbuild to differentiate between dependency and
visibility but I don't know what happened to it.

-- 
Catalin
