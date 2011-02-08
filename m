Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab1BHURN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 15:17:13 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60832 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1BHURL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 15:17:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <kees.cook@canonical.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ftp.linux.org.uk>
References: <20110207231416.GD1457@outflux.net>
	<alpine.LRH.2.00.1102081127330.3342@tundra.namei.org>
	<20110208011445.GF1457@outflux.net>
	<alpine.LRH.2.00.1102081437430.3879@tundra.namei.org>
	<20110208042708.GG1457@outflux.net>
Date: Tue, 08 Feb 2011 12:17:05 -0800
In-Reply-To: <20110208042708.GG1457@outflux.net> (Kees Cook's message of "Mon,
	7 Feb 2011 20:27:08 -0800")
Message-ID: <m1ipwu5lj2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18j1Upo706fulP18g/fCs5ofra4Ar0qXmQ=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <kees.cook@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [SECURITY] /proc/$pid/ leaks contents across setuid exec
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees.cook@canonical.com> writes:

> On Tue, Feb 08, 2011 at 02:43:15PM +1100, James Morris wrote:
>> On Mon, 7 Feb 2011, Kees Cook wrote:
>> > Sure, I know about O_CLOEXEC, but this is about protecting the
>> > just-been-execed setuid process from the attacking process that has no
>> > reason to set O_CLOEXEC.
>> > 
>> > Something like this needs to be enforced on the kernel side. I.e. these
>> > file in /proc need to have O_CLOEXEC set in a way that cannot be unset.
>> > 
>> > > Changing the behavior in the core kernel will break userspace.
>> > 
>> > I don't think /proc/$pid/* needs to stay open across execs, does it? Or at
>> > least the non-0444 files should be handled separately.
>> 
>> Actually, this seems like a more general kind of bug in proc rather than a 
>> leaked fd.  Each child task should only see its own /proc/[pid] data.
>
> Right, that's precisely the problem. The unprivileged process can read
> the setuid process's /proc files.

If these are things that we actually care about we should sprinkle in a
few more ptrace_may_access calls into implementations of the relevant
proc files.


Eric
