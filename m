Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab0KHKYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:24:32 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35513 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab0KHKYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:24:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=g9E52OQeNnugkjcQbNnpBvd6lkKwIXzA+b/SSnKjPQrk6Rz1zi/daPFxUHE2a4/KpU
         C4DeWs07hE1+4rXXDEQGCWAXQdfTFDHUh2hzkZkjOrtT6TshEGlIyW5gYS8RRLZQgCP9
         DSFFOuD6Dft99x9l7Y+WIqZZvCXdYls5XUMac=
MIME-Version: 1.0
In-Reply-To: <201011081122.37145.manningc2@actrix.gen.nz>
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com>
 <201011080959.35220.manningc2@actrix.gen.nz> <AANLkTikZ19E3EXQ+DPKvWRXYZdmpin0Z_2QAnyFoFm6i@mail.gmail.com>
 <201011081122.37145.manningc2@actrix.gen.nz>
From: Chris Snook <chris.snook@gmail.com>
Date: Mon, 8 Nov 2010 06:24:08 -0400
Message-ID: <AANLkTi=m1uq=0dpMxZqMmDnMTMxU09T=Q5eqz+O3uDeC@mail.gmail.com>
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Valdis.Kletnieks@vt.edu, cdhmanning@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 7, 2010 at 6:22 PM, Charles Manning <manningc2@actrix.gen.nz> wrote:
> On Monday 08 November 2010 10:45:32 Chris Snook wrote:
>> On Sun, Nov 7, 2010 at 4:59 PM, Charles Manning <manningc2@actrix.gen.nz>
> wrote:
>> > On Saturday 06 November 2010 14:50:58 Valdis.Kletnieks@vt.edu wrote:
>> >> On Thu, 04 Nov 2010 05:53:16 +1300, cdhmanning@gmail.com said:
>> >> > From: Charles Manning <cdhmanning@gmail.com>
>> >> > +config YAFFS_EMPTY_LOST_AND_FOUND
>> >> > +   bool "Empty lost and found on boot"
>> >> > +   depends on YAFFS_FS
>> >> > +   default n
>> >> > +   help
>> >> > +     If this is enabled then the contents of lost and found is
>> >> > +     automatically dumped at mount.
>> >>
>> >> Wow.. Just.. wow.
>> >
>> > What does that mean?
>> >
>> >> Under what use case is this a good idea for a config
>> >> option as opposed to a mount option?
>> >
>> > It is both.
>> >
>> > Providing a config option provides the system integrator with flexibility
>> > in how they set things up.
>>
>> Does the config option override the mount option, or does the mount
>> option override the config option?
>
> Config sets up a default, mount options can override those.
>
>> No matter what you do, someone
>> will be surprised, and that's a bad thing.  I'm having difficulty
>> imagining a circumstance when you couldn't simply do this in userspace
>> immediately after mount, but if for whatever reason you need
>> mount+dump to be an atomic operation,
>
> Sure it could be done in user space, but it is easier to handle this in the
> mount.

We generally try to do things in userspace unless there's a clear
advantage to doing them in the kernel.  This behavior creates an
unnecessary special case for file deletion.

>> it *really* should not be
>> polluting the kernel configuration.
>
> Perhaps just make it a mount option.
>
>>
>> There are a whole bunch of options in here that appear to be intended
>> to support various different stages of development.  Is there some
>> reason why you can't call that mess of permutations YAFFS1, and merge
>> a clean YAFFS2 patch that doesn't depend on it?
>
> You seem to misunderstand what YAFFS1 and YAFFS2 are.
>
> Your point is well taken though. Many of these options are "tweaks" that could
> be dropped form Kconfig and only offered as mount options.

Thanks.  I know we've allowed a lot of stupid Kconfig options in the
past, but Kconfig bloat is getting to be a real problem.

>> I know that you're
>> trying to support multiple operating systems with the same codebase,
>> but once your code is merged it will get patched by other people
>> making kernel-wide changes, and testing (or even eyeballing) all those
>> permutations will be far outside the realm of feasibility.
>
> To be clear: none of the Kconfig options relate to other OS support.
>
> It is my intention to continue to support other OSs and backporting + new
> features though yaffs.net and patch those into mainstream. While some future
> changes might make this infeasible, I'll cross that bridge when we get to it.
> I'm not going to give up yet.

You're a braver man than I, but as long as that doesn't directly
impact non-YAFFS users/developers, I don't mind.

-- Chris
