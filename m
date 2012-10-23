Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab2JWNFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:05:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:42015 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab2JWNFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:05:19 -0400
Message-ID: <1350997505.13456.22.camel@twins>
Subject: Re: [PATCH 14/34] perf, x86: Avoid checkpointed counters causing
 excessive TSX aborts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Date: Tue, 23 Oct 2012 15:05:05 +0200
In-Reply-To: <1350602382-12771-15-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	 <1350602382-12771-15-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> +       /* XXX move somewhere else. */
> +       if (cpuc->events[2] && (cpuc->events[2]->hw.config & HSW_INTX_CHECKPOINTED))
> +               status |= (1ULL << 2); 

A comment explaining about those 'spurious' PMIs would go along with
this nicely, no? I'm very sure I'd keep having to look up the commit
introducing this to figure out wtf its for.
