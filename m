Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2DQQd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:33:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51725 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2DQQd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120417162216.GB27426@fieldses.org>
References: <20120417052511.GU6589@ZenIV.linux.org.uk> <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
 <20120417162216.GB27426@fieldses.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Apr 2012 09:33:06 -0700
X-Google-Sender-Auth: kVuAhQ2sDMZIvUsyyZ7Mmk7LC5I
Message-ID: <CA+55aFzTKt43-qm4se2ac24kEVQO=aH8sckh0e-Lf-wydnYHfg@mail.gmail.com>
Subject: Re: [git pull] vfs and fs fixes
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 9:22 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
>
> Ugh, no, I think you're right:
>
>        rename A/a->A/b
>        rename B/b->B/b
>
> where A/a and B/a are the same file, and A/b and B/b are the same file,
> can result in the first rename holding the lock on A and a and waiting
> on b, and the second holding the lock on B and b and waiting on a.

In fact I don't think you need even that much. Just a simple

  touch a
  ln a b
  mv a b

looks like it should deadlock on itself, no? source and dest inodes
will be the same, so the mutex_lock() will just deadlock without even
any ABBA race.

(I didn't really check - maybe there is some reason that doesn't happen).

                  Linus
