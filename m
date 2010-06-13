Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab0FMWz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 18:55:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47897 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab0FMWzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 18:55:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Evo/xXdAIqlCdYqvj6YC4HFuNtVvz079JiulgDMpFRl6hU13bTBmkgq473E1BQJ6TU
         IO3LGI4gPVhLOyGR0bSk4x1Z266VPzytV1wajHi9nSOWS4eAsV4Z6+ZfIg/tTAcIC3F4
         Yf5/Q1rDyVW8SQEobO4R/Bm5QOOrzOGZsEH2g=
MIME-Version: 1.0
In-Reply-To: <AANLkTin_xSdx-Zasxx0xnlbjaITgMTw1s7JUbq8MCX2s@mail.gmail.com>
References: <AANLkTimmhzbgddTZBoaSy4iXpjB4Gdy6zTab0EjCM1IK@mail.gmail.com>
	<AANLkTinwQ5tUDyHIObolQrd0jESH5PGEBKqwk6a_jHWK@mail.gmail.com>
	<AANLkTilbMPLfd415EV32or8FZCM1sWi-RzeWtPAX95-o@mail.gmail.com>
	<AANLkTilzq64CPECxFb77PEdjv1Pcj72622rmhPchz9L8@mail.gmail.com>
	<20766.1276435765@localhost>
	<AANLkTin_xSdx-Zasxx0xnlbjaITgMTw1s7JUbq8MCX2s@mail.gmail.com>
Date: Sun, 13 Jun 2010 18:47:38 -0400
Message-ID: <AANLkTimmiUZ7sBhM1Rdn0MUbUceEz-qRQqWcTrmsERtF@mail.gmail.com>
Subject: Re: Help for a newbie
From: Someone Something <fordhaivat@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I looked through kernelnewbies.org, read some more of robert love, but
two questions still stand.

Where are the syscalls implemented and where are the header files with
their prototypes?

On Sun, Jun 13, 2010 at 1:03 PM, Someone Something <fordhaivat@gmail.com> wrote:
> Thanks for the very thorough reply. As for the syscalls, I just wanted
> to add one that gave you the task descriptor struct for the init
> process, just for fun. I would also like to start writing kernel
> modules. I'm not exactly experienced with hardware so I'll probably
> put off device drivers for a while.
>
> Thanks a lot,
>
> Dhaivat
>
> On Sun, Jun 13, 2010 at 9:29 AM,  <Valdis.Kletnieks@vt.edu> wrote:
>> On Sat, 12 Jun 2010 23:32:36 EDT, Someone Something said:
>>
>>> 1) when you write userland apps, you usually include stuff like :
>>> sys/types.h or errono.h where are all these defined in the linux
>>> kernel because I would like to add a few syscalls of my own?
>>
>> Look at any source files already in the kernel, they'll give you a good
>> hint of where the .h files are.  Keep in mind that in the kernel, we
>> tend to #include a lot of header files, depending on what exactly is needed.
>>
>> Regarding adding syscalls - step 0 is doing a proper design and making sure
>> that in fact you need a new syscall.  What features do you want to add, and
>> why do they need syscalls?
>>
>> It's usually a bad idea to add syscalls unless you *really* need to - most
>> of the time creating a loadable kernel module is a better idea (among other
>> things, you can compile a module against a distro kernel without rebuilding
>> the entire kernel, you can't do that with a syscall).
>>
>>> 2) what are some bugs in the kernel that a beginner can fix?
>>
>> Unfortunately, we're victims of our own sucess here.  There really aren't many
>> long-standing bugs left that a beginner can fix.  If you follow the linux-next
>> or Andrew Morton's -mm kernel, you'll find the occasional typo or messed up
>> code that has an #ifdef backwards so it doesn't build for all configs, and so
>> on.  But in general, if the bug has been there more than 12 hours or so, it
>> usually means that it's a nasty ugly mess and will require some real work to
>> fix.
>>
>> That isn't to say that the developers don't appreciate all those little
>> one-line patches to make stuff work in your config that they didn't test.
>> They appreciate those a *lot*.  I just can't point you at any because the list
>> will be different by the time you read this mail.
>>
>>> 3) is there any definitive guide to the kernel that you guys refer
>>> most newbies to? (like Programming Perl for perl)?
>>
>> Robert Love's book and "Linux Device Drivers, 3rd ed" are both pretty good
>> overviews, although somewhat dated because the code is a moving target.
>> Once you got a handle on the major data structures, it's really "Use The
>> Source, Luke" time.
>>
>>> 4) Where's the linux kernel headed to next? What higher level features
>>> (i.e. real features, not bug fixes) are going to implemented?
>>
>> Well, I really can't say anything definite other than "read LKML or at least a
>> weekly scan of the Subject: lines to see what's new".  It's going to be the
>> same as it has for the last few years - code will be merged when it's written
>> by somebody who's scratching an itch.  We'll eventually merge *something* for
>> the Android power-management issue (because we really *do* need a solution in
>> that area), new file systems will be merged, device drivers will be written,
>> and so on. What will go in for 2.6.36 and later releases pretty much depends on
>> what code people feel motivated to write for submission.
>>
>>
>>
>
