Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011Ab1D0Uqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:46:45 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:35448 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759954Ab1D0Uqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:46:43 -0400
Date: Wed, 27 Apr 2011 22:46:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@alien8.de>, Michal Marek <mmarek@suse.cz>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v3.2] kbuild: implement several W= levels
Message-ID: <20110427204641.GB9005@merkur.ravnborg.org>
References: <20110427113513.GB18112@eferding.osrc.amd.com> <1303935327-5154-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303935327-5154-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:15:27PM +0200, Borislav Petkov wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> 
> Building a kernel with "make W=1" produces far too much noise to be
> useful.
> 
> Divide the warning options in three groups:
> 
>     W=1 - warnings that may be relevant and does not occur too often
>     W=2 - warnings that occur quite often but may still be relevant
>     W=3 - the more obscure warnings, can most likely be ignored
> 
> When building the whole kernel, those levels produce:
> 
> W=1 - 4859 warnings
> W=2 - 1394 warnings
> W=3 - 86666 warnings
> 
> respectively. Warnings have been counted with Geert's script at
> 
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/linux-log-summary.pl
> 
> Many warnings occur from .h files so fixing one file may have a nice
> effect on the total number of warnings.
> 
> With these changes I am actually tempted to try W=1 now and then.
> Previously there was just too much noise.
> 
> Borislav:
> 
> - make the W= levels exclusive
> - move very noisy and making little sense for the kernel warnings to W=3
> - drop -Woverlength-strings due to useless warning message
> - copy explanatory text for the different warning levels to 'make help'
> - recount warnings per level
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> Cc: Dave Jones <davej@redhat.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Looks good. Michal - please apply.

	Sam
