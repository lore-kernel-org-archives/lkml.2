Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab2FMJ6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:58:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54910 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2FMJ6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:58:34 -0400
Message-ID: <1339581492.31548.133.camel@twins>
Subject: Re: Q: a_ops->readpage() && struct file
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linuxppc-dev@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>, michael@ellerman.id.au,
        antonb@thinktux.localdomain, Paul Mackerras <paulus@samba.org>,
        benh@kernel.crashing.org, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jim Keniston <jkenisto@us.ibm.com>
Date: Wed, 13 Jun 2012 11:58:12 +0200
In-Reply-To: <20120611190902.GA19869@redhat.com>
References: <20120608093257.GG13409@in.ibm.com>
	 <20120611161215.GA12116@redhat.com> <20120611190902.GA19869@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 21:09 +0200, Oleg Nesterov wrote:
> Stupid question. I'm afraid the answer is "no" but I'll ask anyway.
> Is it safe to pass filp == NULL to mapping->readpage()? In fact
> I do not understand why it needs "struct file*" and I do not see
> any example of actual usage. 

Looking at afs_readpage it looks like its OK to pass in NULL. Same for
nfs_readpage. They use the file, if provided, to avoid some lookups, but
seem to deal with not having it.

This answer by example is of course not authorative nor complete.
