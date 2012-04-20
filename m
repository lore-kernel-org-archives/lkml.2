Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2DTO0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:26:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab2DTO0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:26:14 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=O9SDWPecf0MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=L_gcILtZ5A39mL7Ri-MA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334931972.28106.80.camel@gandalf.stny.rr.com>
Subject: Re: [patch] tracing: Remove an unneeded check
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Fri, 20 Apr 2012 10:26:12 -0400
In-Reply-To: <20120420140348.GQ6498@mwanda>
References: <20120420063145.GA22649@elgon.mountain>
	 <1334929881.28106.77.camel@gandalf.stny.rr.com>
	 <20120420140348.GQ6498@mwanda>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 17:03 +0300, Dan Carpenter wrote:
> On Fri, Apr 20, 2012 at 09:51:21AM -0400, Steven Rostedt wrote:
> > On Fri, 2012-04-20 at 09:31 +0300, Dan Carpenter wrote:
> > > memcpy() returns a pointer to "bug".  Hopefully, it's not NULL here or
> > > we would already have Oopsed.
> > 
> > You're right that the ret is useless, and the real bug was already fixed
> > (the possibility that buf could be an invalid pointer).
> > 
> > Not only is this needed, but also get rid of the ret < 0 check in
> > tracing_splice_read_pipe().
> > 
> 
> We still return -EBUSY so we need the check.

Hmm, you're right. I need to take a deeper look at this code. It looks
like it can be cleaned up a bit more (the splice code).

OK, your patch is good as is. I'll add it in my 3.5 queue, and add a
mental note to look at this code again.

Thanks,

-- Steve


