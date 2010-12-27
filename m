Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0L0T6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 14:58:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:64217 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab0L0T6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 14:58:45 -0500
Date: Mon, 27 Dec 2010 11:57:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, nab@kernel.org,
        scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 27 (drivers/target)
Message-Id: <20101227115755.ffcdfc4f.randy.dunlap@oracle.com>
In-Reply-To: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Dec 2010 17:04:51 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> [The mirroring on kernel.org is running slowly]
> 
> Changes since 20101221:
> 
> Linus' tree lost its build failure.


Hi Nick,

Please test building target code when CONFIG_BLOCK is not enabled.

When CONFIG_BLOCK is not enabled, drivers/target/ gets a boat load of build errors.

Should TCM_IBLOCK depend on BLOCK?  That fixes lots of the build errors,
but not all of them.


The header file include/target/target_core_base.h uses struct queue_limits,
so it should #include <linux/blkdev.h>.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
