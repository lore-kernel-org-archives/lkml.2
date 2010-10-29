Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab0J2URQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:17:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34351 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757364Ab0J2URO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:17:14 -0400
Message-ID: <4CCB2B7B.6020002@zytor.com>
Date: Fri, 29 Oct 2010 13:15:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Daney <ddaney@caviumnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        rth@redhat.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
References: <cover.1288212485.git.jbaron@redhat.com>	 <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>	 <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>	 <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com>	 <20101028201112.GA4792@redhat.com> <20101029063450.GE29463@elte.hu>	 <1288354687.18238.433.camel@gandalf.stny.rr.com>	 <20101029122230.GA25663@elte.hu>	 <1288356418.18238.454.camel@gandalf.stny.rr.com>	 <20101029133524.GA23916@Krystal>	 <1288369108.29632.1.camel@gandalf.stny.rr.com>	 <4CCB01D1.2050004@caviumnetworks.com> <1288373582.29632.3.camel@gandalf.stny.rr.com>
In-Reply-To: <1288373582.29632.3.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2010 10:33 AM, Steven Rostedt wrote:
>>
>> Should this knowledge be builtin to the jump label enabling calculus?
> 
> No, because we can't trust versions. We never know what home grown gcc a
> kernel developer is using (and what has been backported or not). Thus
> the only option is to have a builtin test we can do at compile time to
> determine if the bug exists or not and decide then.
> 
> Note, I'm currently running my last set of patches through ktest. When
> it finishes (presumably with no issues), I'll post a pull request.
> 

I disagree with that assessment.

We know that if version >= 4.5.2 the problem has been fixed, and that
for earlier versions we can't know if it's there, so just disable it for
gcc < 4.5.2.  The fix might have been backported, but it's not a big
deal if the users of backported compilers don't see the full benefit --
it's only a problem during a limited time window anyway.

Admittedly it would be nice to have a header file or even a
configuration file where the gcc version is tested and workarounds are
centralized; then the backporters could put their own overrides in there.

	-hpa
