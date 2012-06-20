Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab2FTIHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:07:00 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:53313 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754168Ab2FTIGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:06:55 -0400
Date: Wed, 20 Jun 2012 12:06:52 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/w1: free the w1_master at w1_free_dev and
 return a correct return value
Message-ID: <20120620080652.GA15937@ioremap.net>
References: <1339949879-26085-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339949879-26085-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Jun 17, 2012 at 09:47:59PM +0530, Devendra Naga (devendra.aaru@gmail.com) wrote:
> the w1_master pointer is allced at the w1_alloc_master and is not freed when called with
> w1_remove_master.
> 
> when w1_alloc_dev fails the return should be -ENODEV as it does
> device_register, and that is the last case where that function
> will fail.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Hmm, looks correct, but I wonder how whatever_free() function happend
not to free its arguments.

Looks like device_unregister() calls release callback, but we do not
provide one.

Greg, please pull it into your tree. Thank you.
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
