Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab0EKDie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:38:34 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54928 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991Ab0EKDia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:38:30 -0400
Date: Mon, 10 May 2010 21:38:25 -0600
From: Alex Chiang <achiang@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Colin King <colin.king@canonical.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [107/117] ACPI: DMI init_set_sci_en_on_resume for multiple
 Lenovo ThinkPads
Message-ID: <20100511033825.GA7513@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Colin King <colin.king@canonical.com>,
	Len Brown <len.brown@intel.com>
References: <20100510223700.GA18404@kroah.com>
 <20100510223327.043329892@kvm.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510223327.043329892@kvm.kroah.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm, this patch looks a little wonky.

Why is every entry repeated 3x?

> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Lenovo ThinkPad T410",

[snip]

> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Lenovo ThinkPad T410",

[snip[

> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Lenovo ThinkPad T410",

Oh crap, it's broken upstream too. :(

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=patch;h=07bedca29b0973f36a6b6db36936deed367164ed

Not sure what happened, but I think some sort of hiccup occurred
when the patch was applied, since this is what hit the mailing
lists:

https://patchwork.kernel.org/patch/94711/

Len, Greg, what would you like me to do? I think the cleanest
thing to do to help keep -stable clean would be to:

	a) drop this patch from current -stable queue
	b) revert 07bedca29b09 upstream
	c) apply the patch from patchwork
	d) re-apply to -stable

Thoughts?

Thanks,
/ac
