Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab1JHEY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 00:24:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60166 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1JHEYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 00:24:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Matt Helsley <matthltc@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
References: <1317943022.1095.25.camel@mop>
	<20111007074904.GC16723@count0.beaverton.ibm.com>
	<20111007160113.GB14201@tango.0pointer.de>
Date: Fri, 07 Oct 2011 21:24:37 -0700
In-Reply-To: <20111007160113.GB14201@tango.0pointer.de> (Lennart Poettering's
	message of "Fri, 7 Oct 2011 18:01:14 +0200")
Message-ID: <m17h4g2jqy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/yScGR7fLhe5FlhBve/eL+MhqS3NBpd10=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lennart Poettering <mzxreary@0pointer.de>
X-Spam-Relay-Country: **
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99s?= Wish List for Linux
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Poettering <mzxreary@0pointer.de> writes:

> On Fri, 07.10.11 00:49, Matt Helsley (matthltc@us.ibm.com) wrote:
>
>> 
>> On Fri, Oct 07, 2011 at 01:17:02AM +0200, Kay Sievers wrote:
>> 
>> <snip>
>> 
>> > * simple, reliable and future-proof way to detect whether a specific pid
>> > is running in a CLONE_NEWPID container, i.e. not in the root PID
>> > namespace. Currently, there are available a few ugly hacks to detect
>> 
>> Is that precisely what's needed or would it be sufficient to know
>> that the pid is running in a child pid namespace of the current pid
>> namespace? If so, I think this could eventually be done by comparing
>> the inode numbers assigned to /proc/<pid>/ns/pid to those of
>> /proc/1/ns/pid.
>
> I think the most interesting test would be to figure out for a process
> if itself is running in a PID namespace. And for that comparing inodes
> wouldn't work since the namespace process would never get access to the
> inode of the outside init.

Strictly correct answer.  All processes are running in a pid namespace.
I think we can implement that in a libc header.

static inline bool in_pid_namespace(void)
{
        return true;
}

Why does it matter if you are running in something other than the
initial pid namespace?  I expect what you are really after is something
else entirely, and you are asking the wrong question.

Eric
