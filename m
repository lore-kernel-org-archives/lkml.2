Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1I0Unz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:43:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1I0Uny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:43:54 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=nYxVPzDsqTAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=x77DCSsq2-aAeOrOkk0A:9 a=PUjeQqilurYA:10 a=Qdi1pGxtxa15EKAP:21 a=Uzhjlar3dUlqi9DW:21 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH v1 1/2] PM/runtime: introduce trace points for tracing
 rpm_* functions
From: Steven Rostedt <rostedt@goodmis.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tom.leiming@gmail.com, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com,
        Ming Lei <ming.lei@canonical.com>
Date: Tue, 27 Sep 2011 16:43:52 -0400
In-Reply-To: <201109272236.03683.rjw@sisk.pl>
References: <1317118338-4040-1-git-send-email-tom.leiming@gmail.com>
	 <201109272229.23250.rjw@sisk.pl>
	 <1317155512.26514.36.camel@gandalf.stny.rr.com>
	 <201109272236.03683.rjw@sisk.pl>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317156234.26514.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 22:36 +0200, Rafael J. Wysocki wrote:

> > 	TP_printk("%pS:%s ret=%d", (void *)__entry->ip, __get_str(name),
> > 		__entry->ret)
> > 
> > try that.
> 
> Well, that certainly will work, but is it the right fix?

Hehe, yes!  The pS means to take a pointer and return the string version
of the address. Like "schedule+0x3a". __entry->ip is the address of the
function that called it __THIS_IP__ but we want to convert that into a
string name.

We use ip because both perf and trace-cmd should be smart enough to
parse it too. As they both store the kallsyms into the data file.

The (void *) is used because pS wants a pointer, and we stored the
address as an unsigned long.

-- Steve


