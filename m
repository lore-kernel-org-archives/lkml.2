Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab2CLTKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:10:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53327 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab2CLTJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:09:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>,
        Stephen Wilson <wilsons@start.ca>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Date: Mon, 12 Mar 2012 12:13:15 -0700
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> (Djalal
	Harouni's message of "Sun, 11 Mar 2012 00:25:10 +0100")
Message-ID: <m1pqchocok.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19zQAj+8D8fmMwWv4eibXsCLNqlKRM4iyA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Djalal Harouni <tixxdz@opendz.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 0/9] proc: protect /proc/<pid>/* files across execve
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Djalal Harouni <tixxdz@opendz.org> writes:

> Procfs files and other important objects may contain sensitive information
> which must not be seen, inherited or processed across execve.

So I am dense.  /proc/<pid>/mem was special in that it uses a different
set of checks than other files, and to do those access checks
/proc/<pid>/mem needed to look at exec_id.

For all of the access checks that are not written in that silly way.
What is wrong with ptrace_may_access run at every read/write of a file?

We redo all of the permission checks every time so that should avoid
races.

I really think you are trying to solve something that is not broken.
Certainly I could not see your argument for why anything but
/proc/<pid>/mem needs attention.

Eric
