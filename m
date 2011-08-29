Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1H2Hbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:31:42 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49025 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1H2Hbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:31:38 -0400
Date: Mon, 29 Aug 2011 09:31:31 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 09/16] freezer: make freezing indicate freeze condition
 in effect
Message-ID: <20110829073131.GD16431@mtj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-10-git-send-email-tj@kernel.org>
 <20110828175601.GB27032@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110828175601.GB27032@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 07:56:01PM +0200, Oleg Nesterov wrote:
> > +	/* leave FROZEN */
> > +	spin_lock_irq(&freezer_lock);
> > +	current->flags &= ~PF_FROZEN;
> > +	spin_unlock_irq(&freezer_lock);
> 
> What if freezing() is true again when we are going to clear
> PF_FROZEN?
> 
> In this case the 2nd try_to_freeze_tasks() can see this task
> as already frozen and return success while it is going to run.

Indeed, if we need to do if (frezing) goto retry; there.  Will fix.

Thanks.

-- 
tejun
