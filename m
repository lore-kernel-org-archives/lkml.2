Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1CJTfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:35:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36249 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1CJTfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=W7tvPoJJB3mHiT8sjr5dSrVnI1x8z/lHpg8afuUQt7fZ0T0ALVso4xU3MLzynSZmNu
         t/o42t3JArK05sh4QDXlFBty/XRmZZAdt9RDL1F9cicGUxBbP1ikX3qKiPrwrM0XADjV
         DRX+wlBu5ObhfM8UuJ3oT9lcU6uw2UvOtXjaE=
MIME-Version: 1.0
In-Reply-To: <20110310185321.GA22030@rivendell.middle-earth.co.uk>
References: <20110310185321.GA22030@rivendell.middle-earth.co.uk>
Date: Thu, 10 Mar 2011 21:35:20 +0200
X-Google-Sender-Auth: ar91PDRm905hmN6P-4X4QEh_6k8
Message-ID: <AANLkTikXb_NM0+3ro607k0sz1zFJFTeJwp9MmBn_ngzn@mail.gmail.com>
Subject: Re: NFS regression in 2.6.37.1 (current stable)
From: Pekka Enberg <penberg@kernel.org>
To: Dr Andrew John Hughes <ahughes@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Trond.Myklebust@netapp.com, mkl@pengutronix.de,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 8:53 PM, Dr Andrew John Hughes
<ahughes@redhat.com> wrote:
> [Please CC me on responses as I'm not subscribed]
>
> Hi,
>
> I seem to have uncovered a regression in the NFS code between 2.6.37 and 2.6.37.1
> caused by this changeset:
>
> commit 55ea499d60aefa3d03a77fc8590c26b5881faa92
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Sat Jan 8 17:45:38 2011 -0500
> NFS: Don't use vm_map_ram() in readdir
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=commit;h=6650239a4b01077e80d5a4468562756d77afaa59
>
> With this change applied, copying of files between NFS and non-NFS
> mounts seems to be broken.  The easiest way I've found to replicate
> this myself is to use a VCS to do a clone of a tree on a NFS mount to
> a directory on a non-NFS mount.  I used Mercurial, as I had Mercurial
> trees to hand from work on IcedTea, but I assume doing it with a git
> tree such as the linux tree would also work.  The idea is to do
> something which involves copying over a bunch of directories and
> checking the result is readable.
>
> $ hg clone $HOME/projects/openjdk/icedtea6-hg
> destination directory: icedtea6-hg
> updating to branch default
> abort:
> data/contrib/templater/hotspot/src/cpu/CPU/vm/bytecodeInterpreter_CPU.inline.hpp.i@16d04ce16287:
> no match found!
>
> In the above, $HOME is an NFS mount and $PWD is a local reiserfs
> partition.  I initially hit failures doing builds with source on $HOME
> and the build directory on a local reiserfs partition.  In that
> scenario, it would fail as not being able to find files that should
> have been copied over.
>
> Reverting the changeset fixes the issue.  2.6.37.2 still has the bug.
> I haven't checked 2.6.37.3 yet but I didn't see any NFS changes in there.

There's some more discussion here:

https://bugs.gentoo.org/show_bug.cgi?id=357121

Greg, Trond, as this is a regression in -stable, I wonder if it's best
that we just revert the commit?

                        Pekka
