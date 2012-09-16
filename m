Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2IPOmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 10:42:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59938 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2IPOmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 10:42:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Aristeu Rozanski <aris@ruivo.org>, Neil Horman <nhorman@tuxdriver.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20120913205827.GO7677@google.com>
	<20120914183641.GA2191@cathedrallabs.org>
	<1347783557.2463.1.camel@dabdike.int.hansenpartnership.com>
Date: Sun, 16 Sep 2012 07:41:48 -0700
In-Reply-To: <1347783557.2463.1.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Sun, 16 Sep 2012 09:19:17 +0100")
Message-ID: <87boh6owr7.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18iV7j/7/lP1FkaXyfzd0NchVHd0oc9UfM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;James Bottomley <James.Bottomley@HansenPartnership.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC] cgroup TODOs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Fri, 2012-09-14 at 14:36 -0400, Aristeu Rozanski wrote:
>> also, heard about the desire of having a device namespace instead with
>> support for translation ("sda" -> "sdf"). If anyone see immediate use for
>> this please let me know.
>
> That sounds like a really bad idea to me.  We've spent ages training
> users that the actual sd<x> name of their device doesn't matter and they
> should use UUIDs or WWNs instead ... why should they now care inside
> containers?

The goal is not to introduce new the cases where people care but to
handle cases where people do care.

The biggest practical case of interest that I know of is if

stat /home/myinteresintfile Device: 806h	Inode: 7460974
migration
stat /home/myinteresintfile Device: 732h	Inode: 7460974

And an unchanging file looks like it has just become a totally different
file on a totally different filesystem.

I think even things like git status will care.  Although how much git
cares about the device number I don't know.  I do know rsyncing a git
tree to another directory is enough to give git conniption fits.


So this is really about device management and handling the horrible
things that real user space does.  There is also the case that
there are some very strong ties between the names of device nodes
the names of sysfs files.  Strong enough ties that I think you can
strongly confuse userspace if you just happen to rename a device node.


And ultimately this conversation is about the fact that none of this
has been interesting enough in practice to figure out what really needs
to be done to manage devices in containers.


You can read the other thread if you want details.  But right now it
looks to me like the right answer is going to be building some userspace
software and totally deprecating the device control group.

Eric
