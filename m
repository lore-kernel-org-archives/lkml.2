Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab2IAEFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 00:05:48 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51493 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2IAEFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 00:05:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@chromium.org>
Cc: Eric Paris <eparis@parisplace.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-security-module@vger.kernel.org
References: <20120831213126.GA19688@www.outflux.net>
	<20120831223908.4aa5574d@pyramind.ukuu.org.uk>
	<CACLa4pv75-HaPEas=aOMySbMm-YdSJZdc6qtNUnTM+Ev2Rp7rg@mail.gmail.com>
	<87ipbyfw9j.fsf@xmission.com>
	<CACLa4ptpGJ7YDTqmOvtHq_Ts9f72SBV6Q_HDDw1OebhxVOzU9w@mail.gmail.com>
	<87627ye7vh.fsf@xmission.com>
	<CAGXu5jKD0MDetYuavSmXjDB3t3cYEkiEoEY-bAMyhFrmTaA6FA@mail.gmail.com>
Date: Fri, 31 Aug 2012 21:05:37 -0700
In-Reply-To: <CAGXu5jKD0MDetYuavSmXjDB3t3cYEkiEoEY-bAMyhFrmTaA6FA@mail.gmail.com>
	(Kees Cook's message of "Fri, 31 Aug 2012 20:42:58 -0700")
Message-ID: <87oblqbd66.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+O/LKs1yORz+4UMrYx67CWFwpY0w7vPfw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] security: unconditionally call Yama
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Fri, Aug 31, 2012 at 8:31 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Eric Paris <eparis@parisplace.org> writes:
>>
>>> On Fri, Aug 31, 2012 at 4:59 PM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>>
>> Having taken the time now to vet Yama ugh.  Having Yama enabled if
>> simply compiled in breaks using gdb to attach to a process runing
>> in another window.
>>
>> Talk about something you don't want to surprise someone with.
>>
>> It is very much not ok to have that be enabled by default just
>> because it happens to be compiled in.
>
> I think it is better to look at the kernel's defaults from the
> perspective of the user, not the developer.

It is best to look at the kernel defaults with respect to regressions
from previous behavior.  And YAMA uncondionally enabled and restricting
ptrace when compiled simply in, is most definitely a regression from
previous behavior.  And it is most definitely is not a behavior no
one cares about.

> If we only looked to the
> developer, we'd turn on all the debugging by default. No end user
> wants that. It's much easier for a developer to twiddle configs and
> sysctls.

If you want to change the default behaior of the kernel provide a
config option that is specifically about changing the behavior.

But changing the behavior by default and compiling in the code
are two very very different things, and they should continue to be.

> Given that several distros use (or want to use) Yama, I think that's
> reason enough for this. I think it's important for us to take a
> practical approach here, and having the big LSMs each hook Yama
> instead of doing this in a single global place will make it needlessly
> duplicated code.

People wanting to use a feature is certainly an argument for figuring
out how to do it well.  It most definitely is not a reason for randomly
breaking long established kernel features when they happen to run
make oldconfig and telling other people to just deal with it.

Eric
