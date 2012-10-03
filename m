Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2JCWXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:23:37 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:46697 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2JCWXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:23:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: paulmck@linux.vnet.ibm.com
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
References: <20121002195042.GA16087@www.outflux.net>
	<20121003132538.GE13192@linux.vnet.ibm.com>
	<20121003161702.GA22008@kroah.com>
	<20121003164712.GF2527@linux.vnet.ibm.com>
	<CAGXu5jJhEpdwCqYc0hWs504snMZg9FMygUjLwRUSyaKGAfXb5Q@mail.gmail.com>
	<20121003200314.GR2527@linux.vnet.ibm.com>
Date: Wed, 03 Oct 2012 15:23:27 -0700
In-Reply-To: <20121003200314.GR2527@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Wed, 3 Oct 2012 13:03:14 -0700")
Message-ID: <87k3v719gg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ciTyU3ddyxyqVGZY/ByzcLlWKULAh2Xc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;paulmck@linux.vnet.ibm.com
X-Spam-Relay-Country: 
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Wed, Oct 03, 2012 at 11:43:32AM -0700, Kees Cook wrote:
>> On Wed, Oct 3, 2012 at 9:47 AM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Wed, Oct 03, 2012 at 09:17:02AM -0700, Greg Kroah-Hartman wrote:
>> >> On Wed, Oct 03, 2012 at 06:25:38AM -0700, Paul E. McKenney wrote:
>> >> > On Tue, Oct 02, 2012 at 12:50:42PM -0700, Kees Cook wrote:
>> >> > > This config item has not carried much meaning for a while now and is
>> >> > > almost always enabled by default. As agreed during the Linux kernel
>> >> > > summit, it should be removed. As a first step, remove it from being
>> >> > > listed, and default it to on. Once it has been removed from all
>> >> > > subsystem Kconfigs, it will be dropped entirely.
>> >> > >
>> >> > > CC: Greg KH <gregkh@linuxfoundation.org>
>> >> > > CC: "Eric W. Biederman" <ebiederm@xmission.com>
>> >> > > CC: Serge Hallyn <serge.hallyn@canonical.com>
>> >> > > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> >> > > CC: Andrew Morton <akpm@linux-foundation.org>
>> >> > > CC: Frederic Weisbecker <fweisbec@gmail.com>
>> >> > > Signed-off-by: Kees Cook <keescook@chromium.org>
>> >> > > ---
>> >> > >
>> >> > > This is the first of a series of 202 patches removing EXPERIMENTAL from
>> >> > > all the Kconfigs in the tree. Should I send them all to lkml (with all
>> >> > > the associated CCs), or do people want to cherry-pick changes from my
>> >> > > tree? I don't want to needlessly flood the list.
>> >> > >
>> >> > > http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
>> >> > >
>> >> > > I figure this patch can stand alone to at least make EXPERIMENTAL go
>> >> > > away from the menus, and give us a taste of what the removal would do
>> >> > > to builds.
>> >> >
>> >> > OK, I will bite...  How should I flag an option that is initially only
>> >> > intended for those willing to take some level of risk?
>> >>
>> >> In the text say "You really don't want to enable this option, use at
>> >> your own risk!"  Or something like that :)
>> >
>> > OK, so the only real hope for experimental features is to refrain from
>> > creating a config option for them, so that people wishing to use them
>> > must modify the code?  Or is the philosophy that we keep things out of
>> > tree until we are comfortable with distros turning them on?
>> 
>> I would expect a simple addition of "this is dangerous/buggy" to the
>> description and "default n" is likely the way to go for that kind of
>> thing. I think the history of CONFIG_EXPERIMENTAL has proven there
>> isn't a sensible way to create a global flag for this kind of thing.
>> To paraphrase Serge: my experimental options are not your experimental
>> options.
>
> That has not proven sufficient for me in the past, RCU_FAST_NO_HZ
> being a case in point.

One option that does work is to add a negative Kconfig dependency such
as "depends on EXT4 = n".  Where what you depend on is something that
distros want.

Where I had a legitimate reason to do that with the user namespace
(aka the code that had not been converted did not compile and was not
safe to use) it worked very well in keeping distros from getting ahead
of them selves, and likewise it works very well for ensuring it got
itself removed as ultimately you want to the two kconfig options to work
together.

>> For example, some of the things that already had the experimental
>> config removed, they left the "(EXPERIMENTAL)" in their config title.
>
> Or I could just make it splat at boot time.  ;-)

Yes.  Treating a truly experimental feature like a deprecated feature
and complaining to the world also seems reasonable, and it seems like
something that would ultimatley get removed as well.

Eric

