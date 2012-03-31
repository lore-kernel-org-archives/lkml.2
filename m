Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab2CaTaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 15:30:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54127 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2CaTaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 15:30:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120331185738.GW6589@ZenIV.linux.org.uk>
References: <20120331051906.GU6589@ZenIV.linux.org.uk> <CA+55aFxmOEUCXeHtSAN+g3cSpFVvf5vPTSzZDtXdJs0Hq1rVZw@mail.gmail.com>
 <CA+55aFztRQHX+3KET_xdQd9TuEEuuGS6ogrKAEYGaWfd6m9rDA@mail.gmail.com> <20120331185738.GW6589@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 31 Mar 2012 12:29:41 -0700
X-Google-Sender-Auth: c3QLsLuAAbBMyFqXLUHaVTk2HaU
Message-ID: <CA+55aFxtN9j5j6XC9nDf+mNJ06ipgD4cbW6hrZw6+3KfvDSuww@mail.gmail.com>
Subject: Re: [git pull] vfs part 2
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 11:57 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Works here...  OK, that makes selinuxfs one the most likely suspect; let
> me check if I can reproduce any crap with that...  Do you see anything
> selinux-related in the call chain, BTW?

Yup.The oops scrolled off my screen, but the call chain was:

 init_sel_fs -> kernel_mount_data -> vfs_kern_mount -> mount_fs ->
sel_mount -> mount_single -> (scrolled off)

and then the actual oops happens in d_alloc+0x17, which is
"parent->d_sb", so parent was NULL or something (the register state
also scrolled off, and I didn't check the fault address, so it could
have been some other invalid pointer too).

                   Linus
