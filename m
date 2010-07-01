Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0GANi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:38:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38657 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0GANiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:38:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G7iSX2DJTF5JMy+E9G1i7mDvu/ZYrY+oAyiFJmTKSLpLUBrySAY5QP+auCDz+kGYLC
         z0i7EF1pLg/cmiPaAXOLIxuNlxflF7AIlv6T0ROHsGaWVWUUeFPgcvKLkK71ntjWjyW/
         8b7AVsOO9j+/2fLwUGe4Q/MRfo7+RPaQmo3R4=
Date: Thu, 1 Jul 2010 22:38:46 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 02/11] oom: oom_kill_process() doesn't select kthread
 child
Message-ID: <20100701133846.GA16383@barrios-desktop>
References: <20100630182715.AA4B.A69D9226@jp.fujitsu.com>
 <20100630135503.GA15644@barrios-desktop>
 <20100701085011.DA13.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701085011.DA13.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 09:07:02AM +0900, KOSAKI Motohiro wrote:
> > On Wed, Jun 30, 2010 at 06:27:52PM +0900, KOSAKI Motohiro wrote:
> > > Now, select_bad_process() have PF_KTHREAD check, but oom_kill_process
> > > doesn't. It mean oom_kill_process() may choose wrong task, especially,
> > > when the child are using use_mm().
> > 
> > Is it possible child is kthread even though parent isn't kthread?
> 
> Usually unhappen. but crappy driver can do any strange thing freely.
> As I said, oom code should have conservative assumption as far as possible.

Okay. You change the check with oom_unkillable_task at last. 
The oom_unkillable_task is generic function so that the kthread check in
oom_kill_process is tivial, I think. 

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


> 
> 
> 

-- 
Kind regards,
Minchan Kim
