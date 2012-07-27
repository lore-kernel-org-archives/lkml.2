Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab2G0SMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:12:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37398 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2G0SMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:12:12 -0400
Date: Fri, 27 Jul 2012 11:12:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: sandeep@freescale.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org, galak@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [2/3][PATCH][v2] TDM Framework
Message-ID: <20120727181208.GC23105@kroah.com>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 07:35:38PM +0530, sandeep@freescale.com wrote:
> +static struct kobj_type tdm_type = {
> +	.sysfs_ops = &tdm_ops,
> +	.default_attrs = tdm_attr,
> +};

Ah, also, as per the documentation in the kernel (go look, it's there),
I now get to publicly mock you for ignoring the error messages that
the kernel is giving you when you try to shut down your code path.

Well, to be fair, you are leaking memory like a sieve, so I doubt you
ever saw those error messages because you never cleaned up after
yourself, so perhaps I can forgive you, but your users can't, sorry.
They like to rely on the fact that Linux is a reliable operating system,
don't cause them to doubt that.

Please fix this code, it's horribly broken.  Read
Documentation/kobject.txt for why.  That file was written for a reason,
and not just because we like writing documentation (hint, we hate to...)

Ugh,

greg k-h
