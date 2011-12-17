Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab1LQPgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 10:36:17 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:28977 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1LQPgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:36:14 -0500
Date: Sat, 17 Dec 2011 10:36:06 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Linux 3.2-rc6
Message-ID: <20111217153606.GE5679@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Casey Schaufler <casey@schaufler-ca.com>
References: <CA+55aFzd6K2szJD5MLmy3Stcai9oAR=tRXZdQtKgVWBzDr5bdg@mail.gmail.com>
 <20111217084944.GV2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111217084944.GV2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4EECB6EB.0006,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 08:49:44AM +0000, Al Viro wrote:
> On Fri, Dec 16, 2011 at 06:53:17PM -0800, Linus Torvalds wrote:
> 
> > Casey Schaufler (1):
> >       BTRFS: Establish i_ops before calling d_instantiate
> 
> I'm sorry, but that's nowhere near enough.  As I said in followup to
> the original posting of that patch, it still leaves a race window
> where inode is already associated with dentry but still doesn't have
> ->a_ops, etc. set up.  Hell, ->symlink() doesn't write the symlink
> body until after that point...

Thanks Al, I'll test this as well and pull it in.

-chris
