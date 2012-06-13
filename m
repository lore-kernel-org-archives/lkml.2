Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2FMTVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:21:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab2FMTVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:21:40 -0400
Date: Wed, 13 Jun 2012 21:19:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linuxppc-dev@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>, michael@ellerman.id.au,
        antonb@thinktux.localdomain, Paul Mackerras <paulus@samba.org>,
        benh@kernel.crashing.org, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: Q: a_ops->readpage() && struct file
Message-ID: <20120613191928.GB14246@redhat.com>
References: <20120608093257.GG13409@in.ibm.com> <20120611161215.GA12116@redhat.com> <20120611190902.GA19869@redhat.com> <1339581492.31548.133.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339581492.31548.133.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13, Peter Zijlstra wrote:
>
> On Mon, 2012-06-11 at 21:09 +0200, Oleg Nesterov wrote:
> > Stupid question. I'm afraid the answer is "no" but I'll ask anyway.
> > Is it safe to pass filp == NULL to mapping->readpage()? In fact
> > I do not understand why it needs "struct file*" and I do not see
> > any example of actual usage.
>
> Looking at afs_readpage it looks like its OK to pass in NULL. Same for
> nfs_readpage. They use the file, if provided, to avoid some lookups, but
> seem to deal with not having it.

Yes, and reiser4 does the same.

> This answer by example is of course not authorative nor complete.

Yes... perhaps we should simply change this code to use NULL and
collect the bug-reports ;)

Oleg.

