Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1BTR5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 12:57:12 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:51083 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab1BTR5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 12:57:11 -0500
Date: Sun, 20 Feb 2011 18:57:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: Add extra gcc checks
Message-ID: <20110220175709.GA5178@merkur.ravnborg.org>
References: <1298219710-9846-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298219710-9846-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 05:35:10PM +0100, Borislav Petkov wrote:
> Add a 'W=1' Makefile switch which adds additional checking per build
> object.
> 
> The idea behind this option is targeted at developers who, in the
> process of writing their code, want to do the occasional
> 
> make W=1 [target.o]
> 
> and let gcc do more extensive code checking for them. Then, they
> could eyeball the output for valid gcc warnings about various
> bugs/discrepancies which are not reported during the normal build
> process.
> 
> For more background information and a use case, read through this
> thread: http://marc.info/?i=20110218091716.GA4384@bicker
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: linux-kbuild@vger.kernel.org
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  Makefile |   31 +++++++++++++++++++++++++++++++
>  1 files changed, 31 insertions(+), 0 deletions(-)

I like the idea.
But can we avoid polluting the top-level Makefile?
That file is full of unreadable stuff, and adding more
is not good.

Makefile.lib or Makefile.build seems like a better place for this.

	Sam
