Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1D0IZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:25:58 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:32865 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab1D0IZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:25:56 -0400
Date: Wed, 27 Apr 2011 10:25:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3.1] kbuild: implement several W= levels
Message-ID: <20110427082555.GC5726@merkur.ravnborg.org>
References: <20110422110947.GA20715@merkur.ravnborg.org> <1303494642-18594-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303494642-18594-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 07:50:42PM +0200, Borislav Petkov wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> 
> Building a kernel with "make W=1" produce far too much noise
> to be usefull.
> 
> Divide the warning options in three groups:
> 
>     W=1 - warnings that may be relevant and does not occur too often
>     W=2 - warnings that occur quite often but may still be relevant
>     W=3 - the more obscure warnings, can most likely be ignored
> 
> When building init/ on my box the levels produces:
> 
> W=1 - 46 warnings
> W=2 - 863 warnings
> W=3 - 6496 warnings
> 
> Many warnings occur from .h files so fixing one file may have a nice
> effect on the total number of warnings.
> 
> With these changes I am actually tempted to try W=1 now and then.
> Previously there were just too much noise.
> 
> Borislav:
> 
> - make the W= levels exclusive
I do not see the point in this really. This is not what most people would
expect.
When you ask for more you get more - not something else.

We see it with verbose levels where -vv give more output than -v etc.

Anyway - the important thing is to keep the relevant warnings at W=1 level.
Which is independendt of this change.
So consider the input and decide - I do not want to make a fuzz about it.

	Sam
