Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1CBQZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:25:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077Ab1CBQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:25:48 -0500
Date: Wed, 2 Mar 2011 08:24:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>, shaohua.li@intel.com,
        tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [tip:x86/mm] x86: Work around old gas bug
Message-Id: <20110302082453.934f2033.akpm@linux-foundation.org>
In-Reply-To: <20110302104144.GB25608@elte.hu>
References: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
	<tip-253d89d3dd6b65595f317e5f1ecef43aa207a3a0@git.kernel.org>
	<4D6E2B8B02000078000347C0@vpn.id2.novell.com>
	<20110302104144.GB25608@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011 11:41:44 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> Meanwhile, what i hate more than ugly code repetition is code that does not build at 
> all on akpm's test environment ;-)

I hadn't got around to testing it.  Bad news :(

x86_64 allmodconfig:

arch/x86/kernel/entry_64.S: Assembler messages:
arch/x86/kernel/entry_64.S:979: Error: too many positional arguments
arch/x86/kernel/entry_64.S:983: Error: too many positional arguments
arch/x86/kernel/entry_64.S:987: Error: too many positional arguments
arch/x86/kernel/entry_64.S:991: Error: too many positional arguments
arch/x86/kernel/entry_64.S:995: Error: too many positional arguments
arch/x86/kernel/entry_64.S:999: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1003: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1007: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1011: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1015: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1019: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1023: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1027: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1031: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1035: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1039: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1043: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1047: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1051: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1055: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1059: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1063: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1067: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1071: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1075: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1079: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1083: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1087: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1091: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1095: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1099: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1103: Error: too many positional arguments
make[1]: *** [arch/x86/kernel/entry_64.o] Error 1
make: *** [arch/x86/kernel/entry_64.o] Error 2

There much be some magic workaround for this within apicinterrupt but I
didn't find it.
