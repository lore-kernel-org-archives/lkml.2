Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab0LXJSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 04:18:37 -0500
Received: from smtp-out.google.com ([74.125.121.67]:46254 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0LXJSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 04:18:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=XF/PKFRw4WtM25z1yAja3hULDQPD52Im2cvNqSJVngoBXXNUWqN8dOVvW8/cb4ST8g
         0J5O8zWP2o0FU17us6tQ==
MIME-Version: 1.0
In-Reply-To: <20101220061041.GA8512@bicker>
References: <20101220061041.GA8512@bicker>
From: Paul Turner <pjt@google.com>
Date: Fri, 24 Dec 2010 04:17:59 -0500
Message-ID: <AANLkTimPAsFv5AAN+7qo4kmFEOm4k21zYgrh-k77_5CO@mail.gmail.com>
Subject: Re: [smatch] sched_fair: check after dereference
To: Dan Carpenter <error27@gmail.com>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delayed response -- was travelling, currently home for
holidays on terrible (satellite) internet.

On Mon, Dec 20, 2010 at 1:10 AM, Dan Carpenter <error27@gmail.com> wrote:
> Hi Paul,
>
> In linux-next e33078baa4 "sched: Fix update_cfs_load() synchronization"
> introduced a dereference before the check for NULL.  I don't know the
> code well enough to say if it's a bug or if the check can be removed.
>

This should be stale.  Now that we issue versus the queuing cfs_rq as
opposed to the group cfs_rq the passed pointer should always be valid.

If you want to send a patch I'll ack it, otherwise I can send one out
in the morning.

Thanks!

- Paul

> kernel/sched_fair.c +728 update_cfs_load(6)
>        warn: variable dereferenced before check 'cfs_rq'
>
>   722  static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
>   723  {
>   724          u64 period = sysctl_sched_shares_window;
>   725          u64 now, delta;
>   726          unsigned long load = cfs_rq->load.weight;
>                                     ^^^^^^^^^^^^^^^^^^^
>   727
>   728          if (!cfs_rq)
>                     ^^^^^^
>   729                  return;
>
> Can you take a look?
>
> regards,
> dan carpenter
>
>
