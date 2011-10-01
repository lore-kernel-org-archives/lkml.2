Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1JARzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 13:55:05 -0400
Received: from 1wt.eu ([62.212.114.60]:33297 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab1JARy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 13:54:59 -0400
Date: Sat, 1 Oct 2011 19:54:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andy <akwatts@ymail.com>
Cc: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
Message-ID: <20111001175456.GC18690@1wt.eu>
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com> <20111001141751.GA8937@zeus> <20111001142848.GA27058@kroah.com> <20111001165659.GB18690@1wt.eu> <20111001171916.GA11989@zeus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001171916.GA11989@zeus>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 12:19:16PM -0500, Andy wrote:
> On Sat, Oct 01, 2011 at 06:56:59PM +0200, Willy Tarreau wrote:
> > Result: it's correct. With a bit of scripting, it's easy to match
> > tags signatures with tarballs'.
> 
> I must be doing something wrong. I only have the 2.6 git repo (so my tags
> don't drill down to 2.6.x.y just 2.6.x) but my experiement isn't giving
> the results I expected.
> 
> [Cloned repo]
> $ git archive --format=tar --prefix linux-2.6.39/ v2.6.39 | md5sum
> 482f8bd941def0548a95f34e2d290dfd  -

Indeed I have the same here.

> [Downloaded from kernel.org]
> $ bzcat linux-2.6.39.tar.bz2 | md5sum
> 833d224ee42ddc1e7c2d256368b5d7b3  -

An archive I found from this mirror indeed gave me the same md5 as
yours :

   http://mirror.anl.gov/pub/linux/kernel/v2.6/

OK, found! 2.6 kernels are archived with tar.umask = 022 while I
did not have this config option here. If I fix the umask, I get the
same md5 as in the tarball :

  $ git config tar.umask 022
  $ git archive --format tar --prefix linux-2.6.39/ v2.6.39 | md5sum

So I can redo all the md5 sigs now :-/

Willy

