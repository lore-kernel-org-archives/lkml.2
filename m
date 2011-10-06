Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab1JFMM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 08:12:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64400 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1JFMMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 08:12:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
References: <20111003090846.GA25136@localhost.pp.htv.fi>
	<CAObL_7GSQFr_PRtKY=H7r=yD7Qk-xvgbg5bV1=nU-qayG-mJdw@mail.gmail.com>
	<20111003173359.GA3072@localhost.pp.htv.fi>
	<CAObL_7Fi3mw5Azyhxx-vsdNuhJm8RewmYS97QvWa0F=cbYvegg@mail.gmail.com>
	<CAFLxGvzpvJ1mgdcbrq+3h5EA+VOhZDR9BY27uWGgsmV4TWYb4A@mail.gmail.com>
	<20111005223055.GG14406@localhost.pp.htv.fi>
	<CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com>
	<CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com>
	<CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
Date: Thu, 6 Oct 2011 14:12:52 +0200
Message-ID: <CAFLxGvyKcjUVwAoGtE5TpuyiGOVTOb=i5=UdsE4Q0QUDg9ffpA@mail.gmail.com>
Subject: Re: [3.1 patch] x86: default to vsyscall=native
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 5:06 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Wed, Oct 5, 2011 at 4:36 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Wed, Oct 5, 2011 at 3:46 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>> On Wed, Oct 5, 2011 at 3:30 PM, Adrian Bunk <bunk@stusta.de> wrote:
>>>> On Thu, Oct 06, 2011 at 12:22:34AM +0200, richard -rw- weinberger wrote:
>>>>> On Thu, Oct 6, 2011 at 12:13 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>>>>> > On Mon, Oct 3, 2011 at 10:33 AM, Adrian Bunk <bunk@stusta.de> wrote:
>>>>> >> On Mon, Oct 03, 2011 at 06:04:53AM -0700, Andrew Lutomirski wrote:
>>>>> >>> On Mon, Oct 3, 2011 at 2:08 AM, Adrian Bunk <bunk@stusta.de> wrote:
>>>>> >>> > After upgrading a kernel the existing userspace should just work
>>>>> >>> > (assuming it did work before ;-) ), but when I upgraded my kernel
>>>>> >>> > from 3.0.4 to 3.1.0-rc8 a UML instance didn't come up properly.
>>>>> >>> >
>>>>> >>> > dmesg said:
>>>>> >>> >  linux-2.6.30.1[3800] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb9c498 ax:ffffffffff600000 si:0 di:606790
>>>>> >>> >  linux-2.6.30.1[3856] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb13168 ax:ffffffffff600000 si:0 di:606790
>>>>> >>> >
>>>>> >>> > Looking throught the changelog I ended up at commit 3ae36655
>>>>> >>> > ("x86-64: Rework vsyscall emulation and add vsyscall= parameter").
>>>>> >>> >
>>>>> >>> > Linus suggested in https://lkml.org/lkml/2011/8/9/376 to default to
>>>>> >>> > vsyscall=native.
>>>>> >>> >
>>>>> >>> > That sounds reasonable to me, and fixes the problem for me.
>>>>> >>>
>>>>> >>> At this point in the -rc cycle, this sounds fine.
>>>>> >>>
>>>>> >>> That being said, I'd like to fix it for real for 3.2.  This particular
>>>>> >>> failure is suspicious -- the "vsyscall fault" message means that
>>>>> >>> sys_gettimeofday returned EFAULT, which means that the old (3.0 and
>>>>> >>> before) vgettimeofday should *also* have segfaulted.
>>>>> >>
>>>>> >> This 2.6.30.1 UML kernel binary from 2009 worked for me for all host
>>>>> >> kernels from 2.6.30 to 3.0, and with 3.1.0-rc8 and vsyscall=native
>>>>> >> it also seems to run nicely.
>>>>> >>
>>>>> >> Looking deeper into "a UML instance didn't come up properly",
>>>>> >> the problem is that it comes up in a strange (readonly) state.
>>>>> >>
>>>>> >> There are "Using makefile-style concurrent boot in runlevel S."
>>>>> >> and "Using makefile-style concurrent boot in runlevel 2." in the
>>>>> >> logs with a Debian userspace, but no output from the init scripts
>>>>> >> in these broken bootups (normal messages are in non-broken bootups).
>>>>> >>
>>>>> >> Perhaps the two the messages I see in dmesg on the host are from the
>>>>> >> processes running rcS and rc2 failing early?
>>>>> >>
>>>>> >> In a working startup with a Debian userspace, I'm getting during rcS
>>>>> >>  Setting the system clock.
>>>>> >>  Cannot access the Hardware Clock via any known method.
>>>>> >>  Use the --debug option to see the details of our search for an access method.
>>>>> >>  Unable to set System Clock to: Mon Oct 3 17:01:35 UTC 2011 ... (warning).
>>>>> >>
>>>>> >>> We do have a bit
>>>>> >>> of a bug in that the new code doesn't report si_addr properly, but
>>>>> >>> that sounds unlikely as a culprit.  Did you try with the offending
>>>>> >>> commit reverted (i.e. fce8dc0)?  I bet that it also fails there.
>>>>> >>
>>>>> >> fce8dc0 is "x86-64: Wire up getcpu syscall", is that really the one you
>>>>> >> want me to revert?
>>>>> >>
>>>>> >>> What's the .config for your UML binary?  I'd like to see if I can
>>>>> >>> reproduce this.
>>>>> >>
>>>>> >> It's attached.
>>>>> >>
>>>>> >
>>>>> > I can't reproduce it.  What distro is running inside the UML instance?
>>>>>
>>>>> Same here.
>>>>> Adrian, is the UML kernel crashing before executing init?
>>>>
>>>> As I wrote:
>>>>  Looking deeper into "a UML instance didn't come up properly",
>>>>  the problem is that it comes up in a strange (readonly) state.
>>>>
>>>> The UML kernel is running happily without crashing, and as I wrote my
>>>> guess about my problems is:
>>>>  Perhaps the two the messages I see in dmesg on the host are from the
>>>>  processes running rcS and rc2 failing early?
>>>>
>>>>> We definitely need more information...
>>>>
>>>> I gave the information that was requested. plus my observations.
>>>>
>>>> What more information exactly do you need from me?
>>>
>>> None :)  I just reproduced the problem with Debian Squeeze.  Lenny works fine.
>>
>> This is strange.  The problem appears to be in startpar.  That same
>> exact Debian image works fine on KVM running 3.1-rc8 (with
>> vsyscall=emulate) and on 2.6.40 (i.e. Fedora 15's kernel).  If I set
>> print-fatal-signals=1 I don't see a fatal signal in startpar.
>>
>> Richard, is it possible that UML 2.6.30.1 generates a bogus
>> vgettimeofday and recovers successfully on older kernels because the
>> resulting SIGSEGV had a valid sigcontext?  I can try hacking the
>> "vsyscall fault" path to generate full sigcontext and info.  This
>> seems rather unlikely, though.
>
> I think that is the problem.  UML appears to lazily set up "page
> tables" just like a real machine; it does this by handling SIGSEGV and
> calling handle_mm_fault.  If cr2 isn't set right, though, it doesn't
> know where the fault was and it can't handle it, so it just sends
> SIGSEGV to userspace.
>
> In 3.0 and earlier, we don't crash but we malfunction differently: UML
> doesn't intercept the vsyscall at all and the guest sees the hosts's
> time.  This should be fixed in a newer version of UML.

How can we intercept a vsyscall?
It's not trivial.

Starting with Linux 3.1 UML (x86_64) has a vDSO page which transforms
all vDSO calls
to real system calls which can be intercepted.
So, only statically linked binaries will use the host's vsyscall interface.

> In vsyscall=native mode, we DTRT because UML handles the syscall itself.
>
> I'll see how ugly the patch to get this all correct is.  It may not be
> all that pretty because we won't be able to use sys_gettimeofday
> anymore.
>

vsyscall=emulate would be okay for UML if the SEGV has a valid signal context.

-- 
Thanks,
//richard
