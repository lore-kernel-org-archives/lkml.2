Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1CQHao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 03:30:44 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:50405 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab1CQHam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 03:30:42 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 17 Mar 2011 09:30:35 +0200
From: Richard Weinberger <richard@nod.at>
To: Kees Cook <kees.cook@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <serge@hallyn.com>, <eparis@redhat.com>, <jmorris@namei.org>,
        <eugeneteo@kernel.org>, <drosenberg@vsecurity.com>
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
In-Reply-To: <20110317064136.GD5466@outflux.net>
References: <1300303907-22627-1-git-send-email-richard@nod.at>
 <201103162108.17127.richard@nod.at> <201103162145.45772.arnd@arndb.de>
 <201103162152.49615.richard@nod.at> <m1lj0eepe4.fsf@fess.ebiederm.org>
 <20110317064136.GD5466@outflux.net>
Message-ID: <599d83ea1ee667d747f3c863b98f40ef@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011 23:41:36 -0700, Kees Cook <kees.cook@canonical.com>
wrote:
> On Wed, Mar 16, 2011 at 02:17:39PM -0700, Eric W. Biederman wrote:
>> Richard Weinberger <richard@nod.at> writes:
>> 2> Am Mittwoch 16 März 2011, 21:45:45 schrieb Arnd Bergmann:
>> >> On Wednesday 16 March 2011 21:08:16 Richard Weinberger wrote:
>> >> > Am Mittwoch 16 März 2011, 20:55:49 schrieb Kees Cook:
>> >> > > On Wed, Mar 16, 2011 at 08:31:47PM +0100, Richard Weinberger wrote:
>> >> > > > When containers like LXC are used a unprivileged and jailed
>> >> > > > root user can still write to critical files in /proc/.
>> >> > > > E.g: /proc/sys/kernel/{sysrq, panic, panic_on_oops, ... }
>> >> > > >
>> >> > > > This new restricted attribute makes it possible to protect such
>> >> > > > files. When restricted is set to true root needs CAP_SYS_ADMIN
>> >> > > > to into the file.
>> >> > >
>> >> > > I was thinking about this too. I'd prefer more fine-grained control
>> >> > > in this area, since some sysctl entries aren't strictly controlled by
>> >> > > CAP_SYS_ADMIN (e.g. mmap_min_addr is already checking CAP_SYS_RAWIO).
>> >> > >
>> >> > > How about this instead?
>> >> >
>> >> > Good Idea.
>> >> > May we should also consider a per-directory restriction.
>> >> > Every file in /proc/sys/{kernel/, vm/, fs/, dev/} needs a protection.
>> >> > It would be much easier to set the protection on the parent directory
>> >> > instead of protecting file by file...
>> >>
>> >> How does this interact with the per-namespace sysctls that Eric
>> >> Biederman added a few years ago?
>> >
>> > Do you mean CONFIG_{UTS, UPC, USER, NET,}_NS?
>> >
>> >> I had expected that any dangerous sysctl would not be visible in
>> >> an unpriviledge container anyway.
>> >
>> > No way.
>> > That's why it's currently a very good idea to mount /proc/ read-only
>> > into a container.
>>
>> However it is in the architecture.  The problem is that the user
>> namespace is not finished.  Once finished even root with all caps in a
>> container will have no more permissions than the unprivileged user that
>> created the user namespace.
>>
>> Essentially the change is to make permissions checks become a comparison
>> of the tuple (user_ns, uid) instead of just comparisons by uid.  If we
>> want to fix permission problems with proc and containers please let's
>> focus on the completing the user namespace.
> 
> I actually think these are not mutually exclusive. Right now /proc/sys is
> filled with ways to gain caps as a reduced-privilege uid 0 user. I don't
> think containers are the only place where we want to be limiting /proc/sys.
> (For example, core_pattern and modprobe entries can both be written by
> root, regardless of cap, which can be directed to run arbitrary commands
> with full caps. And yes, that's also being fixed separately, it's just an
> example.)
> 
> I'd still like to see the sysctl table expanded to include caps to test.

I agree with you.
Every writable file in /proc/ should have a check for at least one cap.

 
> -Kees

