Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0HCKAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:00:10 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33548 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0HCKAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:00:08 -0400
Date: Tue, 3 Aug 2010 12:00:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: hacklu <embedway.linux@gmail.com>
Cc: Am?rico Wang <xiyou.wangcong@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: how about KBUILD_MODNAME
Message-ID: <20100803100006.GA19424@merkur.ravnborg.org>
References: <201008031511572638256@gmail.com> <201008031735377545190@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008031735377545190@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 05:35:40PM +0800, hacklu wrote:
> 
> I am compiling the boardcom's driver now.
> the driver had defined EXTRA_CFLAGS = -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags) 
> in the a.makefile.
> and the a.makefile was included by b.makefile.
> when in the b.makefile,
> there is this command.
>  $(CC) $(DEPS_OPT) $(CFLAGS) $(EXTRA_CFLAGS) -o $@ -c $< ;) 
> 
> I had add "echo $(EXTRA_CFLAGS)" before this line;but returns NULL;
> 
> so I suspicion the $(EXTRA_CFLAGS) hasn't been work.
> 
> I aslo try to add "export EXTRA_CFLAGS" in a.makefile,but it doesn't work either.
> 
> the problem has puzzled me for some days.
> 
> help me please~~


It looks like the driver uses the old 2.4 way to define a Makefile.
This will not work with 2.6.

What you need to do is to define a Makefile (*) like you would
if the driver was included in the kernel and then build
it using the following command:

make -C path/to/kernel/ M=`pwd`

The kernel shall be built before you do this as the method uses
information from the buitl kernel.

(*) The Makefile may not refer to new CONFIG_ symbols.
So it likely looks like this:

obj-m := foo.o bar.o

Do not be suprised that the Makefile becomes much much simpler - this is expected.

	Sam
