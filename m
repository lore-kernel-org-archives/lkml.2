Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1HAMnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:43:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:37191 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1HAMnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:43:12 -0400
Message-ID: <4E369F53.4040903@windriver.com>
Date: Mon, 1 Aug 2011 07:42:59 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (kgdb
 tree related)
References: <20110801142257.0fe7bcceaa0c61527b9597c3@canb.auug.org.au>
In-Reply-To: <20110801142257.0fe7bcceaa0c61527b9597c3@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2011 11:22 PM, Stephen Rothwell wrote:
> Hi Jason,
>
> After merging the final tree, today's linux-next build (sparc32_defconfig)
> failed like this:
>
> kernel/debug/gdbstub.c: In function 'gdbstub_state':
> kernel/debug/gdbstub.c:1098:3: error: 'gdbstub_use_prev_in_buf' undeclared (first use in this function)
> kernel/debug/gdbstub.c:1098:3: note: each undeclared identifier is reported only once for each function it appears in
> kernel/debug/gdbstub.c:1099:3: error: 'gdbstub_prev_in_buf_pos' undeclared (first use in this function)
>
> Caused by commit faed702e3b31 ("kdb,kgdb: Implement switch and pass
> buffer from kdb -> gdb").
>
> I reverted that commit (and 621ebf205b99 "kdb: Remove all references to
> DOING_KGDB2" and "kdb,kgdb: Allow arbitrary kgdb magic knock
> sequences" that depend on it) for today.
>
> BTW, that last commit (29e3c61ef33c) doesn't have a SOB line.

Thanks for the detailed report.   I fixed this by re-basing kgdb-next against the kgdb-dev branch.  These branches are not supposed to get out of sync.  I'll try and figure out what went wrong. :-)

Jason.
