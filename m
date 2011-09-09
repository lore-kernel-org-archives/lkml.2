Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470Ab1IIQqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab1IIQqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:46:51 -0400
Subject: Re: Why I want PTRACE_O_TRACESTOP option
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 09 Sep 2011 18:46:39 +0200
In-Reply-To: <661eb210adc223ac1eb80777df48b226.squirrel@webmail.greenhost.nl>
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com>
	 <20110909001853.GA29319@htj.dyndns.org>
	 <201109090754.50272.vda.linux@googlemail.com>
	 <93a9bd6624aa6a991d688bfaba766a91.squirrel@webmail.greenhost.nl>
	 <661eb210adc223ac1eb80777df48b226.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1315586801.5036.1.camel@dhcp-25-63.brq.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 15:01 +0200, Indan Zupancic wrote:
> On Fri, September 9, 2011 14:26, Indan Zupancic wrote:
> > Hello,
> >
> > On Fri, September 9, 2011 07:54, Denys Vlasenko wrote:
> >> On Friday 09 September 2011 02:18, Tejun Heo wrote:
> >>> Hello, Denys.
> >>>
> >>> On Thu, Sep 08, 2011 at 06:50:01PM +0200, Denys Vlasenko wrote:
> >>> > Consider what will happen when a next ptrace fix will require
> >>> > a way to change ptrace API at runtime. A new option will likely
> >>> > be introduced, say, PTRACE_O_TRACEPONY, with next available
> >>> > bit position 7, and perhaps some new event will be generated,
> >>> > PTRACE_EVENT_PONY, with value.... yes, it can't be 7,
> >>> > PTRACE_EVENT_STOP took it. So it will probably be 8.
> >>>
> >>> Then, just give it the next matching number.
> >>
> >> My point is that previously, ptrace behavior was modified by setting
> >> options. Why don't we use this mechanism? Why we invent a different
> >> wheel? Ptrace is ugly as-is, why complicate it even further?
> >>
> >> The argument was that SETOPTIONS wasn't suitable for modifying
> >> attach behavior, but this is fixed by "set options on SEIZE"
> >> patch. I don't see why we can't use options mechanist to affect
> >> group-stop behavior now.
> >
> > I totally agree with Denys here.
> >
> > It is very useful to set options atomically at SEIZE time. Having
> > SEIZE set some hidden option implicitly only makes things more
> > confusing and harder to explain what SEIZE does. Please apply Denys'
> > SEIZE API improvements.
> >
> > Another important reason to make PTRACE_O_TRACESTOP an option is
> > because not everyone uses SEIZE: Users using PTRACE_TRACEME can't
> > set this option at all. For those PTRACE_O_TRACESTOP is needed.
> > Using PTRACE_TRACEME is the common case for both strace and gdb.
> 
> PTRACE_O_TRACESTOP only makes sense if it also affects auto-attach
> SIGSTOPS, of course. I don't know if it does. It probably should.

With the patch, it will affect them if it is used in list of options
passed on SEIZE.

-- 
vda


