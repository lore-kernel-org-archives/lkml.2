Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab0FRNvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:51:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37364 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab0FRNvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:51:09 -0400
To: Theodore Tso <tytso@MIT.EDU>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kees Cook <kees.cook@canonical.com>,
       Randy Dunlap <rdunlap@xenotime.net>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-doc@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
References: <20100616221833.GM24749@outflux.net>
	<20100617000120.13071be8@lxorguk.ukuu.org.uk>
	<20100616232230.GP24749@outflux.net>
	<alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
	<20100617170453.GV24749@outflux.net>
	<20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
	<20100617140630.c6ced27a.rdunlap@xenotime.net>
	<20100617221815.68ce30c5@lxorguk.ukuu.org.uk>
	<20100617215105.GB24749@outflux.net>
	<20100617233054.330256cf@lxorguk.ukuu.org.uk>
	<4C1AE3A8.2020104@schaufler-ca.com>
	<E1FEE555-566E-4698-8FD8-240076A4F850@mit.edu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 18 Jun 2010 06:50:21 -0700
In-Reply-To: <E1FEE555-566E-4698-8FD8-240076A4F850@mit.edu> (Theodore Tso's message of "Fri\, 18 Jun 2010 06\:54\:57 -0400")
Message-ID: <m1wrtwwiua.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: tytso@MIT.EDU, linux-security-module@vger.kernel.org, dwalsh@redhat.com, sds@tycho.nsa.gov, linux-doc@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu, dhowells@redhat.com, hpa@zytor.com, oleg@redhat.com, roland@redhat.com, schwidefsky@de.ibm.com, hidave.darkstar@gmail.com, jkosina@suse.cz, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jmorris@namei.org, rdunlap@xenotime.net, kees.cook@canonical.com, alan@lxorguk.ukuu.org.uk, casey@schaufler-ca.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Theodore Tso <tytso@MIT.EDU>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@MIT.EDU> writes:

> i think we really need to have stacked LSM's, because there is a large set
> of people who will never use SELinux.  Every few years, I take another 
> look at SELinux, my head explodes with the (IMHO unneeded complexity),
> and I go away again...
>
> Yet I would really like a number of features such as this ptrace scope idea ---
> which I think is a useful feature, and it may be that stacking is the only
> way we can resolve this debate.   The SELinux people will never believe that
> their system is too complicated, and I don't like using things that are impossible
> for me to understand or configure, and that doesn't seem likely to change anytime
> in the near future.
>
> I mean, even IPSEC RFC's are easier for me to understand, and that's saying
> a lot...


If anyone is going to work on this let me make a concrete suggestion.
Let's aim at not stacked lsm's but chained lsm's, and put the chaining
logic in the lsm core.

The core difficulty appears to be how do you multiplex the security pointers
on various objects out there.

My wishlist has this working so that I can logically have a local security
policy in a container, restricted by the global policy but with additional
restrictions.

Eric
