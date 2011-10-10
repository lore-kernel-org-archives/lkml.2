Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1JJIlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:41:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62018 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1JJIlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:41:05 -0400
Message-ID: <4E92AF9D.8060702@gmail.com>
Date: Mon, 10 Oct 2011 10:41:01 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
References: <20111006190526.GA13883@redhat.com>
In-Reply-To: <20111006190526.GA13883@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dave,

On 10/06/2011 09:05 PM, Dave Jones wrote:
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
> +
>  	/* driverloader was caught wrongly pretending to be under GPL */
>  	if (strcmp(mod->name, "driverloader") == 0)
>  		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Patch vbox' kernel modules instead?
Seems to mark it as crap, all you have to do is add this to the driver source:
MODULE_INFO(staging, "Y");

Tested this theory by adding that line to snd-usb-audio, it immediately tainted kernel. :)

Cheers,
Maarten
