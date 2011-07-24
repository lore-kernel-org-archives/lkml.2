Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1GXDUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 23:20:39 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:35004 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751160Ab1GXDUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 23:20:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Lxh0fpPAASi91aNC8xck1AULudWYc5xbH7nfAHdO8M+u+TOJVlMuxt2FXnsN+yZCkdVZlStqp1uNugZ6JCZPyTSRMv7o++NWa9WClwHdkrk+mbQexjVJx7R3NfGLTYUj;
Date: Sat, 23 Jul 2011 20:20:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Daniel Drake <dsd@laptop.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>, tglx@linutronix.de,
        x86@kernel.org
Subject: Re: OLPC power management patches - merge for 3.1?
Message-Id: <20110723202032.67ebdbcc.rdunlap@xenotime.net>
In-Reply-To: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
References: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011 23:44:09 +0100 Daniel Drake wrote:

> Hi,
> 
> Many thanks for committing the OLPC power management patches to
> linux-tip a few weeks ago.
> 
> Even though they were never merged into the master branch of linux-tip
> (where I presume linux-next pulls from), they have been included in
> linux-next for even longer via Andrew Morton's tree.
> 
> Is there any chance you could send them for inclusion in Linux 3.1?
> The functionality is working well, but a small fixup is needed for
> XO-1.5 (see "[PATCH] x86, olpc-xo15-sci: enable EC wakeup capability"
> from 2011-07-09).

Hi,

I should have posted this sooner...

I have no objection to merging OLPC patches, but they should build
without errors.

>From linux-next 20110722:

arch/x86/built-in.o: In function `battery_status_changed':
olpc-xo15-sci.c:(.text+0x3acdd): undefined reference to `power_supply_get_by_name'
olpc-xo15-sci.c:(.text+0x3ad04): undefined reference to `power_supply_changed'
arch/x86/built-in.o: In function `ac_status_changed':
olpc-xo15-sci.c:(.text+0x3ad4d): undefined reference to `power_supply_get_by_name'
olpc-xo15-sci.c:(.text+0x3ad74): undefined reference to `power_supply_changed'

Looks like this problem is caused by:

config OLPC_XO1_SCI
	bool "OLPC XO-1 SCI extras"
	depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY

or
config OLPC_XO15_SCI
	bool "OLPC XO-1.5 SCI extras"
	depends on OLPC && ACPI && POWER_SUPPLY

In both cases, the 'bool' depends on one or more tristate symbols, so
the tristates are satisfied if they are =m or =y.  This should work fine
if these kconfig symbols (listed above) were tristate instead of bool.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
