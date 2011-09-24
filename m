Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab1IXEJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 00:09:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43160 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1IXEJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 00:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110916214820.GJ4683@elie>
References: <AANLkTim7_OzJfwbtk0fE5ScH8zZwZ_uJeo5pJFOhkHu_@mail.gmail.com>
	<20110912065618.GA23340@elie>
	<CAK82gMFdUy5Dm+FpkrjuEeP9W6BFfGL4U0h-FP8b6BmMHAH1Ww@mail.gmail.com>
	<20110916214820.GJ4683@elie>
Date: Sat, 24 Sep 2011 00:09:38 -0400
Message-ID: <CAK82gMEMUbmNwY=rtJXZ2rrX2ixOa8VVPgpiLE07iaHpo0MYHg@mail.gmail.com>
Subject: Re: Dell PowerEdge 4200 scsi, worked in 2.6.18, not in 2.6.26
From: trouble daemon <troubledaemon@gmail.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, aystarik@gmail.com, x86@kernel.org,
        586494@bugs.debian.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heya,

On Fri, Sep 16, 2011 at 5:48 PM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> trouble daemon wrote:
>
>> As for later kernels, I have no idea tbh. Currently they seem to run
>> flawless with noapic, so that is what I use when installing and
>> running them. I do know that the Debian Squeeze installer chokes if I
>> don't use noapic, however.
>>
>> If you are interested in some closure, I suppose I could take a shot
>> at installing something a little more recent and see if I can get away
>> with removing noapic though. Just let me know what kernel source
>> (vanilla/deb sid/etc), version, or any particular .config options that
>> you would like me to test, and I can see about pasting the console
>> terminal output when running without noapic disabled.
>
> Thanks!  Really, anything 3.0 or later would be interesting (mainline
> is better than distro-patched), with a .config that panics in an older
> version.  Testing with a stock Debian squeeze kernel would be
> interesting, too.
>

Well, I grabbed a git copy from about 2 days ago and compiled/booted
it up. It was 3.1.0-rc7, and with noapic, it boots up debian squeeze
just fine, and if I leave noapic option out of grub, it fails to boot.
It wasn't a panic though.

Basically, it got to the point where it tried to load its megaraid and
aic7xx modules, and then choked when it hit cryptsetup, since the
drives weren't available. It was complaining about something to do
with INTD and INTA not being available or something. I actually
recompiled an extra time without aic7xx new driver (used old) to see
if it helped since the first time aic7xx was complaining about some
kind of scsi reset over and over, but it didn't help. On the
recompile, it just started happening to the megaraid instead.

Sorry that I don't have the dmesg for you just yet. I need to minicom
over and capture, save, etc. to get that off that machine. Just
thought I would let you know that noapic is still required, before you
forget about me :)

Anyways, let me know if you even need the bootup log or not still.
Talk to you soon. \o
