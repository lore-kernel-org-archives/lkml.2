Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab0IMDM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:12:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43523 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab0IMDM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:12:56 -0400
Date: Sun, 12 Sep 2010 20:11:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: 2.6.36-rc3 - Unable to build: "Error: input truncated"
Message-Id: <20100912201152.a4ada04a.randy.dunlap@oracle.com>
In-Reply-To: <4C8D5D41.90104@tuxonice.net>
References: <4C8CB5A1.9040500@tuxonice.net>
	<201009121934.37033.rjw@sisk.pl>
	<4C8D5D41.90104@tuxonice.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 09:07:45 +1000 Nigel Cunningham wrote:

> Hi.
> 
> On 13/09/10 03:34, Rafael J. Wysocki wrote:
> > On Sunday, September 12, 2010, Nigel Cunningham wrote:
> >> Hi all.
> >>
> >> I'm unable to compile the latest kernel and git bisect isn't helping:
> >
> > Did you try to save .config, run "make distclean" and restore .config?
> 
> I hadn't tried that, but had done git reset --hard and make clean 
> menuconfig bzImage. Trying distclean doesn't help, I'm afraid. Perhaps I 
> should attach my .config. I'm running a 32 bit kernel/distro on a 64 bit 
> machine if that makes any difference.


Try to strace scripts/mod/mk_elfconfig to see why it is producing
that error message:

   scripts/mod/mk_elfconfig < scripts/mod/empty.o > scripts/mod/elfconfig.h
Error: input truncated

I guess that the empty.o file is not in the expected format.
Who owns that stuff, anyway?

You should probably post the empty.o file so that interested parties can
try to debug the problem.

I built the kernel just fine with the .config file that you posted.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
