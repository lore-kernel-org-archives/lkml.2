Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0FGSgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:36:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53476 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0FGSgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:36:50 -0400
To: Kees Cook <kees.cook@canonical.com>
Cc: Valdis.Kletnieks@vt.edu, Dave Young <hidave.darkstar@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, tytso@mit.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20100603080158.GE4971@outflux.net>
	<m11vcnlw9j.fsf@fess.ebiederm.org> <20100603210051.GD4714@outflux.net>
	<6305.1275927536@localhost> <20100607164257.GD6839@outflux.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 07 Jun 2010 11:36:29 -0700
In-Reply-To: <20100607164257.GD6839@outflux.net> (Kees Cook's message of "Mon\, 7 Jun 2010 09\:42\:57 -0700")
Message-ID: <m1631ug05u.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 512 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <kees.cook@canonical.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v6] fs: allow protected cross-uid sticky symlinks
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees.cook@canonical.com> writes:

> On Mon, Jun 07, 2010 at 12:18:56PM -0400, Valdis.Kletnieks@vt.edu wrote:
>> On Thu, 03 Jun 2010 14:00:51 PDT, Kees Cook said:
>> > On Thu, Jun 03, 2010 at 01:02:48PM -0700, Eric W. Biederman wrote:
>> > > Kees Cook <kees.cook@canonical.com> writes:
>> > > > A long-standing class of security issues is the symlink-based
>> > > > time-of-check-time-of-use race, most commonly seen in world-writable
>> > > > directories like /tmp. The common method of exploitation of this flaw
>> > > 
>> > > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> > > 
>> > > This approach to fix the problem to of /tmp looks to me like it
>> > > will have the opposite effect.  I think this patch will encourage
>> > > more badly written applications.
>> > 
>> > How to safely deal with /tmp has been well understood for well over
>> > a decade.  I don't think this change would "encourage" poor code.
>> 
>> The fact that you're proposing this patch a decade after we "well understood"
>> the problem should suggest that it *will* encourage poor code, as the same
>> programmers who don't currently get it right (and are thus the targets of your
>> patch) will quite likely just say "Oh, I saw a patch for that, I don't have to
>> try to do it right..."
>
> This objection and its rebuttal are entirely conjecture and I don't think
> it matters since we can never know the objective truth about the education
> or motivation of nameless coders. 

But we can know about distributions.

I see a patch put forward with the argument that it solves all the
problems of /tmp.  The patch does not actually solve all of the
problems of /tmp but more refined claims have not been made.

With the existence of that patch I see no interest in actually solving
the slightly more challenging problem at the distribution level of
unnecessary sharing in /tmp because a handful of uses of /tmp will
have to be fixed.

> That said, I would assume that anyone
> well-educated enough about /tmp races to think "oh I saw a kernel patch
> for that" was either going to get it right to begin with or was going to
> ignore best practices anyway.  The issue is more about the people that
> just don't think about it at all.  I would argue that people are still
> doing it, for over a decade, when it's still vulnerable, is evidence
> that it is not something that will improve.

Furthermore making it impossible to exploit the races with symlinks
(the best your patch can do).  Is not going to make the races impossible
to exploit by placing a different file in place of the one to be
created, or using hard links instead of symlinks.

So I would be surprised if after just your patch a system is actually
more secure from attack, once the attackers notice the change.

Eric
