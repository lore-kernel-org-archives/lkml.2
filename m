Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1CNPVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:21:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37629 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1CNPU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:20:59 -0400
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=u2_5ZAQ68KIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=hhVRHlb3maMlkWtYmjUA:9 a=Ww5eiKNGota02vhSqQ6d5vb8-P8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] tracing - putting cond_resched into tace_pipe loop
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110314150746.GA4453@jolsa.brq.redhat.com>
References: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
	 <1299970786-8075-3-git-send-email-jolsa@redhat.com>
	 <20110313145811.GA30558@redhat.com>
	 <1300111651.9910.87.camel@gandalf.stny.rr.com>
	 <20110314141853.GB1936@jolsa.brq.redhat.com>
	 <1300112926.9910.100.camel@gandalf.stny.rr.com>
	 <20110314150746.GA4453@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Mar 2011 11:20:57 -0400
Message-ID: <1300116057.9910.106.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 16:07 +0100, Jiri Olsa wrote:
> So we get back the the while loop with no data added and with
> TRACE_TYPE_HANDLED return code, which will keep us in the loop.
> 
> Not sure this is bug or feature :)
> 
> 
Most bugs are features ;)

honestly, I'd love to rip out all the "bin", "hex" etc formats as they
are pretty much deprecated.

But as you pointed out that this can keep us in the inner loop, we need
to fix that. I prefer to fix it within the nop print function. Perhaps
we need to fill in something. "type: %d", iter->ent->type ?

-- Steve


