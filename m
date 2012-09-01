Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2IADb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 23:31:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60647 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab2IADb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 23:31:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Paris <eparis@parisplace.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kees Cook <keescook@chromium.org>,
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
Date: Fri, 31 Aug 2012 20:31:46 -0700
In-Reply-To: <CACLa4ptpGJ7YDTqmOvtHq_Ts9f72SBV6Q_HDDw1OebhxVOzU9w@mail.gmail.com>
	(Eric Paris's message of "Fri, 31 Aug 2012 20:03:46 -0700")
Message-ID: <87627ye7vh.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18eh6uLopZGwsJF/cl7nSTFAC8EC9hxvuU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eric Paris <eparis@parisplace.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] security: unconditionally call Yama
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@parisplace.org> writes:

> On Fri, Aug 31, 2012 at 4:59 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>
>> From a overal kernel maintenance and use perspective the unconditional
>> enablement is a pain.
>>
>> We long ago established the principle that compiling additional code
>> into the kernel should not change the semenatics of the kernel.
>>
>> So this code needs to come with a command line or sysctl on/off switch
>> not an unconditional enable.
>
> Your argument makes zero sense.  If I decide to build new code, that
> new code can do something.

Sure but it should not change the existing behavior without being
configured to.

This comes out of the practice that kernels that need to support a
wide variety of use cases enable everything by default.

Having to vet kernel options for will this make my kernel do strange
things if this option is enabled, massively increase the burden on
people building and supporting kernels.

> It happens all the time.  If you don't like Yama, don't build Yama.
> If you don't like the only thing that Yama does (it only implements
> one protection), disable that protection from sysctl.  I don't get it.

Having taken the time now to vet Yama ugh.  Having Yama enabled if
simply compiled in breaks using gdb to attach to a process runing
in another window.

Talk about something you don't want to surprise someone with.

It is very much not ok to have that be enabled by default just
because it happens to be compiled in.

Eric
