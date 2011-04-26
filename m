Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1DZKmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:42:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58753 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109Ab1DZKmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:42:53 -0400
Date: Tue, 26 Apr 2011 11:42:51 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] signal: do_sigtimedwait() needs
 retarget_shared_pending()
Message-ID: <20110426114251.3d85eec8@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110423180000.GD484@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
	<20110418173224.GA27918@redhat.com>
	<BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
	<20110423175901.GA484@redhat.com>
	<20110423180000.GD484@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 20:00:00 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> do_sigtimedwait() changes current->blocked and thus it needs
> set_current_bloked()->retarget_shared_pending().

If you do another version of this patch could you fix up the function
names in the commit log, s/set_current_bloked/set_current_blocked/ ? Or
maybe Andrew can fix it up if he pulls them into -mm.

> We could use set_current_bloked() directly. It is fine to change
> ->real_blocked from all-zeroes to ->blocked and vice versa lockless,
> but this is not immediately clear, looks racy, and needs a huge
> comment to explain why this is correct.
> 
> To keep the things simple this patch adds the new static helper,
> __set_task_blocked() which should be called with ->siglock held. This
> way we can change both ->real_blocked and ->blocked atomically under
> ->siglock as the current code does. This is more understandable.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center
