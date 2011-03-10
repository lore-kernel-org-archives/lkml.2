Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1CJVeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:34:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44152 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1CJVeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:34:23 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=UwRGqXM3h7MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ES1dpH7g7n332EvRqp4A:9 a=XIKhXPkgfNtpJXD6KkJktIuWTGgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: update for .39
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <BLU0-SMTP2489AC44910467F37596A496C80@phx.gbl>
References: <cover.1299702291.git.jbaron@redhat.com>
	 <1299728191.15854.319.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl>
	 <1299771504.15854.347.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP2489AC44910467F37596A496C80@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 16:34:20 -0500
Message-ID: <1299792860.15854.423.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 16:14 -0500, Mathieu Desnoyers wrote:

> > Just insert a long "Reserved" word.
> 
> I agree that this solution can work, but it's only because the
> "object" definition is done in assembly in this case (and not in C, like
> we did for trace event and tracepoints). Padding to power of 2 multiples
> should make the linker happy. There should be a nice comment beside
> these padding elements though.

Rereading what David and even what you wrote just now, I don't think
this is even needed. As you said. The issue with us is that we had
defined structs in C as static which lost all bets. Not to mention,
these structures were not natural word aligned.

The linker should not be adding holes more than natural word alignment.
Why waste space?

-- Steve


