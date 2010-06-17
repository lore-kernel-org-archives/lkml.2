Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab0FQUpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:45:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42907 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760694Ab0FQUpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:45:20 -0400
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-doc@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
       "Serge E. Hallyn" <serge@hallyn.com>
References: <20100616221833.GM24749@outflux.net>
	<m1hbl1eta6.fsf@fess.ebiederm.org>
	<20100617165940.GU24749@outflux.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 17 Jun 2010 13:45:02 -0700
In-Reply-To: <20100617165940.GU24749@outflux.net> (Kees Cook's message of "Thu\, 17 Jun 2010 09\:59\:40 -0700")
Message-ID: <m1typ175ip.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: kees.cook@canonical.com, serge@hallyn.com, containers@lists.osdl.org, linux-doc@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu, dhowells@redhat.com, hpa@zytor.com, oleg@redhat.com, roland@redhat.com, schwidefsky@de.ibm.com, hidave.darkstar@gmail.com, jkosina@suse.cz, akpm@linux-foundation.org, rdunlap@xenotime.net, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Kees Cook <kees.cook@canonical.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees.cook@canonical.com> writes:

> Hi,
>
> On Thu, Jun 17, 2010 at 05:29:53AM -0700, Eric W. Biederman wrote:
>> Kees Cook <kees.cook@canonical.com> writes:
>> > running state of any of their processes. For example, if one application
>> > (e.g. Pidgin) was compromised, it would be possible for an attacker to
>> > attach to other running processes (e.g. Firefox, SSH sessions, GPG agent,
>> > etc) to extract additional credentials and continue to expand the scope
>> > of their attack without resorting to user-assisted phishing.
>> 
>> This is ineffective.  As an attacker after I gain access to a users
>> system on ubuntu I can wait around until a package gets an update,
>> and then run sudo and gain the power to do whatever I want.
>
> I doesn't stop phishing, correct.  But it does stop immediate expansion of
> an attack using already-existing credentials.

sudo last I checked caches your password for a couple of seconds.
So if you can probe the system to see when those couple of seconds
are.


>> Either that or I can inject something nasty into the suid pulse-audio.
>
> Hmm?
>
> $ ls -la /usr/bin/pulseaudio
> -rwxr-xr-x 1 root root 71712 2010-06-10 11:59 /usr/bin/pulseaudio
>
> But I take your meaning to be "can still exploit other vulnerabilities".
> That'll always be true, but that's why I'm looking to make the attack
> surface smaller.

Yes.  Apparently pulseaudio has been fixed recently.


>> I tell you what.  If you really want something effective, help Serge
>> and I finish getting the cross namespace issues fixed for the user
>> namespace.  When complete, it will possible for an unprivileged process
>> to create a new one, and since kernel capabilities along with everything
>> else will be local to it, running pidgin, or firefox, or another network
>> facing potentially buggy application in such a namespace will ensure that
>> even if the process is compromised it won't have privileges to ptrace another
>> process or do much else on the system.
>
> It sounds pretty good, but isolating desktop applications is no simple
> task.  They tend to like to have free reign over a user's entire home
> directory.  But I think that's a bit of a tangent.  That said, I'd like to
> know more; where can I find details?

The archives of the containers list.
https://lists.linux-foundation.org/pipermail/containers/ or just
looking.

> I'm all for better separations.  In fact, I'd like to see /proc/sys using
> caps instead of DAC so that containers mounting /proc can't fiddle with the
> entire system.  Has anyone done anything with this?  It seems like it's
> only seen sporadic attention (e.g. my patch to test CAP_SYS_RAWIO for
> changing mmap_min_addr).

Ugh. CAP_SYS_RAWIO????  That certainly does not feel like the proper
capability there.   Which is among the reason I'm not a particular
fan of capabilities.

> I would assume there are others that need a similar protection?

Let me quickly summarize the plan.  The current implementation of the
user_namespace is not much more than a place holder for what should be
implemented.  We may want to rename the user_namespace to the security
credentials namespace when we are done.

All uids, gids, capabilities comparisons should change from.
if ( uid1 == uid2 ) to if ((user_ns1 == user_ns2) && uid1 == uid2).

Somewhere Serge has a git tree where he started making the capabilities
tests user_namespace local.  Which means that when you create a process
that does not share the current user_namespace you will get a full
set of capabilities relative to the current user_namespace.

The tricky bits are:
- Working through the vfs logic, so that filesystems can be aware
  of multiple user namespaces and can do what best suits them when
  presented with a DAC security test.

  proc will need to become uid namespace aware, different files
  will become user namespace aware.

  Things like /proc/sys/ will be default stay in the same user_namespace
  and root in other user namespaces will only get world permissions when
  accessing files.

- Correctly implementing and using ns_capable.  Which makes the capabilities
  caparison hierarchical.  A few key capability comparisons like CAP_NET_ADMIN
  will gradually be switched from a global capability comparison to a local one.

  If you are inside a user_namespace your capabilities will only be
  good for manipulating other objects (like the network namespace)
  that you have created after you entered the user namespace, other
  capability checks will fail because they will require the global
  capability namespace.

  The cute detail is that if you are not in a user namespace but are
  the creator of that user_namespace you will be treated for the purposes
  of security checks as having all capabilities that user_namespace
  posses.  Which will allow important things like the ability to kill
  your children in a child user_namespace.

Eric

