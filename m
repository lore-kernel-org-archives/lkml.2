Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1GXI70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 04:59:26 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:48421 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1GXI7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 04:59:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110723202032.67ebdbcc.rdunlap@xenotime.net>
References: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
	<20110723202032.67ebdbcc.rdunlap@xenotime.net>
Date: Sun, 24 Jul 2011 09:59:20 +0100
X-Google-Sender-Auth: yAAU4goAZ5XaefD_auiuhJzkkBA
Message-ID: <CAGq3pz6L5VzYaGBN8Py3x9s-orAp9AoG1OMM=1p8KJ1b3TVR6Q@mail.gmail.com>
Subject: Re: OLPC power management patches - merge for 3.1?
From: Daniel Drake <dsd@laptop.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>, tglx@linutronix.de,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 July 2011 04:20, Randy Dunlap <rdunlap@xenotime.net> wrote:
> I have no objection to merging OLPC patches, but they should build
> without errors.

Agreed! Thanks for reporting the issue.

> Looks like this problem is caused by:
>
> config OLPC_XO1_SCI
>        bool "OLPC XO-1 SCI extras"
>        depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
>
> or
> config OLPC_XO15_SCI
>        bool "OLPC XO-1.5 SCI extras"
>        depends on OLPC && ACPI && POWER_SUPPLY
>
> In both cases, the 'bool' depends on one or more tristate symbols, so
> the tristates are satisfied if they are =m or =y.  This should work fine
> if these kconfig symbols (listed above) were tristate instead of bool.

In this case, we do need them to be bool options. At least for now. We
tried for a modular design earlier in the review process but it added
too much complexity.

So, whats the best way to fix the Kconfig? Should we:

depends on POWER_SUPPLY=y

or

depends on POWER_SUPPLY
select POWER_SUPPLY

?

Thanks,
Daniel
