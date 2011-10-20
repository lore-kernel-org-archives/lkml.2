Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1JTOuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 10:50:13 -0400
Received: from lo.gmane.org ([80.91.229.12]:37710 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab1JTOuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 10:50:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 00/17][RFC] ktest updates for v3.2
Date: Thu, 20 Oct 2011 14:31:17 +0000 (UTC)
Message-ID: <loom.20111020T160741-298@post.gmane.org>
References: <20111017160455.498567257@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 209.132.186.34 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.22) Gecko/20110904 Red Hat/3.6.22-1.el6_1 Firefox/3.6.22)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt <at> goodmis.org> writes:

> 
> As it is getting close to the merge window. I want to post the
> patches I will be pushing to Linus. I know most people don't even
> use this, but I figured I would show what's changed since the last
> release.
> 
> This is also the code base I will be using for my tutorial at 
> LinuxCon EU.
> 

Hmm, I have a couple comments.

First, all the new additions such as IF, ELSE, DEFINED, INCLUDE are starting to
reinvent 'make' inside of ktest.pl. At the point those constructs were needed,
I'd probably have gone the opposite way. I would have ripped any special parsing
out of ktest.pl, reducing it to only read simple key=value pairs. Then I would
have renamed sample.conf to Makefile and tweaked it for the syntax. Makefile
would then include Makefile.ktest, which would be where users can go to town
with their own custom "configs" using all the make constructs. It would also
have a couple targets, ktest.conf and ktest. ktest.conf would output the
generated, simple key=value config. ktest would run ktest.pl with the generated
config passed to it, either through a file or by using environment variables. 

My other comment is that it appears a few of the patches from my August
series[*] got dropped. Please keep in mind that without the CONSOLE_RESET_TIME
patch in that series ktest doesn't work with virtual machine consoles, so
afaict, it's a must have. Also the RERUN patch was necessary for me to use ktest
on my last bisect, since the problem was during boot. Indeed, all the patches in
that series were useful at some point, so I'd appreciate if they were all
integrated.

Drew

[*] http://thread.gmane.org/gmane.linux.kernel/1178676

