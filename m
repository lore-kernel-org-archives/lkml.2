Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2LVDOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:14:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2LVDOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:14:35 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=pTZiz8ykJHYA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=6ohLA4t_IOQA:10 a=7Jd83ytDAAAA:8 a=keD6Jnw0LPue6LIY9-0A:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Fri, 21 Dec 2012 22:14:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 2/3] x86,smp: proportional backoff for ticket
 spinlocks
Message-ID: <20121222031433.GE27621@home.goodmis.org>
References: <20121221184940.103c31ad@annuminas.surriel.com>
 <20121221185115.1858ffc5@annuminas.surriel.com>
 <20121222030756.GD27621@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121222030756.GD27621@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 10:07:56PM -0500, Steven Rostedt wrote:
> > diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> > index 20da354..4e44840 100644
> > --- a/arch/x86/kernel/smp.c
> > +++ b/arch/x86/kernel/smp.c
> > @@ -118,9 +118,11 @@ static bool smp_no_nmi_ipi = false;
> >  void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
> >  {
> >  	for (;;) {
> > -		cpu_relax();
> > -		inc.head = ACCESS_ONCE(lock->tickets.head);
> > +		int loops = 50 * (__ticket_t)(inc.tail - inc.head);
> > +		while (loops--)
> > +			cpu_relax();
> 
> -ENOCOMMENT
> 
> Please add a comment above to explain what it's doing. Don't expect
> people to check change logs. Also, explain why you picked 50.
> 

OK, I replied here before reading patch 3 (still reviewing it). Why have
this patch at all? Just to test if you broke something between this and
patch 3? Or perhaps patch 3 may not get accepted? In that case, you
would still need a comment.

Either explicitly state that this patch is just a stepping stone for
patch 3, and will either be accepted or rejected along with patch 3. Or
keep it as a stand alone patch and add comments as such. Or just get rid
of it all together.

Thanks,

-- Steve

