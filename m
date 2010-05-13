Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab0EMPVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:21:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37593 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0EMPVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:21:22 -0400
X-Authority-Analysis: v=1.1 cv=QBaIlYAip0cLYvdi/Wu3On4+kilSXYulM+a9j4asJ0c= c=1 sm=0 a=7pe9fe_TKsgA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=D_SbEOMbAAAA:8 a=y2eFyfI2TYVlqHiHqvYA:9 a=krmAQ6XDo2TWBoo0g9MICOEHGB0A:4 a=PUjeQqilurYA:10 a=7KbvKZvEaC0A:10 a=Ph91IYdXpQRUPT7D:21 a=z2yWQf8znux3rb-V:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/4] tracing/sched: Fix task states in sched switch
 event
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Carsten Emde <C.Emde@osadl.org>, linux-kernel@vger.kernel.org,
       And rew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20100513133539.GA17107@elte.hu>
References: <RYmXFZH5FML2.rJxWwvD3@ce.dyn.web-alm.net>
	 <20100513133539.GA17107@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 13 May 2010 11:21:19 -0400
Message-ID: <1273764079.27703.1002.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 15:35 +0200, Ingo Molnar wrote:
> * Carsten Emde <C.Emde@osadl.org> wrote:
> 
> > Hi Ingo,
> > 
> > > Hm, this is totally unreadable. What does 'TASK_STATE_X' mean??
> > Would this be better?
> > +#define MAKE_TASK_STATE_STRING(num) TASK_STATE_##num " (" DESCR_TASK_STATE_##num ")"
> >  static const char *task_state_array[] = {
> > -	"R (running)",		/*   0 */
> > -	"S (sleeping)",		/*   1 */
> > -	"D (disk sleep)",	/*   2 */
> > -	"T (stopped)",		/*   4 */
> > -	"t (tracing stop)",	/*   8 */
> > -	"Z (zombie)",		/*  16 */
> > -	"X (dead)",		/*  32 */
> > -	"x (dead)",		/*  64 */
> > -	"K (wakekill)",		/* 128 */
> > -	"W (waking)",		/* 256 */
> > +	MAKE_TASK_STATE_STRING(0),
> > +	MAKE_TASK_STATE_STRING(1),
> > +	MAKE_TASK_STATE_STRING(2),
> > +	MAKE_TASK_STATE_STRING(4),
> > +	MAKE_TASK_STATE_STRING(8),
> > +	MAKE_TASK_STATE_STRING(16),
> > +	MAKE_TASK_STATE_STRING(32),
> > +	MAKE_TASK_STATE_STRING(64),
> > +	MAKE_TASK_STATE_STRING(128),
> > +	MAKE_TASK_STATE_STRING(256)
> 
> The whole enumeration there is pointless in that .c file - it tells nothing to 
> the code reader.
> 
> If it cannot be expressed in a meaningful way then introduce 
> TASK_STATE_STRINGS_INIT construct that is defined next to the strings (in a .h 
> file or so) - that way it's a coherent whole.

I'm rebasing both pull requests. I'll leave this one out until there is
an agreement.

Thanks,

-- Steve


