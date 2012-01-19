Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2ASXLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 18:11:41 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52684 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2ASXLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 18:11:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry v7
References: <20120119155112.GF31379@moon> <20120119174742.GD32568@moon>
	<20120119175700.GA19627@redhat.com> <20120119180951.GI31379@moon>
Date: Thu, 19 Jan 2012 15:14:05 -0800
In-Reply-To: <20120119180951.GI31379@moon> (Cyrill Gorcunov's message of "Thu,
	19 Jan 2012 22:09:51 +0400")
Message-ID: <m1ty3r1e0y.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/rof7DuOCdiWmoHjfKL8DBrcjK+HO2j9o=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Thu, Jan 19, 2012 at 06:57:00PM +0100, Oleg Nesterov wrote:
>> On 01/19, Cyrill Gorcunov wrote:
>> >
>> > On Thu, Jan 19, 2012 at 07:51:12PM +0400, Cyrill Gorcunov wrote:
>> > > If it's needed I can wrap all this with CONFIG_CHECKPOINT_RESTORE, should I?
>> > >
>> > > ---
>> >
>> > Oleg, if only I'm not missing something obvious you meant handling like below?
>> 
>> Yes, but...
>> 
>> > +struct proc_pid_children_iter {
>> > +	struct pid_namespace *pid_ns;
>> > +	struct pid *parent_pid;
>> > +};
>> 
>> you forgot to remove this definition.
>> 
>
> No, I rather forgot to quilt refresh :)
>
>> > +static int children_seq_show(struct seq_file *seq, void *v)
>> > +{
>> > +	struct inode *inode = seq->private;
>> > +	unsigned long pid;
>> > +
>> > +	pid = (unsigned long)pid_nr_ns(v, inode->i_sb->s_fs_info);
>> > +	return seq_printf(seq, " %lu", pid);
>> > +}
>> 
>> just noticed... why unsigned long and %lu? afaics pid_t/%d should work
>> without any typecasts.
>> 
>
> I'm not sure how important it is, but Andrew mentioned in one of email
> that we might be moving from pid_t from int to long one day (which of
> course will require extreme huge work on checking code where int->long
> transition might cause problems). So I thought why should I wait then?
>
> [ Andrew, am I correct? ]

It is going to take a lot to get to a > 32bit pid value.  I would not
worry about it today unless there is some 64bit arch somewhere that defines
pid_t as long.

Eric
