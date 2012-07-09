Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab2GIK3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:29:55 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36739 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2GIK3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:29:53 -0400
Date: Mon, 9 Jul 2012 15:59:22 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] uprobes: cleanup and document
 write_opcode()->lock_page(old_page)
Message-ID: <20120709102922.GD32393@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120624145936.GA23269@redhat.com>
 <20120624150053.GD23277@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120624150053.GD23277@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070910-7282-0000-0000-00000AB8CF2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-06-24 17:00:53]:

> The comment above write_opcode()->lock_page(old_page) tells about
> the race with do_wp_page(). I don't really understand which exactly
> race it means, but afaics this lock_page() was not enough to close
> all races with do_wp_page().
> 
> Anyway, since 77fc4af1 this code is always called with ->mmap_sem
> hold for writing so we can forget about do_wp_page().
> 
> However, we can't simply remove this lock_page(), and the only
> (afaics) reason is __replace_page()->try_to_free_swap().
> 
> Nothing in write_opcode() needs it, move it into __replace_page()
> and fix the comment.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

