Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0KGVp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:45:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51180 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab0KGVpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:45:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=n76bapLS2BKv7GN+t51N039CdauuoIOCBUdIXmKurUlQ4U7Lrg20FOgezXKs9Kz1G6
         S4ubI4BuuMVUsx4D4ADQiL47BPL1BcCcWqApzd0ITisKPa2jh68jmFo0Vnfx6/w2ow3I
         +JuQGRCV2zWAmxT0DICahGjQMDVhAoDJqipEU=
MIME-Version: 1.0
In-Reply-To: <201011080959.35220.manningc2@actrix.gen.nz>
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com>
 <1288803204-3849-2-git-send-email-cdhmanning@gmail.com> <10039.1289008258@localhost>
 <201011080959.35220.manningc2@actrix.gen.nz>
From: Chris Snook <chris.snook@gmail.com>
Date: Sun, 7 Nov 2010 17:45:32 -0400
Message-ID: <AANLkTikZ19E3EXQ+DPKvWRXYZdmpin0Z_2QAnyFoFm6i@mail.gmail.com>
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Valdis.Kletnieks@vt.edu, cdhmanning@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 7, 2010 at 4:59 PM, Charles Manning <manningc2@actrix.gen.nz> wrote:
> On Saturday 06 November 2010 14:50:58 Valdis.Kletnieks@vt.edu wrote:
>> On Thu, 04 Nov 2010 05:53:16 +1300, cdhmanning@gmail.com said:
>> > From: Charles Manning <cdhmanning@gmail.com>
>> > +config YAFFS_EMPTY_LOST_AND_FOUND
>> > +   bool "Empty lost and found on boot"
>> > +   depends on YAFFS_FS
>> > +   default n
>> > +   help
>> > +     If this is enabled then the contents of lost and found is
>> > +     automatically dumped at mount.
>>
>> Wow.. Just.. wow.
>
> What does that mean?
>
>> Under what use case is this a good idea for a config
>> option as opposed to a mount option?
>
> It is both.
>
> Providing a config option provides the system integrator with flexibility in
> how they set things up.

Does the config option override the mount option, or does the mount
option override the config option?  No matter what you do, someone
will be surprised, and that's a bad thing.  I'm having difficulty
imagining a circumstance when you couldn't simply do this in userspace
immediately after mount, but if for whatever reason you need
mount+dump to be an atomic operation, it *really* should not be
polluting the kernel configuration.

There are a whole bunch of options in here that appear to be intended
to support various different stages of development.  Is there some
reason why you can't call that mess of permutations YAFFS1, and merge
a clean YAFFS2 patch that doesn't depend on it?  I know that you're
trying to support multiple operating systems with the same codebase,
but once your code is merged it will get patched by other people
making kernel-wide changes, and testing (or even eyeballing) all those
permutations will be far outside the realm of feasibility.

-- Chris
