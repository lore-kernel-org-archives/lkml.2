Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab2JCSXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:23:53 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33964 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab2JCSXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:23:51 -0400
MIME-Version: 1.0
In-Reply-To: <20121003174606.GB637@somewhere>
References: <20121002195042.GA16087@www.outflux.net>
	<20121003132538.GE13192@linux.vnet.ibm.com>
	<20121003161702.GA22008@kroah.com>
	<20121003164712.GF2527@linux.vnet.ibm.com>
	<20121003172142.GA5061@kroah.com>
	<20121003174606.GB637@somewhere>
Date: Wed, 3 Oct 2012 14:23:51 -0400
Message-ID: <CA+5PVA5k_924aTP=MHHCdq6ni3RMwQCKpLQ7iyJC0hM-7vjang@mail.gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
From: Josh Boyer <jwboyer@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 1:46 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Oct 03, 2012 at 10:21:42AM -0700, Greg Kroah-Hartman wrote:
>> On Wed, Oct 03, 2012 at 09:47:12AM -0700, Paul E. McKenney wrote:
>> > On Wed, Oct 03, 2012 at 09:17:02AM -0700, Greg Kroah-Hartman wrote:
>> > > On Wed, Oct 03, 2012 at 06:25:38AM -0700, Paul E. McKenney wrote:
>> > > > On Tue, Oct 02, 2012 at 12:50:42PM -0700, Kees Cook wrote:
>> > > > > This config item has not carried much meaning for a while now and is
>> > > > > almost always enabled by default. As agreed during the Linux kernel
>> > > > > summit, it should be removed. As a first step, remove it from being
>> > > > > listed, and default it to on. Once it has been removed from all
>> > > > > subsystem Kconfigs, it will be dropped entirely.
>> > > > >
>> > > > > CC: Greg KH <gregkh@linuxfoundation.org>
>> > > > > CC: "Eric W. Biederman" <ebiederm@xmission.com>
>> > > > > CC: Serge Hallyn <serge.hallyn@canonical.com>
>> > > > > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> > > > > CC: Andrew Morton <akpm@linux-foundation.org>
>> > > > > CC: Frederic Weisbecker <fweisbec@gmail.com>
>> > > > > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > > > > ---
>> > > > >
>> > > > > This is the first of a series of 202 patches removing EXPERIMENTAL from
>> > > > > all the Kconfigs in the tree. Should I send them all to lkml (with all
>> > > > > the associated CCs), or do people want to cherry-pick changes from my
>> > > > > tree? I don't want to needlessly flood the list.
>> > > > >
>> > > > > http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
>> > > > >
>> > > > > I figure this patch can stand alone to at least make EXPERIMENTAL go
>> > > > > away from the menus, and give us a taste of what the removal would do
>> > > > > to builds.
>> > > >
>> > > > OK, I will bite...  How should I flag an option that is initially only
>> > > > intended for those willing to take some level of risk?
>> > >
>> > > In the text say "You really don't want to enable this option, use at
>> > > your own risk!"  Or something like that :)
>> >
>> > OK, so the only real hope for experimental features is to refrain from
>> > creating a config option for them, so that people wishing to use them
>> > must modify the code?  Or is the philosophy that we keep things out of
>> > tree until we are comfortable with distros turning them on?
>>
>> I think that should have been your philosophy for a long time, as they
>> turn on everything, and I don't blame them.
>> Why would we have included
>> it in the kernel tree, unless we wanted people to use the option?
>
> A solution could be to add that option under CONFIG_DEBUG_KERNEL and specify
> that it must only be enabled by developers for specific reasons (overhead,
> security). CONFIG_PROVE_LOCKING falls into that category, right?

No.  Fedora runs with that enabled in our development repositories.  To
be honest, I think we're one of the only users of it given we hit bugs
in released kernels, etc.  We actually _want_ the bug reports it finds.

josh
