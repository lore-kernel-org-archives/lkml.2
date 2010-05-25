Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0EYWxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:53:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39697 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab0EYWxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:53:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Regression] Crash in load_module() while freeing args
Date: Wed, 26 May 2010 00:54:52 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>
References: <201005252300.07739.rjw@sisk.pl>
In-Reply-To: <201005252300.07739.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005260054.52122.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 May 2010, Rafael J. Wysocki wrote:
> Hi,
> 
> Recent -git kernels crash for me quite often during boot, reporting that kernel
> paging request could not be satisfied at load_module+0x18e4, which
> corresponds to line 2483 of kernel/module.c for the kernel in question (however
> the same call trace says IP is at precpu_modfree+0x1 at the moment of the
> crash, which seems to point to line 2481 of the same file).  It doesn't happen
> every time, but it does happen often enough to be annoying and the call
> trace is always exactly the same.
> 
> I'm going to revert post-2.6.34 commits that touch kernel/module.c directly
> and see what happens.

I'm not able to reproduce the issue with the following commit reverted:

commit 480b02df3aa9f07d1c7df0cd8be7a5ca73893455
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed May 19 17:33:39 2010 -0600

    module: drop the lock while waiting for module to complete initialization.

Thanks,
Rafael
