Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab1FQJpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:45:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41907 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab1FQJpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BZmywykfrYveL4XeHvtKIAMeCvmJzJoHRz1JlgKk6m25GdVgEHNbEabL1N9ppU96TP
         3VvCNO/VBz0vS5eMgBjUQY75YDmHEjPzS3NJ3xthDa+ABbNx9TofyPS0DRlrtRNz1sPC
         Ejr3Il71eodQ6eOtc7hYtgFQCnnbHOL3xSbAg=
Date: Fri, 17 Jun 2011 11:45:47 +0200
From: Tejun Heo <tj@kernel.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: don't use flush_scheduled_work() in IRQ affinity
 notifiers
Message-ID: <20110617094547.GF2611@htj.dyndns.org>
References: <20110615142917.GY8141@htj.dyndns.org>
 <1308266886.2925.27.camel@bwh-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308266886.2925.27.camel@bwh-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jun 17, 2011 at 12:28:06AM +0100, Ben Hutchings wrote:
> This facility is enabled on all configurations with NET && SMP &&
> GENERIC_HARDIRQS, but at the moment is only useful for some net drivers
> (currently only one).  So I don't think it should be creating a task at
> boot time.  Does alloc_workqueue() still create any tasks immediately?

Nope, no need to worry about it.  The only added overhead is the
memory occupied by workqueue itself (which includes small percpu area
but one systemwide one isn't gonna hurt anyone and we've been
decreasing the number of workqueues significantly).  It just serves as
a flush domain.

-- 
tejun
