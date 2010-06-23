Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab0FWRrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:47:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab0FWRry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:47:54 -0400
Date: Wed, 23 Jun 2010 19:47:18 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-mm@kvack.org, avi@redhat.com
Subject: Re: [PATCH -mm 3/6] ksm: fix ksm swapin time optimization
Message-ID: <20100623174718.GD16195@random.random>
References: <20100621163146.4e4e30cb@annuminas.surriel.com>
 <20100621163439.4e76c2f8@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621163439.4e76c2f8@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 04:34:39PM -0400, Rik van Riel wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> Subject: fix ksm swapin time optimization
> 
> The new anon-vma code, was suboptimal and it lead to erratic invocation of
> ksm_does_need_to_copy. That leads to host hangs or guest vnc lockup, or weird
> behavior.  It's unclear why ksm_does_need_to_copy is unstable but the point is
> that when KSM is not in use, ksm_does_need_to_copy must never run or we bounce

BTW, I'm debugging why ksm_does_need_to_copy breaks things... probably
I found something already, maybe not. I'll let you know as soon as I
have a fix. In the meantime the one above is a fix needed to avoid
calling ksm_does_need_to_copy erratically even when KSM is off (which
also avoids the bug to trigger).
