Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0ENLBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 07:01:15 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:33399 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0ENLBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 07:01:13 -0400
Date: Fri, 14 May 2010 12:58:59 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add a document for the padata interface
Message-ID: <20100514105859.GA2184@secunet.com>
References: <20100512142917.4287bf6e@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512142917.4287bf6e@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 May 2010 11:01:11.0178 (UTC) FILETIME=[C33C1EA0:01CAF354]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 02:29:17PM -0600, Jonathan Corbet wrote:
> +
> +Each task submitted to padata_do_parallel() will, in turn, be passed to
> +exactly one call to the above-mentioned parallel() function, on one CPU, so
> +true parallelism is achieved by submitting multiple tasks.  The workqueue
> +is used to actually make these calls, so parallel() runs in process context
> +and is allowed to sleep.  

We disable the BHs before we call parallel(), so sleeping is not allowed.
This is necessary to keep up with the networking softirq if padata is used
for doing IPsec.

Everything else reads pretty good.

Thanks,

Steffen
