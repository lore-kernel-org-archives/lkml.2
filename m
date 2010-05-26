Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763Ab0EZJSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:18:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64649 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449Ab0EZJSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=Bw1hwQBBfhO1RRqCpNGTvAQk1EV4/n/4kNmnmUDP/n0P5I+dg7QYFChklxvnGEvsNz
         87ctYii4WwXXzmaWEP8cbIpANoTtV76RF1stBfHUU0DCw/adEcGbtkLQVhl9+C2ai4AD
         AVJnWAejM5Uf9sMpY+29ZWtMWzpl0Ki7mIkso=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 26 May 2010 11:18:15 +0200
Message-ID: <AANLkTil7Lk49FaqRPGpc0P2TIgk1_LGMBnX4EZNRSAbl@mail.gmail.com>
Subject: Re: udev loops eating 100 % CPU [mmotm 2010-05-21-16-05]
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: hch@lst.de, viro@zeniv.linux.org.uk, eparis@redhat.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Please CC me - I am not subscribed to LKML ]

Hi Christoph,

can you comment on why Eric's patch is "disgusting"?
Any other solutions or fixes around?

Kind Regards,
- Sedat -


Date	Tue, 25 May 2010 08:28:27 -0400
From	Christoph Hellwig <>
Subject	Re: udev loops eating 100 % CPU [mmotm 2010-05-21-16-05]

On Tue, May 25, 2010 at 08:22:12AM -0400, Eric Paris wrote:
> On Tue, 2010-05-25 at 14:12 +0200, Jiri Slaby wrote:
>
> thanks for the report, it's a known problem:
>
> http://lkml.org/lkml/2010/5/22/150
>
> Not sure yet how we are going to fix it.  You can either just revert or
> you could run this patch which I am using on my box.  Not sure which Al
> is going to want to do......
>
> commit 6e066d6c0c70e2032b5fd2b5c6375e66a0f547f9
> Author: Eric Paris <eparis@redhat.com>
> Date:   Tue May 25 07:55:46 2010 -0400
>
>     anon_inode/ioctl: push FIONREAD for anon_inode to the file handler
>
>     FIONREAD for all S_IFREG files is handled by file_ioctl but the
>     anon_inode_inode is a magic special beast since the inode is shared between
>     lots of users.  Thus ioctl calls on anon_inode_inode needs to go through
>     vfs_inode() instead of trying to shortcut some calls through file_ioctl().
>
>     Signed-off-by: Eric Paris <eparis@redhat.com>

This one is defintively far too disgusting.
