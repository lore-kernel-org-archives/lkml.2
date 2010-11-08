Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0KHWP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:15:26 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57938 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0KHWPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:15:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=m7MVPkBkfUR6eASYbRQW5KuNGM5/Rbpd/NARWprAlWG7o4iLi3cFv8SV7vNKToZTat
         jVm1po5o/BR+os9zYYC7w0xxjGLITzlxmajoNuMnBTkKb/CR6RV9tY9Yi7JSnCPtQKX+
         OTOHbSTIhXviTKt908aFqbHKBwM8w/wQpSTc8=
MIME-Version: 1.0
In-Reply-To: <201011091022.11836.manningc2@actrix.gen.nz>
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com>
 <201011081122.37145.manningc2@actrix.gen.nz> <AANLkTi=m1uq=0dpMxZqMmDnMTMxU09T=Q5eqz+O3uDeC@mail.gmail.com>
 <201011091022.11836.manningc2@actrix.gen.nz>
From: Chris Snook <chris.snook@gmail.com>
Date: Mon, 8 Nov 2010 18:15:03 -0400
Message-ID: <AANLkTi=yBaRyLjpcbkmSWxXtwPAuzccxdA=Zd3ZM7Mzi@mail.gmail.com>
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Valdis.Kletnieks@vt.edu, cdhmanning@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 5:22 PM, Charles Manning <manningc2@actrix.gen.nz> wrote:
> On Monday 08 November 2010 23:24:08 Chris Snook wrote:
>> On Sun, Nov 7, 2010 at 6:22 PM, Charles Manning <manningc2@actrix.gen.nz>
> wrote:
>> > On Monday 08 November 2010 10:45:32 Chris Snook wrote:
>> >> On Sun, Nov 7, 2010 at 4:59 PM, Charles Manning
>> >> <manningc2@actrix.gen.nz>
>> >
>> > wrote:
>> >> > On Saturday 06 November 2010 14:50:58 Valdis.Kletnieks@vt.edu wrote:
>> >> >> On Thu, 04 Nov 2010 05:53:16 +1300, cdhmanning@gmail.com said:
>> >> >> > From: Charles Manning <cdhmanning@gmail.com>
>> >> >> > +config YAFFS_EMPTY_LOST_AND_FOUND
>> >> >> > +   bool "Empty lost and found on boot"
>> >> >> > +   depends on YAFFS_FS
>> >> >> > +   default n
>> >> >> > +   help
>> >> >> > +     If this is enabled then the contents of lost and found is
>> >> >> > +     automatically dumped at mount.
>> >> >>
>> >> >> Wow.. Just.. wow.
>> >> >
>> >> > What does that mean?
>> >> >
>> >> >> Under what use case is this a good idea for a config
>> >> >> option as opposed to a mount option?
>> >> >
>> >> > It is both.
>> >> >
>> >> > Providing a config option provides the system integrator with
>> >> > flexibility in how they set things up.
>> >>
>> >> Does the config option override the mount option, or does the mount
>> >> option override the config option?
>> >
>> > Config sets up a default, mount options can override those.
>> >
>> >> No matter what you do, someone
>> >> will be surprised, and that's a bad thing.  I'm having difficulty
>> >> imagining a circumstance when you couldn't simply do this in userspace
>> >> immediately after mount, but if for whatever reason you need
>> >> mount+dump to be an atomic operation,
>> >
>> > Sure it could be done in user space, but it is easier to handle this in
>> > the mount.
>>
>> We generally try to do things in userspace unless there's a clear
>> advantage to doing them in the kernel.  This behavior creates an
>> unnecessary special case for file deletion.
>
> This feature was actually requested by one of the major phone players.
> Doing this at mount is more efficient and simpler than doing it in start up
> scripts.

Fine with me.  Faster boot is a perfectly legitimate technical reason.
 (Userspace developers being too lazy to add a line to an initscript
is not.)

>> > Your point is well taken though. Many of these options are "tweaks" that
>> > could be dropped form Kconfig and only offered as mount options.
>>
>> Thanks.  I know we've allowed a lot of stupid Kconfig options in the
>> past, but Kconfig bloat is getting to be a real problem.
>
> I'm trying to understand where you see that problem coming from.
>
> I agree fully that there were pollution issues when file systems stored their
> configs in fs/kconfig, making this file a mess.
>
> Is it really a problem to have many configs? Consider:
> * All the configs are in fs/yaffs2/Kconfig. They don't clutter a common file.
> * If you're not using yaffs2 then the .config only has  "CONFIG_YAFFS_FS is
> not set". Hardly an overhead to non-yaffs users.
>
> I do agree that there are some configs that should be cleaned up/removed, and
> maybe described better. I'll fix that for the next patch set.

Sorry, I should have scrutinized your Kconfig conditions more
carefully.  You've done it the right way.
