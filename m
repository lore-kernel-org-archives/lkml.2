Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2K2Vyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:54:52 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57483 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753115Ab2K2Vyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:54:51 -0500
Message-ID: <1354226092.1700.8.camel@joe-AO722>
Subject: Re: [PATCH v3] char/tpm: Use true and false for bools
From: Joe Perches <joe@perches.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 29 Nov 2012 13:54:52 -0800
In-Reply-To: <1354223321-3343-1-git-send-email-peterhuewe@gmx.de>
References: <20121129160627.GB15399@ennui.austin.ibm.com>
	 <1354223321-3343-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-29 at 22:08 +0100, Peter Huewe wrote:
> Bool initializations should use true and false.  Bool tests don't need
> comparisons
[]
> .v3 for this tiny patch... shame on me.

Don't be silly...

> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
[]
> @@ -545,7 +545,7 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>  			rc = -ENODEV;
>  			goto out_err;
>  		}
> -		itpm = (probe == 0) ? 0 : 1;
> +		itpm = !!probe;

Even more trivia:

This !! isn't necessary as ints assigned to bool are converted
by the compiler to 0 or 1.


