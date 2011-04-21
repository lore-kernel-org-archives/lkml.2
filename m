Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1DUPvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:51:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39334 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab1DUPvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:51:43 -0400
Date: Thu, 21 Apr 2011 08:51:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ranganathan Desikan <ravi@jetztechnologies.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        arvino55@gmail.com, bluesmoke-devel@lists.sourceforge.net,
        linux-edac@vger.kernel.org
Subject: Re: linux-next: Tree for April 21 (i82975x_edac)
Message-Id: <20110421085124.4a44d048.randy.dunlap@oracle.com>
In-Reply-To: <20110421132045.5af1b953.sfr@canb.auug.org.au>
References: <20110421132045.5af1b953.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DB05282.009E:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011 13:20:45 +1000 Stephen Rothwell wrote:

> Changes since 20110420:


on i386:

drivers/edac/i82975x_edac.c:298: warning: integer constant is too large for 'unsigned long' type

which is:

	if (info->xeap & 1)
		page |= 0x100000000ul; <<<<<<<<<<<<<<<

but page is unsigned long (32 bits), while 0x100000000ul is more than 32 bits,
so that line isn't setting a bit in <page>.  Is it a bug, or this driver isn't
applicable to X86_32, or what?


thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
