Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1LSLFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:05:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34679 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1LSLF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:05:28 -0500
MIME-Version: 1.0
In-Reply-To: <4EEB8704.8030201@freescale.com>
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
	<1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
	<4EDEAEB9.6020703@freescale.com>
	<1323724195.2297.11.camel@koala>
	<4EE66EFE.1050608@freescale.com>
	<1323724784.2297.20.camel@koala>
	<4EE6725C.3050706@freescale.com>
	<4EE6BC9B.4000602@freescale.com>
	<4EE8612C.9050104@freescale.com>
	<4EE903CE.1010903@freescale.com>
	<4EEAB076.30000@freescale.com>
	<4EEB8704.8030201@freescale.com>
Date: Mon, 19 Dec 2011 19:05:26 +0800
X-Google-Sender-Auth: FVKR4NrmuzqpjEVIQi7B-VS-6bQ
Message-ID: <CADRPPNT-akj5KBQKdRaFrA2XpLU6-xtuRduzDYEWjv_dzVmTAA@mail.gmail.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
From: Li Yang <leoli@freescale.com>
To: Scott Wood <scottwood@freescale.com>
Cc: LiuShuo <b35362@freescale.com>, dedekind1@gmail.com,
        shuo.liu@freescale.com, dwmw2@infradead.org,
        Artem.Bityutskiy@nokia.com, linux-mtd@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 1:59 AM, Scott Wood <scottwood@freescale.com> wrote:
> On 12/15/2011 08:44 PM, LiuShuo wrote:
>> hi Artem,
>> Could this patch be applied now and we make a independent patch for  bad
>> block information
>> migration later?
>
> This patch is not safe to use without migration.

Hi Scott,

We agree it's not entirely safe without migrating the bad block flag.
But let's consider two sides of the situation.

Firstly, it's only unsafe when there is a need to re-built the Bad
Block Table from scratch(old BBT broken).  But currently there is no
easy way to do that(re-build BBT on demand), which means it's not a
common problem that we can easily address now.

Secondly, even if the previous said problem happens(BBT broken).  We
can still recover all the data if we overrule the bad block flag.
Only the card is not so good to be used again, however, it can be used
if we take the risk of losing data from errors that ECC can't
notice(low possibility too).

Finally, I don't think this is a blocker issue but a better to have enhancement.

- Leo
