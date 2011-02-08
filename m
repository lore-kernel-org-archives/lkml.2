Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab1BHBv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:51:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52562 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1BHBv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:51:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 8 Feb 2011 10:45:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mlock: fix race when munlocking pages in
 do_wp_page()
Message-Id: <20110208104505.a737d179.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1297126056-14322-2-git-send-email-walken@google.com>
References: <1297126056-14322-1-git-send-email-walken@google.com>
	<1297126056-14322-2-git-send-email-walken@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Feb 2011 16:47:35 -0800
Michel Lespinasse <walken@google.com> wrote:

> vmscan can lazily find pages that are mapped within VM_LOCKED vmas,
> and set the PageMlocked bit on these pages, transfering them onto the
> unevictable list. When do_wp_page() breaks COW within a VM_LOCKED vma,
> it may need to clear PageMlocked on the old page and set it on the
> new page instead.
> 
> This change fixes an issue where do_wp_page() was clearing PageMlocked on
> the old page while the pte was still pointing to it (as well as rmap).
> Therefore, we were not protected against vmscan immediately trasnfering
> the old page back onto the unevictable list. This could cause pages to
> get stranded there forever.
> 
> I propose to move the corresponding code to the end of do_wp_page(),
> after the pte (and rmap) have been pointed to the new page. Additionally,
> we can use munlock_vma_page() instead of clear_page_mlock(), so that
> the old page stays mlocked if there are still other VM_LOCKED vmas
> mapping it.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


