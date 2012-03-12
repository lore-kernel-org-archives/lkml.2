Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089Ab2CLXoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:44:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758046Ab2CLXk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:40:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120308121828.2cdbdc8c@de.ibm.com>
References: <20120308121828.2cdbdc8c@de.ibm.com> <20120307194548.15987.36073.stgit@warthog.procyon.org.uk> <20120307195001.15987.31240.stgit@warthog.procyon.org.uk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: dhowells@redhat.com, paul.gortmaker@windriver.com, hpa@zytor.com,
        torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 22/29] Disintegrate asm/system.h for S390
Date: Mon, 12 Mar 2012 23:40:06 +0000
Message-ID: <14404.1331595606@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> This hunk will conflict with "[PATCH] rework smp code" in the linux-next
> tree. The sigp.h header is disintegrated as well..
> But except for this little hiccup I like the idea to split system.h,
> makes a lot of sense.

I've just posted a new version of my patchset that reverses the order of the
patches to put the arch-specific bits first.  Each arch-specific bit is a
stand-alone reduction of that asm/system.h to just a bunch of #includes which
is deleted by the final patch (except where asm-generic/system.h is involved).

As these are independent, it would, for example, be possible to just take the
s390 one into your tree and merge it with your changes.

David
