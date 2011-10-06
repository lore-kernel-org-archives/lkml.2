Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab1JFTor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:44:47 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36135 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759199Ab1JFToo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:44:44 -0400
X-Sasl-enc: DvHjAXMbprNWkdGOR8esJlh6+vanFJ482OnLzNjqXvR7 1317930282
Date: Thu, 6 Oct 2011 12:44:32 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111006194432.GA21642@kroah.com>
References: <20111006190526.GA13883@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006190526.GA13883@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 03:05:27PM -0400, Dave Jones wrote:
> The number of bug reports we get from people with virtualbox loaded are
> truly astonishing.  It's GPL, but sadly that doesn't mean it's good.
> Nearly all of these bugs look like random corruption. (corrupt linked lists,
> corrupt page tables, and just plain 'weird' crashes).
> 
> This diff adds tainting to the module loader to treat it as we do with stuff
> from staging/ (crap). With this tainting in place, automatic bug filing tools
> can opt out of automatically filing kernel bugs, and inform the user to file
> bugs somewhere more appropriate.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 04379f92..d26c9a3 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2653,6 +2653,10 @@ static int check_module_license_and_versions(struct module *mod)
>  	if (strcmp(mod->name, "ndiswrapper") == 0)
>  		add_taint(TAINT_PROPRIETARY_MODULE);
>  
> +	/* vbox is garbage. */
> +	if (strcmp(mod->name, "vboxdrv") == 0)
> +		add_taint(TAINT_CRAP);

Odds are we should have a list of these types of modules, as I think
there are a few others out there we should mark this way :)

But anyway, I like this, and I think I'll go add it to the openSUSE
kernels so we can avoid the numerous bug reports we get there as well
for this crappy driver.

	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

greg k-h
