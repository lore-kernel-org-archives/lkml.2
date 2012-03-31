Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2CaTbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 15:31:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab2CaTbr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 15:31:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120329153409.7295eda9@stein>
References: <20120329153409.7295eda9@stein>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: On patch "Remove all #inclusions of asm/system.h"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Sat, 31 Mar 2012 20:31:33 +0100
Message-ID: <31597.1333222293@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> commit 9ffc93f2 "Remove all #inclusions of asm/system.h" removes a lot of
> includes while its parent commit 96f951ed "Add #includes needed to permit
> the removal of asm/system.h" adds only a few.  Some of the files modified
> by commit 9ffc93f2 now only work due to indirect inclusion, don't they?
> 
> For example, drivers/firewire/{core-device,core-topology,ohci,sbp2}.c use
> smp_rmb()¹ and used to include asm/system.h.  Now they do not include
> asm/barrier.h.  Is this by mistake or on purpose?

I tried to make sure allyesconfig worked for x86_64 and a bunch of defconfigs
worked.  I can't guarantee that that got 100% coverage.  I also knew there
would be some breakage from the base Linux kernel having moved on by the time
Linus pulled myu patches - though I don't know if this is the case here (I
suspect not).

David
