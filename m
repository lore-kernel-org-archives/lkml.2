Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1AIVZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 16:25:00 -0500
Received: from pqueuea.post.tele.dk ([193.162.153.9]:44854 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab1AIVY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:24:58 -0500
Date: Sun, 9 Jan 2011 22:24:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 1/2] kbuild: asm-generic support
Message-ID: <20110109212434.GA12490@merkur.ravnborg.org>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110109192707.GA12387@merkur.ravnborg.org> <20110109192907.GA12403@merkur.ravnborg.org> <201101092131.27694.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101092131.27694.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 09:31:27PM +0100, Arnd Bergmann wrote:
> > There is an increasing amount of header files
> > shared between individual architectures in asm-generic.
> > To avoid a lot of dummy wrapper files that just
> > include the corresponding file in asm-generic provide
> > some basic support in kbuild for this.
> 
> Looks almost perfect to me now.
> 
> I was about to reply with Reviewed-by, but then it occurred to me
> that scripts/asm-generic.sh is really much more complicated
> than doing the same in Makefile syntax.
> 
> You already create the wrapper files during headers-install, so why
> not also create them from make, where we already have access to the
> file lists in a convenient format.
> 
> Or is there a problem getting at stuff defined in the Kbuild files
> from the prepare stage?

My main issue it that I wanted to offload functionality
from the top-level Makefile.
It contains too much weird stuff already.

I considered writing asm-generic.sh as a small
Makefile but decided for a shell script because there
are more people confident in shell scripts than in Makefile syntax.

	Sam
