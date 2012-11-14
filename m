Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab2KNR0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:26:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2KNR0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:26:50 -0500
Date: Wed, 14 Nov 2012 09:26:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
Cc: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-tip-commits@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, riel@redhat.com, aarcange@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
Subject: Re: [tip:numa/core] mm: Count the number of pages affected in
 change_protection()
Message-Id: <20121114092645.95fce74b.akpm@linux-foundation.org>
In-Reply-To: <tip-a9463d90124af069b9b58a276acc46c00054d722@git.kernel.org>
References: <tip-a9463d90124af069b9b58a276acc46c00054d722@git.kernel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 06:25:56 -0800 tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> mm: Count the number of pages affected in change_protection()
> 
> This will be used by three kinds of purposes:
> 
>  - to optimize mprotect()
> 
>  - to speed up working set scanning for working set areas that
>    have not been touched
> 
>  - to more accurately scan per real working set
> 
> No change in functionality from this patch.

Seems simple, cheap and useful.

A bit lacking in interface comments though.  In particular, does the
return value (which is in units of PAGE_SIZE pages) represent the
number of pages which were inspected, or the number of pages which
actually had their permissions modified?

>From a quick look, it seems the answer is both.  Or neither.  If a
page's protection was written to but unaltered, that counts as a "1". 
But if a pmd couldn't be locked via __pmd_trans_huge_lock(), that
counts as a "0".

Anyway, please have a think about it, and describe exactly what these
return values mean?

