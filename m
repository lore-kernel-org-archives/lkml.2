Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0F2E6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 00:58:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43109 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0F2E6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 00:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZB0aum2jF8SmSXTIq6l/yS7k6Jik37DYHTgcegdxDSO8bXTNT6afeWqgpeIgR9ntlk
         3dd1gKtiPS8DTlcqWdBZfOPaea3J46bWPLilqifYEn5yreTnFnH1pnGL2UEFZKfJMvH3
         f8ad3Eo2hQ9SK6PQnXACn7hUcU7uZhYQPOctI=
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Oleg Nesterov <oleg@redhat.com>, john stultz <johnstul@us.ibm.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100623194145.GA19628@redhat.com>
References: <20100623181129.GM5876@outflux.net>
	 <20100623194145.GA19628@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jun 2010 07:58:25 +0300
Message-Id: <1277787505.3599.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-23 at 21:41 +0200, Oleg Nesterov wrote:
> On 06/23, Kees Cook wrote:
> >
> > @@ -956,7 +957,15 @@ void set_task_comm(struct task_struct *tsk, char *buf)
> >  	 */
> >  	memset(tsk->comm, 0, TASK_COMM_LEN);
> >  	wmb();
> 
> Off-topic. I'd wish I could understand this barrier. Since the lockless
> reader doesn't do rmb() I don't see how this can help.

This wmb() looks wrong to me as well. To achieve what the comment in
this function says, it should be smp_wmb() and we should have smp_rmb()
in the reading side, AFAIU.

>  OTOH, I don't
> understand why it is needed, we never change ->comm[TASK_COMM_LEN-1] == '0'.

I think the idea was that readers can see incomplete names, but not
messed up names, consisting of old and new ones.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

