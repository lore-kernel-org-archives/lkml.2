Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1FOOae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:30:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56244 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab1FOOad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eCFTfmxDEFOPwWoZT6plu9dSK13urbpT1UU1cnK7tUfZw9tqSuFoKHxFBAOrnkFCrj
         bBZcn1diMRRlzo9sIK1CufIUNcl3q52DXUSLp8WzZW1mDe8M3PErkn8xJ/nwaWijYnqm
         t26sA9T7U4WzNXFa4JkniIY/5lfOUQb5erhfA=
Date: Wed, 15 Jun 2011 16:30:29 +0200
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: don't use flush_scheduled_work() in IRQ affinity
 notifiers
Message-ID: <20110615143029.GZ8141@htj.dyndns.org>
References: <20110615142917.GY8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615142917.GY8141@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 04:29:17PM +0200, Tejun Heo wrote:
> cd7eab44e9 (genirq: Add IRQ affinity notifiers) added use of
> flush_scheduled_work() which is being deprecated.  Add a dedicated
> workqueue and flush it instead of flushing system-wide workqueue.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ben Hutchings <bhutchings@solarflare.com>
> ---
> I'm planning on marking flush_scheduled_work() deprecated in
> linux-next soonish.  It would be great if this patch (or something
> else which removes flush_scheduled_work() call somehow) can be
> included in linux-next.

Ooh, right, only compile & boot tested.  Don't have anything which
makes use of affinity notifier.

Thanks.

-- 
tejun
