Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2DQSAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:00:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43396 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab2DQSAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:00:00 -0400
Date: Tue, 17 Apr 2012 18:59:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120417175954.GV6589@ZenIV.linux.org.uk>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
 <20120417162216.GB27426@fieldses.org>
 <CA+55aFzTKt43-qm4se2ac24kEVQO=aH8sckh0e-Lf-wydnYHfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzTKt43-qm4se2ac24kEVQO=aH8sckh0e-Lf-wydnYHfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 09:33:06AM -0700, Linus Torvalds wrote:
> On Tue, Apr 17, 2012 at 9:22 AM, J. Bruce Fields <bfields@fieldses.org> wrote:

> In fact I don't think you need even that much. Just a simple
> 
>   touch a
>   ln a b
>   mv a b
> 
> looks like it should deadlock on itself, no? source and dest inodes
> will be the same, so the mutex_lock() will just deadlock without even
> any ABBA race.

No, this one will bail out much earlier.
