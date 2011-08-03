Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1HCSIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:08:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35432 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab1HCSIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:08:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        James Morris <jmorris@namei.org>, neilb@suse.de
References: <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
	<BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
	<m1hb88e3qs.fsf@fess.ebiederm.org>
	<BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com>
	<20110608151732.2b321b9a.akpm@linux-foundation.org>
	<BANLkTinXwE0K5nJ649rhNxN06KvwLNDeCA@mail.gmail.com>
	<1307981153.1449.19.camel@mop>
	<CAMOw1v5veDqE+=gbNBn3juXHOOp764d7F20XtwUJXZoBW45zyg@mail.gmail.com>
	<CAPXgP12sxLmPXzXx_Qgf=JakmiZcuiMGmMKB8RG4sFU_U5f=jg@mail.gmail.com>
	<20110802231641.GA2598@suse.de> <20110803011250.GA27227@vigoh>
	<m18vra7rzs.fsf@fess.ebiederm.org>
	<CAMOw1v6ZJHDSMzck0YEjRbJmnoyPcrLmN4+-R5D7YRF-G=Lgrw@mail.gmail.com>
Date: Wed, 03 Aug 2011 11:08:01 -0700
In-Reply-To: <CAMOw1v6ZJHDSMzck0YEjRbJmnoyPcrLmN4+-R5D7YRF-G=Lgrw@mail.gmail.com>
	(Lucas De Marchi's message of "Wed, 3 Aug 2011 10:17:12 -0300")
Message-ID: <m1r5521i7y.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19BPatWljeW6PL95R4S/YhP5Nph32a+VrQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2433]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucas De Marchi <lucas.demarchi@profusion.mobi>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysctl: add support for poll()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:

