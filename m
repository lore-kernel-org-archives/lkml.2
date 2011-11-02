Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab1KBPmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:42:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43235 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1KBPmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:42:23 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=FyDICSIpE5IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=meVymXHHAAAA:8 a=FvNiBoSrOOIQvm2NuCcA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320248542.4793.34.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] jump_label_inc may return before the code is patched
From: Steven Rostedt <rostedt@goodmis.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu
Date: Wed, 02 Nov 2011 11:42:22 -0400
In-Reply-To: <20111102152123.GF14726@redhat.com>
References: <20111018175551.GH17571@redhat.com>
	 <1318971986.3712.18.camel@frodo> <20111102152123.GF14726@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 17:21 +0200, Gleb Natapov wrote:
> On Tue, Oct 18, 2011 at 05:06:25PM -0400, Steven Rostedt wrote:
> > On Tue, 2011-10-18 at 19:55 +0200, Gleb Natapov wrote:
> > > If cpu A calls jump_label_inc() just after atomic_add_return() is
> > > called by cpu B, atomic_inc_not_zero() will return value greater then
> > > zero and jump_label_inc() will return to a caller before jump_label_update()
> > > finishes its job on cpu B.
> > 
> > OK, I see what you are saying. There's a race here that jump_label_inc
> > may return before jump labels are actually activated. I have no issue
> > with this change. This guarantees that jump labels will be active on
> > return of jump_label_inc().
> > 
> > I'm assuming that jump_label_update() does memory barries, as it does
> > modify code, and would be itself a synchronization point.
> > 
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> So through what tree this should go to Linus' git?

I'll pull it in. I'm currently scrambling around getting back up to
speed after a 11 day conference spree.



-- Steve


