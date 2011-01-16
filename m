Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1APViS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:38:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953Ab1APViP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:38:15 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTim1SS2Y1EL9iB2jDSUbqofoaWXig-xHa12Ogm95@mail.gmail.com>
References: <20110116185745.GB22723@ZenIV.linux.org.uk> <AANLkTim1SS2Y1EL9iB2jDSUbqofoaWXig-xHa12Ogm95@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Jan 2011 13:37:54 -0800
Message-ID: <AANLkTinZ5ng+hbOHz7DKy82HPqFwYhQvmmbM+ioSWp9x@mail.gmail.com>
Subject: Re: [git pull] vfs pile 2 (automount work)
To: Joachim Eastwood <manabian@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 1:15 PM, Joachim  Eastwood <manabian@gmail.com> wrote:
>
> f03c65993b98eeb909a4012ce7833c5857d74755 - sanitize vfsmount refcounting changes
>
> Breaks my ARM !CONFIG_SMP compile

In fact, any non-SMP compile, it's not ARM-specific.

The simple fix for the build breakage should be to just move the
mnt_longterm thing out of the #ifdef CONFIG_SMP in
include/linux/mount.h. But I do worry that it would cause some count
imbalance, because there are some accesses that are still inside that
CONFIG_SMP case in mntput_no_expire().

Al, please take a look,

                 Linus