> On Wed, Aug 3, 2011 at 6:40 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
>>
>> > @@ -176,6 +177,43 @@ static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
>> >       return proc_sys_call_handler(filp, (void __user *)buf, count, ppos, 1);
>> >  }
>> >
>> > +static int proc_sys_open(struct inode *inode, struct file *filp)
>> > +{
>> > +     struct ctl_table *table = PROC_I(inode)->sysctl_entry;
>> > +
>> > +     if (table->poll) {
>> > +             unsigned long event = atomic_read(&table->poll->event);
>> > +
>> > +             filp->private_data = (void *)event;
>>
>> It would be nice if there was something that abstracted
>> filp->private_data accesses so they were type safe, and
>> clear what you were doing.
>
> private_data is used everywhere to save this private-per-inode data.
> Here it's just the current number of events. It doesn't matter the
> number, as long as when we wake up in the poll() we can compare these
> numbers.

It sure matters in code readablity if you have to cast the value
every time.  A pair of light wrappers around filp->private_data
that abstracts away the cast would be useful.

>> > +static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
>> > +{
>> > +     struct inode *inode = filp->f_path.dentry->d_inode;
>> > +     struct ctl_table *table = PROC_I(inode)->sysctl_entry;
>> > +     unsigned long event = (unsigned long)filp->private_data;
>> > +     unsigned int ret = POLLIN | POLLRDNORM;
>>
>> The default return value here must be DEFAULT_POLLMASK otherwise you
>> change the result of poll for every single proc file and in general
>
> This is not true. This patch has nothing to do with proc files and
> will not change their return values. However I did use the same return
> values as used for proc files that support poll (see
> fs/proc/base.c:mounts_poll()

Apologies I meant /proc/sys/ files and it is absolutely true that
you are changing the poll behavior of every sysctl with this change.

/proc/mounts doesn't return writable because it doesn't support
writes.  Most sysctl files support writes and thus should return
writeable.

>> return the wrong values because most sysctls are writable.
>
> For sysctl, there wasn't any poll support so how could I break
> something that didn't exist?

Not true.  There is the generic support of poll that happens
when poll is not implemented.  For a generic file that does
not implement specifically implement poll files return
both readable and writable.

Which ultimately is why we have to use POLLERR | POLLPRI
and not the more obvious values of readable or writable.

>> > +     if (!table->proc_handler)
>> > +             goto out;
>> > +
>> > +     if (!table->poll)
>> > +             goto out;
>> > +
>> > +     poll_wait(filp, &table->poll->wait, wait);
>> > +
>> > +     if (event != atomic_read(&table->poll->event)) {
>> > +             filp->private_data = (void *)(unsigned long)atomic_read(
>> > +                                             &table->poll->event);
>> > +             ret = POLLIN | POLLRDNORM | POLLERR | POLLPRI;
>>
>> Why are you updating the event here instead of when the file is read?
>> Presumably we want until the file is read and people see the new value.
>
> This is to indicate, when we are polling the file , that the file
> should be read again. When the process wake up we compare the filp's
> copy of the event number with the one in table. Since they were the
> same when the file was opened, if they are different now it indicates
> the the file was updated and should be read again.
>
> There's no way to do this in read: we update table->poll->event
> whenever the table entry is changed and when wakening up from
> poll_wait() we compare if these values are the same.

What do you mean there is no way to do this in read?
That is how it is implemented in sysfs and it currently feels more
intuitive.  There might be a semantic reason for not doing it in
read that I am missing but it is certainly technically possible.

>> > @@ -1011,6 +1012,12 @@ extern int proc_do_large_bitmap(struct ctl_table *, int,
>> >   * cover common cases.
>> >   */
>> >
>> > +/* Support for userspace poll() to watch for changes */
>> > +struct ctl_table_poll {
>> > +     atomic_t event;
>> > +     wait_queue_head_t wait;
>> > +};
>>
>> It is a moderately big stretch to think that everything that wants to
>> poll a value under /proc/sys will want to use struct ctl_table_poll.
>
> This is the way we know what processes are polling() this entry (hence
> the wait queue). It's a well known idiom and again maps to the
> existent pollable files in /proc

No.  This is similar but this is not identical to what is done for every
file in proc.  I agree we need something to flag that we are pollable.

>> > @@ -1291,6 +1292,7 @@ SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
>> >               memset(u->domainname + len, 0, sizeof(u->domainname) - len);
>> >               errno = 0;
>> >       }
>> > +     uts_proc_notify(UTS_PROC_DOMAINNAME);
>> >       up_write(&uts_sem);
>> >       return errno;
>> >  }
>> > diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
>> > index a2cd77e..e96b766 100644
>> > --- a/kernel/utsname_sysctl.c
>> > +++ b/kernel/utsname_sysctl.c
>> > @@ -13,6 +13,7 @@
>> >  #include <linux/uts.h>
>> >  #include <linux/utsname.h>
>> >  #include <linux/sysctl.h>
>> > +#include <linux/wait.h>
>> >
>> >  static void *get_uts(ctl_table *table, int write)
>> >  {
>> > @@ -51,12 +52,28 @@ static int proc_do_uts_string(ctl_table *table, int write,
>> >       uts_table.data = get_uts(table, write);
>> >       r = proc_dostring(&uts_table,write,buffer,lenp, ppos);
>> >       put_uts(table, write, uts_table.data);
>> > +
>> > +     if (write) {
>> > +             atomic_inc(&table->poll->event);
>> > +             wake_up_interruptible(&table->poll->wait);
>>
>> Duplicating code again?  Why are you not calling your generic notify?
>
> Duplicating? The uts_proc_notify() was only created so when user calls
> hostname/domainname syscalls we wake up who is polling the
> correspondent sysctl entries.

> Here it's for the generic case in which we write to /proc/sysctl.

Except the routine you have changed isn't for the generic case it
is for a specific set of writes to domainname or hostname.

I agree we need code on the update the value through sysctl path.
However if you are going to go with a generic structure why not
implement a generic function to update that structure.  Especially since
you have two copies of this logic to update the notify logic already.

>> > +static struct ctl_table_poll hostname_poll = {
>> > +     .event          = ATOMIC_INIT(0),
>> > +     .wait           = __WAIT_QUEUE_HEAD_INITIALIZER(hostname_poll.wait),
>> > +};
>> > +
>> > +static struct ctl_table_poll domainname_poll = {
>> > +     .event          = ATOMIC_INIT(0),
>> > +     .wait           = __WAIT_QUEUE_HEAD_INITIALIZER(domainname_poll.wait),
>> > +};
>>
>> No generic initialize for this generic structure?  Instead every user
>> must repeat the initialization?
>
> The wait queues are different, and the ".poll" is set to this. I can't
> see how we could generalize this. Maybe creating a macro
> CTL_TABLE_POLL_DECLARE() or something along the way, but I'm not sure
> it's worth doing.

If we are going to have a generic structure it is worth doing,
to reduce maintenance when someone changes things around and for
code clarity.

That initializer is just a hair better than line noise.

You can't seem to make up your mind here if you are implementing
a generic facility that should work for all sysctl entries or
if you are implementing a one off for hostname and nisdomainname.

For a one off what you have is ugly but who cares (except that you touch
the generic code). For a generic facility you are missing common
helpers.

Eric
