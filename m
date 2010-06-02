Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab0FBUbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:31:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37338 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab0FBUba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QP/7rnmIzPq7fQVX323AuQzeKns4k9McdjgFGGmSrbnCkXsHNZjZJHHssGBNk0oCQr
         c3NxZd45WvggrMZxZcFYtXjLMfuSboYEE51Zbnf0IEQwIp8vTzYytSPQ/7QZUVvBNmUg
         VgMsvk/F9t3zy41DG1/2Cd8CDIO6rQZ21EF2k=
MIME-Version: 1.0
In-Reply-To: <1275473482.11579.21.camel@maxim-laptop>
References: <1275473482.11579.21.camel@maxim-laptop>
Date: Wed, 2 Jun 2010 13:31:29 -0700
X-Google-Sender-Auth: k3nqrqTW3Tq2kZgQny-rTU8v-a8
Message-ID: <AANLkTinc-SoQsbW0uX08ZMypN6_l5uwSVbavnozFE__W@mail.gmail.com>
Subject: Re: How to tell kernel that a region of memory is reserved (in middle 
	of ram)?
From: Yinghai Lu <yinghai@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 3:11 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Hi,
>
> I need to reserve a region of ram to store there a ramoops buffer.
> I need to do so early so kernel doesn't overwrite the existing contents.
>
> How to do it?
>
> I noticed that doing memmap=20M$0x70000000 crashes the system although
> it promised to work.
> Is that a bug?
>
> I have 2GB system with following memory map:
>
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000007fcfd000 (usable)
> [    0.000000]  BIOS-e820: 000000007fcfd000 - 000000007fd08000 (reserved)
> [    0.000000]  BIOS-e820: 000000007fd08000 - 000000007fd52000 (usable)
> [    0.000000]  BIOS-e820: 000000007fd52000 - 000000007fd55000 (reserved)
> [    0.000000]  BIOS-e820: 000000007fd55000 - 000000007fdbb000 (usable)
> [    0.000000]  BIOS-e820: 000000007fdbb000 - 000000007fdbf000 (reserved)
> [    0.000000]  BIOS-e820: 000000007fdbf000 - 000000007fe70000 (usable)
> [    0.000000]  BIOS-e820: 000000007fe70000 - 000000007febf000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000007febf000 - 000000007ff00000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
>

kernel version?

you could boot with "debug earlyprintk=ttyS0,115200" to get more info.

YH
