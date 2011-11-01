Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab1KAUTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 16:19:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42951 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAUTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 16:19:06 -0400
Date: Tue, 1 Nov 2011 13:19:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Watts <akwatts@ymail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        dmitry.torokhov@gmail.com
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111101201902.GA1763@google.com>
References: <20111101124759.GA1326@zeus>
 <20111101164235.GS18855@google.com>
 <20111101191459.GA2748@zeus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101191459.GA2748@zeus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 02:15:16PM -0500, Andrew Watts wrote:
> On Tue, Nov 01, 2011 at 09:42:35AM -0700, Tejun Heo wrote:
> > 
> > Does the following patch fix the problem?
> > 
> > Thanks.
> 
> Unfortunately, it does not fix the problem.

Odd... how about the following one?  Thanks.

diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index ba70058..14d560a 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -299,9 +299,8 @@ static int serio_queue_event(void *object, struct module *owner,
 	event->owner = owner;
 
 	list_add_tail(&event->node, &serio_event_list);
-	queue_work(system_long_wq, &serio_event_work);
-
 out:
+	queue_work(system_long_wq, &serio_event_work);
 	spin_unlock_irqrestore(&serio_event_lock, flags);
 	return retval;
 }
