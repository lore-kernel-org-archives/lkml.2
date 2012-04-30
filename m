Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab2D3Csi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 22:48:38 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:52787 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab2D3Csg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 22:48:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, viro@zeniv.linux.org.uk,
        fweisbec@gmail.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@ghostprotocols.net, james.l.morris@oracle.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>
References: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
	<m1haw33q35.fsf@fess.ebiederm.org>
	<CA+1xoqfX3hc7FP+8_9sn_mt4_WHkVfqTiPnE79Brs_kAfAFPCQ@mail.gmail.com>
	<1335708011.28106.245.camel@gandalf.stny.rr.com>
	<CA+1xoqfQczszejX8_9hj1ntFS0SpNhErgYSVPL-DxH2WG67JTw@mail.gmail.com>
	<1335729458.28106.247.camel@gandalf.stny.rr.com>
Date: Sun, 29 Apr 2012 19:52:37 -0700
In-Reply-To: <1335729458.28106.247.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Sun, 29 Apr 2012 15:57:38 -0400")
Message-ID: <m1r4v6ylqi.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX188yLkELTVNutohFuWIfFsNw2/MnB0A/HM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 01/14] sysctl: provide callback for write into ctl_table entry
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Sun, 2012-04-29 at 16:14 +0200, Sasha Levin wrote:
>
>> A fix for that could be having the sysctl modifying a different var,
>> and having ftrace_enabled from that under a lock, but I'm not sure if
>> it's worth the work for the cleanup.
>
> That was my original plan, but it seemed too much of a hassle than it
> was worth, as I needed to make sure the mirrored variable was in sync
> with ftrace_enabled, otherwise it could be confusing when ftrace was not
> working but sysctl showed ftrace set to 1.

I don't see the problem you are trying to solve with your patches.

What I do see is you have ignored one of the biggest problem with the
current sysctl interface in that it is not easy to plug in your own code
in the cases you need to before an update is made. (Locks permission
checks, etc).

You have also bloated struct ctl_table for no apparent reason.

This current crop of patches was just sloppy.  You showed a poor
choice of function names and did not preserve necessary invariants
when changing the code.  It looks like you exchanged something that
was a bit ugly for something that straight out encourages broken
behavior. 

So I respectfully suggest you go back to the drawing board and figure
out a solution that makes this class of function much easier to write
in a bug free manner.

Eric
