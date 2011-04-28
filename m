Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab1D1QSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:18:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab1D1QSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:18:13 -0400
Date: Thu, 28 Apr 2011 18:18:07 +0200
From: Michal Marek <mmarek@suse.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v3.2] kbuild: implement several W= levels
Message-ID: <20110428161807.GB1619@sepie.suse.cz>
References: <20110427113513.GB18112@eferding.osrc.amd.com>
 <1303935327-5154-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303935327-5154-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Applied to kbuild-2.6.git#kbuild, thanks!

Michal
