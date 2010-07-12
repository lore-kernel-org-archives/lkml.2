Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0GLKqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 06:46:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34025 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0GLKqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 06:46:07 -0400
X-Authority-Analysis: v=1.1 cv=FmZLatDjtfD3C7oE6GdrxaCbsxiNBR9ZXBX9JZchN1o= c=1 sm=0 a=tMgyaNRFpoYA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VnNF1IyMAAAA:8 a=0rN2wo78ueaPTszE7GgA:9 a=h1Ub9WaSrsjGE0SXLPMU7z96wdMA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/4] futex: free_pi_state outside of hb->lock sections
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Mike Galbraith <efault@gmx.de>, linux-rt-users@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1007121231290.2798@localhost.localdomain>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
	 <1278714780-788-4-git-send-email-dvhltc@us.ibm.com>
	 <alpine.LFD.2.00.1007121231290.2798@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 12 Jul 2010 06:46:03 -0400
Message-ID: <1278931563.1537.184.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 12:35 +0200, Thomas Gleixner wrote:
> On Fri, 9 Jul 2010, Darren Hart wrote:
> 
> > free_pi_state() calls kfree() and might sleep. To prepare for raw hb->locks,
> > get the calls to free_pi_state() out of the hb->lock() sections.
> > 
> > Signed-off-by: Darren Hart <dvhltc@us.ibm.com>

> >  	struct task_struct *task;
> > -	spinlock_t *lock_ptr;
> > +	raw_spinlock_t *lock_ptr;
> 
>  How is this related to the changelog ?

Read the reply to himself (V2) ;-)

-- Steve


