Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab2HXACv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 20:02:51 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:45689 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HXACr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 20:02:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lennart Poettering <lpoetter@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, aris@redhat.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
	<20120816174454.087507415@napanee.usersys.redhat.com>
	<20120816200006.GG24861@google.com> <50340110.50607@redhat.com>
Date: Thu, 23 Aug 2012 17:02:34 -0700
In-Reply-To: <50340110.50607@redhat.com> (Lennart Poettering's message of
	"Tue, 21 Aug 2012 23:43:44 +0200")
Message-ID: <87ipc9kvhh.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18OkpU4Ps8Ag2kHP8KkV8IuhPlBNR8B+DA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1247]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lennart Poettering <lpoetter@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Poettering <lpoetter@redhat.com> writes:

> Heya,
>
> (sorry for the late reply)
>
> On 16.08.2012 22:00, Tejun Heo wrote:
>> On Thu, Aug 16, 2012 at 01:44:56PM -0400, aris@redhat.com wrote:
>
>>>> Attaching meta information to services, in an easily discoverable
>>>> way. For example, in systemd we create one cgroup for each service, and
>>>> could then store data like the main pid of the specific service as an
>>>> xattr on the cgroup itself. That way we'd have almost all service state
>>>> in the cgroupfs, which would make it possible to terminate systemd and
>>>> later restart it without losing any state information. But there's more:
>>>> for example, some very peculiar services cannot be terminated on
>>>> shutdown (i.e. fakeraid DM stuff) and it would be really nice if the
>>>> services in question could just mark that on their cgroup, by setting an
>>>> xattr. On the more desktopy side of things there are other
>>>> possibilities: for example there are plans defining what an application
>>>> is along the lines of a cgroup (i.e. an app being a collection of
>>>> processes). With xattrs one could then attach an icon or human readable
>>>> program name on the cgroup.
>>>>
>>>> The key idea is that this would allow attaching runtime meta information
>>>> to cgroups and everything they model (services, apps, vms), that doesn't
>>>> need any complex userspace infrastructure, has good access control
>>>> (i.e. because the file system enforces that anyway, and there's the
>>>> "trusted." xattr namespace), notifications (inotify), and can easily be
>>>> shared among applications.
>
>>
>> I'm not against this but unsure whether using kmem is enough for the
>> suggested use case.  Lennart, would this suit systemd?  How much
>> metadata are we talking about?
>
> Just small things, like values, PIDs, i.e. a few 100 bytes or so per cgroup
> should be more than sufficient for our needs.

I have a really silly question.  Why is storing these things in xattrs
in a cgroup better than simply implementing a file in a cgroup?

It is most definitely going to be a real pain to discover as unix tools
do not support xattrs well.

Furthermore I am having nasty visiions that storing pids is going to
start breaking cgroups the way storing pids already breaks futexes.
Which pid namespace is that pid relative to?

Eric
