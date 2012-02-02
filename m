Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2BBWCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:02:31 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33409 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2BBWCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:02:30 -0500
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 14:02:22 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Nick Bowler <nbowler@elliptictech.com>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120202220222.GC11308@leaf>
References: <20120202200621.GB9279@leaf>
 <20120202202207.GA10041@elliptictech.com>
 <alpine.LNX.2.00.1202022225210.16813@swampdragon.chaosbits.net>
 <1328218456.18641.60.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328218456.18641.60.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 01:34:16PM -0800, Joe Perches wrote:
> On Thu, 2012-02-02 at 22:29 +0100, Jesper Juhl wrote:
> > But generally a good idea to warn about "easily grepable strings broken 
> > into multiple lines" if possible, IMHO...
> 
> Maybe count the %'s?  Ignore if more than 2?

Numerous greppable strings include several formats, but you can
generally look at a message and know which non-parameterized bits to
grep for.  Even in the case of strings with numerous parameters, it
often works better to grep for the whole string and replace the
parameters with '.*', and make the string incrementally less specific
until I find it.  For example, from dmesg on my system:

[    0.000000] last_pfn = 0xdb000 max_arch_pfn = 0x400000000

Grepping for "last_pfn" or even "last_pfn = " produces a pile of
results, but grepping for 'last_pfn = .* max_arch_pfn' produces exactly
one result:

arch/x86/kernel/e820.c: printk(KERN_INFO "last_pfn = %#lx max_arch_pfn = %#lx\n",

That wouldn't work if the string broke across lines.  So, I still think
it seems reasonable for checkpatch to encourage keeping such strings
un-split.

- Josh Triplett
