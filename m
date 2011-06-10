Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1FJOf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:35:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51353 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1FJOf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:35:58 -0400
Date: Fri, 10 Jun 2011 15:35:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Race inotify_rm_watch vs umount
Message-ID: <20110610143550.GZ11521@ZenIV.linux.org.uk>
References: <87r572nd9k.fsf@devron.myhome.or.jp>
 <1307713566.2577.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307713566.2577.20.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 09:46:05AM -0400, Eric Paris wrote:
> On Fri, 2011-06-10 at 20:20 +0900, OGAWA Hirofumi wrote:
> > Hi,
> > 
> > I'm looking the race inotify_rm_watch() vs umount(). This race become the
> > cause of Oops. You can see the oops at
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=22602
> > 
> > So, what race?
> 
> Ok, I see what you are saying, I'll see what I can do.  I'm a little
> scared to call something like iput() under a lock though.  I might be
> able to make the bigest lock a mutex and fix this....

Which lock would that be?  I don't see any good candidates in there...
