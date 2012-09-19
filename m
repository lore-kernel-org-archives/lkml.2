Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2ISF6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 01:58:15 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:48477 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab2ISF6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 01:58:11 -0400
Message-ID: <50595EF1.6050003@msgid.tls.msk.ru>
Date: Wed, 19 Sep 2012 09:58:09 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alex Lyashkov <umka@cloudlinux.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lve module taint?
References: <87sjaepy67.fsf@rustcorp.com.au>
In-Reply-To: <87sjaepy67.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.09.2012 06:02, Rusty Russell wrote:

> From:	Matthew Garrett <mjg59@srcf.ucam.org>
> Subject: module: taint kernel when lve module is loaded
> Date: Fri, 22 Jun 2012 13:49:31 -0400
> 
> Cloudlinux have a product called lve that includes a kernel module. This
> was previously GPLed but is now under a proprietary license, but the
> module continues to declare MODULE_LICENSE("GPL") and makes use of some
> EXPORT_SYMBOL_GPL symbols. Forcibly taint it in order to avoid this.

> +	/* lve claims to be GPL but upstream won't provide source */
> +	if (strcmp(mod->name, "lve") == 0)
> +		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);

This is setting a, in my opinion, rather bad precedent.  Next we'll
be adding various modules here due to various reasons.

I think this case should be pure political now, not technical.  Ie,
if some project declares itself as GPL, it is not kernel task to
verify that the sources are available or to enforce that.

Thanks,

/mjt
