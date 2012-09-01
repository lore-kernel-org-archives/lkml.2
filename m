Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2IADnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 23:43:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60413 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab2IADm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 23:42:58 -0400
MIME-Version: 1.0
In-Reply-To: <87627ye7vh.fsf@xmission.com>
References: <20120831213126.GA19688@www.outflux.net>
	<20120831223908.4aa5574d@pyramind.ukuu.org.uk>
	<CACLa4pv75-HaPEas=aOMySbMm-YdSJZdc6qtNUnTM+Ev2Rp7rg@mail.gmail.com>
	<87ipbyfw9j.fsf@xmission.com>
	<CACLa4ptpGJ7YDTqmOvtHq_Ts9f72SBV6Q_HDDw1OebhxVOzU9w@mail.gmail.com>
	<87627ye7vh.fsf@xmission.com>
Date: Fri, 31 Aug 2012 20:42:58 -0700
X-Google-Sender-Auth: OiVwG0gXobEtF2WjmQ32NwkoT7E
Message-ID: <CAGXu5jKD0MDetYuavSmXjDB3t3cYEkiEoEY-bAMyhFrmTaA6FA@mail.gmail.com>
Subject: Re: [PATCH] security: unconditionally call Yama
From: Kees Cook <keescook@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Paris <eparis@parisplace.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 8:31 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Eric Paris <eparis@parisplace.org> writes:
>
>> On Fri, Aug 31, 2012 at 4:59 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>
>>> From a overal kernel maintenance and use perspective the unconditional
>>> enablement is a pain.
>>>
>>> We long ago established the principle that compiling additional code
>>> into the kernel should not change the semenatics of the kernel.
>>>
>>> So this code needs to come with a command line or sysctl on/off switch
>>> not an unconditional enable.
>>
>> Your argument makes zero sense.  If I decide to build new code, that
>> new code can do something.
>
> Sure but it should not change the existing behavior without being
> configured to.
>
> This comes out of the practice that kernels that need to support a
> wide variety of use cases enable everything by default.
>
> Having to vet kernel options for will this make my kernel do strange
> things if this option is enabled, massively increase the burden on
> people building and supporting kernels.
>
>> It happens all the time.  If you don't like Yama, don't build Yama.
>> If you don't like the only thing that Yama does (it only implements
>> one protection), disable that protection from sysctl.  I don't get it.
>
> Having taken the time now to vet Yama ugh.  Having Yama enabled if
> simply compiled in breaks using gdb to attach to a process runing
> in another window.
>
> Talk about something you don't want to surprise someone with.
>
> It is very much not ok to have that be enabled by default just
> because it happens to be compiled in.

I think it is better to look at the kernel's defaults from the
perspective of the user, not the developer. If we only looked to the
developer, we'd turn on all the debugging by default. No end user
wants that. It's much easier for a developer to twiddle configs and
sysctls.

Given that several distros use (or want to use) Yama, I think that's
reason enough for this. I think it's important for us to take a
practical approach here, and having the big LSMs each hook Yama
instead of doing this in a single global place will make it needlessly
duplicated code.

-Kees

-- 
Kees Cook
Chrome OS Security
