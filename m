Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1BHByL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:54:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47053 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1BHByJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:54:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 8 Feb 2011 10:47:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mlock: do not munlock pages in __do_fault()
Message-Id: <20110208104757.bc59f502.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1297126056-14322-3-git-send-email-walken@google.com>
References: <1297126056-14322-1-git-send-email-walken@google.com>
	<1297126056-14322-3-git-send-email-walken@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Feb 2011 16:47:36 -0800
Michel Lespinasse <walken@google.com> wrote:

> If the page is going to be written to, __do_page needs to break COW.
> However, the old page (before breaking COW) was never mapped mapped into
> the current pte (__do_fault is only called when the pte is not present),
> so vmscan can't have marked the old page as PageMlocked due to being
> mapped in __do_fault's VMA. Therefore, __do_fault() does not need to worry
> about clearing PageMlocked() on the old page.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


