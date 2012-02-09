Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab2BIPdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:33:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49661 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2BIPdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:33:51 -0500
Date: Thu, 9 Feb 2012 19:33:46 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] arm: Fix possible race on task->mm
Message-ID: <20120209153346.GA346@oksana.dev.rtsoft.ru>
References: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
 <20120207065004.GC1496@oksana.dev.rtsoft.ru>
 <20120208160808.GB17177@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120208160808.GB17177@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 05:08:08PM +0100, Oleg Nesterov wrote:
> On 02/07, Anton Vorontsov wrote:
> >
> > Checking for task->mm is dangerous as ->mm might disappear (exit_mm()
> > assigns NULL under task_lock(), so tasklist lock is not enough).
> >
> > We can't use get_task_mm()/mmput() pair as mmput() might sleep,
> 
> Yes, but
> 
> > so let's take the task lock while we care about its mm.
> 
> it seems that this needs find_lock_task_mm() too ?
> 
> the same for the rest patches in this series.

Yep, I think you're right, will add this change.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
