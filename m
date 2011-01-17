Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1AQVCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:02:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36775
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878Ab1AQVCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:02:06 -0500
Date: Mon, 17 Jan 2011 13:02:38 -0800 (PST)
Message-Id: <20110117.130238.245404805.davem@davemloft.net>
To: richm@oldelvet.org.uk
Cc: 609371@bugs.debian.org, ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, Jesper.Nilsson@axis.com, jeffm@suse.com
Subject: Re: R_SPARC_13
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295293581.32152.70.camel@duncow>
References: <20110116.220755.179947617.davem@davemloft.net>
	<1295259761.32152.20.camel@duncow>
	<1295293581.32152.70.camel@duncow>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Mortimer <richm@oldelvet.org.uk>
Date: Mon, 17 Jan 2011 19:46:21 +0000

> As an example from drivers/scsi/scsi_error.c function scsi_eh_wakeup().
> 
> This has relocation records of
 ...
> 0000000000002be4 R_SPARC_LO10      __tracepoint_scsi_eh_wakeup
> 0000000000002be4 R_SPARC_13        *ABS*+0x0000000000000008
 ...
> lduw    [%g1+%lo(__tracepoint_scsi_eh_wakeup)+8], %g2   ! __tracepoint_scsi_eh_wakeup.state,

In a final object, the binutils linker should be using one
R_SPARC_OLO10 relocation for this kind of expression on sparc64.  Not
the two relocations on the same instruction it appears to be using
here.  I think you're looking at an object output by the assembler
and not the finally linked module.

You should also be careful about which objects you are analyzing.  You
should be looking at the finally linked "foo.ko" file, not the
individual "foo.o" objects, as the majority of the relocations go away
when the linker puts together the final module.

Is that what you're doing?
