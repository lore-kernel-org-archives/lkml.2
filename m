Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1HMCDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 22:03:40 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35639 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093Ab1HMCDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 22:03:39 -0400
X-Sasl-enc: xv7/bKNl3g7H7NyJ1hQvE7LqKcASWeiaHm7HMgF++E9U 1313201018
Date: Fri, 12 Aug 2011 19:00:08 -0700
From: Greg KH <greg@kroah.com>
To: Tonda <as@strmilov.cz>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Module hiding files controlled by sysfs
Message-ID: <20110813020008.GA15554@kroah.com>
References: <1313106903-18702-1-git-send-email-as@strmilov.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313106903-18702-1-git-send-email-as@strmilov.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 01:55:03AM +0200, Tonda wrote:
> diff --git a/fs/hidefiles/hidefiles.c b/fs/hidefiles/hidefiles.c

You forgot your Signed-off-by: line and the rest of the changelog
information explaining what this is, why we would want it, and how you
are going to maintain it.

> +static void disable_write_protection(void)
> +{
> +	unsigned long value;
> +	asm volatile("mov %%cr0,%0" : "=r"(value));
> +	value &= (~WRITEABLE);
> +	asm volatile("mov %0,%%cr0" : : "r"(value));
> +}
> +
> +static void enable_write_protection(void)
> +{
> +	unsigned long value;
> +	asm volatile("mov %%cr0,%0" : "=r"(value));
> +	value |= WRITEABLE;
> +	asm volatile ("mov %0,%%cr0" : : "r"(value));
> +}

Fun stuff, you can do nasty things to a system with this...

