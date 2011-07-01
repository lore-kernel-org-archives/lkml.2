Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1GANrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:47:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab1GANrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:47:35 -0400
Date: Fri, 1 Jul 2011 15:47:34 +0200
From: Michal Marek <mmarek@suse.cz>
To: Peter Foley <pefoley2@verizon.net>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH V2] kbuild: silence generated makefile message
Message-ID: <20110701134733.GB25895@sepie.suse.cz>
References: <alpine.LNX.2.00.1106271619350.24034@linux>
 <BANLkTimrUYk-8GSsf35mUmLVBAaO84R6dA@mail.gmail.com>
 <alpine.LNX.2.00.1106271915160.38876@linux>
 <alpine.LNX.2.00.1106271932480.13060@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106271932480.13060@linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 07:33:54PM -0400, Peter Foley wrote:
> 
> This patch silences the "make -C /usr/src/git O=/usr/src/git/build/." 
> message shown when using the generated makefile in KBUILD_OUTDIR.
> 
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
> 
> V2: Show message when V=1
> 
>  scripts/mkmakefile |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/mkmakefile b/scripts/mkmakefile
> index 5325423..ea26f37 100644
> --- a/scripts/mkmakefile
> +++ b/scripts/mkmakefile
> @@ -30,6 +30,10 @@ PATCHLEVEL = $4
>  lastword = \$(word \$(words \$(1)),\$(1))
>  makedir := \$(dir \$(call lastword,\$(MAKEFILE_LIST)))
>  
> +ifneq (\$(V),1)
> +Q := @
> +endif

Please check if V=1 is passed on the commandline and not set in the
environmnent, like the toplevel Makefile does:

ifeq ("$(origin V)", "command line")
...

Michal
