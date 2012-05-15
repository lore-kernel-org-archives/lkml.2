Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673Ab2EOQIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:08:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48427 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965624Ab2EOQIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:08:48 -0400
Message-ID: <1337098006.25191.35.camel@falcor>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 May 2012 12:06:46 -0400
In-Reply-To: <alpine.LRH.2.02.1205160113550.939@tundra.namei.org>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
	 <alpine.LRH.2.02.1205151028450.26396@tundra.namei.org>
	 <1337043086.25191.3.camel@falcor>
	 <alpine.LRH.2.02.1205160113550.939@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051516-6148-0000-0000-000005DD8CDD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 01:14 +1000, James Morris wrote:
> On Mon, 14 May 2012, Mimi Zohar wrote:
> 
> > On Tue, 2012-05-15 at 10:29 +1000, James Morris wrote:
> > > On Sun, 13 May 2012, Mimi Zohar wrote:
> > > 
> > > > From: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > > > 
> > > > This patch has been updated to move the ima_file_mmap() call from
> > > > security_file_mmap() to the new vm_mmap() function.
> > > 
> > > Which kernel is this for?
> > 
> > Commit #6be5ceb(VM: add "vm_mmap()" helper function) is in Linus' master
> > tree, but the posted patch is against linux-security/next.
> 
> I'm still not sure what the answer is :-)
> 
> Can this wait until 3.5-rc1?

The patch is a bug fix for the mmap_sem/i_mutex locking problem that has
existed for a quite a while.  (The previous version of the patch has
been waiting since January to be Acked.)  The current version of the
patch applies cleanly to both your #master and #next trees.  As it
hasn't been in linux-next, I'll leave it to your discretion how/when to
upstream it.

thanks,

Mimi

