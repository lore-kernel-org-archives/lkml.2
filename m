Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab2LJRfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:35:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2LJRfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:35:03 -0500
X-Authority-Analysis: v=2.0 cv=JuRzXbEC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=d1PCtoQzn7UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=L9Opr7swBlwA:10 a=VwQbUJbxAAAA:8 a=btZuAMl-AAAA:8 a=JJkU0fd-YsQOP7eFUUIA:9 a=PUjeQqilurYA:10 a=HEdnscJc8mAA:10 a=U62fhAwekXMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355160900.17101.229.camel@gandalf.local.home>
Subject: Missing tags in my local stable git repo
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Dec 2012 12:35:00 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I'm curious if you are removing tags from your git repo on kernel.org.
I've been getting the following errors on my own repos. I have a
linus.git repo that mirrors, Linus's tree, and a stable.git repo based
off of my linus.git and it clones your stable.git tree on kernel.org.
But recently after daily updates and garbage collections, my work repo
that is based off of my stable.git repo gave me this:

error: refs/tags/v2.6.31.1 does not point to a valid object!
error: refs/tags/v2.6.31.10 does not point to a valid object!
error: refs/tags/v2.6.31.11 does not point to a valid object!
error: refs/tags/v2.6.31.12 does not point to a valid object!
error: refs/tags/v2.6.31.2 does not point to a valid object!
error: refs/tags/v2.6.31.3 does not point to a valid object!
error: refs/tags/v2.6.31.4 does not point to a valid object!
error: refs/tags/v2.6.31.5 does not point to a valid object!
error: refs/tags/v2.6.31.6 does not point to a valid object!
error: refs/tags/v2.6.31.7 does not point to a valid object!
error: refs/tags/v2.6.31.8 does not point to a valid object!
error: refs/tags/v2.6.31.9 does not point to a valid object!
error: refs/tags/v2.6.33.1 does not point to a valid object!
error: refs/tags/v2.6.33.2 does not point to a valid object!
error: refs/tags/v2.6.33.3 does not point to a valid object!
error: refs/tags/v2.6.33.4 does not point to a valid object!
error: refs/tags/v2.6.33.5 does not point to a valid object!
error: refs/tags/v2.6.33.6 does not point to a valid object!
error: refs/tags/v2.6.33.7 does not point to a valid object!

This repo has the following alternates:

$ cat .git/objects/info/alternates
/home/rostedt/work/git/nobackup/linus.git/objects
/home/rostedt/work/git/nobackup/stable.git/objects


$ cat ~/work/git/nobackup/stable.git/objects/info/alternates 
/home/rostedt/work/git/nobackup/linus.git//objects

And the stable.git remotes look like:

origin  /home/rostedt/work/git/nobackup/linus.git/ (fetch)
origin  /home/rostedt/work/git/nobackup/linus.git/ (push)
stable  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git (fetch)
stable  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git (push)

My linus.git tree is simply a bare tree that mirrors Linus's tree:

origin  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git (fetch)
origin  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git (push)

I have a crontab that updates these every night with a 'git remote
update' and once a week they do a 'git gc' on these repos. I notice the
above issues after the git gc.

I'm not sure where the problem arised, but did you do any cleanups of
tags on the stable git repo?

$ git fetch stable v2.6.33.4 
error: Could not read 15b059e0f9e31f0e7f6b5397368054c005949fea
error: Could not read 5e20b95750867086fff98e5c3eaa00c3bc01d8ee
remote: Counting objects: 1, done.
remote: Total 1 (delta 0), reused 1 (delta 0)
Unpacking objects: 100% (1/1), done.
fatal: bad object 4640b4e7d9919e9629fe8456df94f71658431ef9
error: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git did not send all necessary objects


Again, I'm not sure if this is something with me, or something with the
kernel.org stable tree.

Thanks,

-- Steve


