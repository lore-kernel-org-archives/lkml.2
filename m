Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab2BNI1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 03:27:10 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:59437 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab2BNI1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 03:27:07 -0500
Date: Tue, 14 Feb 2012 09:26:56 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Valdis.Kletnieks@vt.edu
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        ranjith kumar <ranjithproxy@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: how to know list of files accessed
Message-ID: <20120214082656.GA5538@citd.de>
References: <CAG9fbzb=B66ku7bPWjJOZ7_EcShYqORypP8-hsvD-g7z9t4oHA@mail.gmail.com>
 <4F3902F8.3090905@free-electrons.com>
 <8249.1329194664@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8249.1329194664@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.02.2012 23:44, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 13 Feb 2012 13:32:56 +0100, Michael Opdenacker said:
> 
> > An easy way is to run your command with 'strace' to trap all the calls
> > to 'open':
> >
> > strace make 2>&1 | grep open
> 
> You really want 'strace -f make' - the -f flag makes it follow forks, which you
> want to do because it's gcc that's doing most of the actual file I/O, not make.
> 
> Oh.  and you want to redirect that grep into a temporary file and be
> prepared to post-process it with perl or something, there's going to be
> *zillions* of open() syscalls.

Inotify is certainly easier.

When inotifywait from inotify-tools is available:
inotifywait -m -r -e open <dir> > files.opened

This monitors recusivly for the "open" event and writes it into 
files.opened.

In my case that is:
wc -l files.opened
1115553 files.opened

And this number of unique files with directories
sort < files.opened | uniq | wc -l
5454

And this number af unique fiels without dirs.
cat files.opened | grep -v ISDIR | sort | uniq | wc -l
3837

I use "O=../compile_dir" to get the output into another dir, if you 
don't do that all newly created files are also counted, as you also 
"open" them.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

