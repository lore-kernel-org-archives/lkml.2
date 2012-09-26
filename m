Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab2IZQVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:21:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34889 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab2IZQVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:21:49 -0400
Date: Wed, 26 Sep 2012 09:21:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: ktest.pl always returns 0?
Message-ID: <20120926162145.GA32277@kroah.com>
References: <20120925180028.GA22896@kroah.com>
 <1348596917.6786.12.camel@fedora>
 <20120925194019.GA25626@kroah.com>
 <1348605237.22822.19.camel@gandalf.local.home>
 <1348616910.22822.30.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348616910.22822.30.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 07:48:30PM -0400, Steven Rostedt wrote:
> I just forced a build failure to see what ktest would show. This is my
> result:
> 
> cp /home/rostedt/work/git/configs/ixf/config-use /home/rostedt/work/git/nobackup/ixf/trace/.config ... SUCCESS
> touch /home/rostedt/work/git/nobackup/ixf/trace/.config ... SUCCESS
> Applying minimum configurations into /home/rostedt/work/git/nobackup/ixf/trace/.config.new
> mv /home/rostedt/work/git/nobackup/ixf/trace/.config.new /home/rostedt/work/git/nobackup/ixf/trace/.config ... SUCCESS
> GCC_VERSION=4.6.0 distmake-64 O=/home/rostedt/work/git/nobackup/ixf/trace oldnoconfig ... SUCCESS
> GCC_VERSION=4.6.0 distmake-64 O=/home/rostedt/work/git/nobackup/ixf/trace -j40 ... FAILED!
> CRITICAL FAILURE... failed build
>  See /home/rostedt/work/git/nobackup/ixf/ixf.log for more info.
> failed build
> [rostedt@fedora git]$ echo $?
> 25
> 
> 
> So it seems that if DIE_ON_FAILURE is set, it returns non-zero error.

Ugh, you are right, my mistake, it was a bug in my script that I was not
checking the correct return value (for those wondering, my bash script
was writing out a bash script that then got run, I forgot to escape the
"$?" properly, so it was being intrepreted when written out and not when
run.

So sorry for the noise, all is now working just fine.

greg "I should stick to C" k-h
