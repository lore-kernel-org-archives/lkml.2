Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab0DSVJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:09:32 -0400
Received: from mail-va3.bigfish.com ([216.32.180.114]:60904 "EHLO
	mail184-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018Ab0DSVJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:09:20 -0400
X-Greylist: delayed 1803 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 17:09:19 EDT
X-SpamScore: -27
X-BigFish: VPS-27(zz1432P98dN936eM9371Pzz1202hz4fhzz2fh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.74;Service: EHS
Message-ID: <4BCCBF6D.3030105@am.sony.com>
Date: Mon, 19 Apr 2010 13:39:09 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Chase Douglas <chase.douglas@canonical.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: request to add trace off and trace on with events
References: <1271707444.10448.12.camel@gandalf.stny.rr.com>
In-Reply-To: <1271707444.10448.12.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 01:04 PM, Steven Rostedt wrote:
> Hi Tom,
> 
> Could you add a way to do a call to tracing_on() or tracing_off() via
> the filters. I would like to do something like:
> 
> 
> echo 'if (pid == 1234) traceoff' > events/sched/sched_wakeup/filter
> 
> Where, if the sched_wakeup event is hit with pid == 1234 it will turn
> tracing off.

Just a comment on the nomenclature.  In KFT I called
things like this "triggers".  I'm not sure what other
tracing systems call them.  I'm a little worried about
overloading the filtering abstraction with trigger
semantics.  (I like the idea of triggers, but it might
be better to control them with another pseudo-file for
clarity.)

I suppose both are a form of conditional execution.
Filtering has an implicit action of either 'trace this'
or 'don't trace this', while triggering usually has
an action, often explicit, to start or stop tracing.
However, since they both use the conditional testing,
it might be a pain to reproduce this code for a different
pseudo-file.

Just my 2 cents.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Network Entertainment
=============================

