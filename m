Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1GUICw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 04:02:52 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:47746 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1GUICp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 04:02:45 -0400
Date: Thu, 21 Jul 2011 10:02:40 +0200
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the ptrace tree with the s390 tree
Message-ID: <20110721080240.GZ3455@htj.dyndns.org>
References: <20110720153320.a7f33784158ccb04fafcb5d6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720153320.a7f33784158ccb04fafcb5d6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 20, 2011 at 03:33:20PM +1000, Stephen Rothwell wrote:
> Today's linux-next merge of the ptrace tree got a conflict in
> arch/s390/kernel/traps.c between commit 248bed4b0f3c ("[S390] use siginfo
> for sigtrap signals") from the s390 tree and commit a288eecce525
> ("ptrace: kill trivial tracehooks") from the ptrace tree.
> 
> It looks like the former is a superset of the latter, so I used the
> former.

Yeap, pretty much.  Martin, testing if (current->ptrace) is enough.
If PT_PTRACED is not set, no other flag there is allowed to set.
Also, I think we really should standardize what gets reported in these
debug traps instead of letting each arch do its own thing.

Thanks.

-- 
tejun
