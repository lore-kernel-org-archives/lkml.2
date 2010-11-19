Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab0KSTDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:03:34 -0500
Received: from cantor.suse.de ([195.135.220.2]:41402 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab0KSTDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:03:33 -0500
Date: Fri, 19 Nov 2010 11:02:42 -0800
From: Greg KH <gregkh@suse.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: core: do not put noninitialized devices
Message-ID: <20101119190242.GA14328@suse.de>
References: <1290192100-11451-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290192100-11451-1-git-send-email-segoon@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 09:41:40PM +0300, Vasiliy Kulikov wrote:
> If kobject_set_name_vargs() fails then put_device() frees
> device with zero kobj->state_initialized.  This leads to WARN().

Have you seen this happen?

> Divide device_register() call to device_initialize() call before
> kobject_set_name_vargs() and device_add() call after it.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Compile tested only.

I'd prefer not to change this unless you are seeing problems with the
current code.

How did kobject_set_name_vargs() fail for you?

thanks,

greg k-h
