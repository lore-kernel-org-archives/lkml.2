Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293Ab2JXDSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:18:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54117 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960Ab2JXDSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:18:12 -0400
Date: Tue, 23 Oct 2012 20:18:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] firmware loader: introduce kernel parameter to
 customize fw search path
Message-ID: <20121024031845.GA11255@kroah.com>
References: <1351046993-2220-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351046993-2220-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 10:49:53AM +0800, Ming Lei wrote:
> This patch introduces one kernel parameter of 'fw_path' to support
> customizing firmware image search path, so that people can use its
> own firmware path if the default built-in paths can't meet their demand[1].
> 
> [1], https://lkml.org/lkml/2012/10/11/337
> 
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Ick, no, not another kernel boot parameter.  I would prefer the /proc/
file solution instead, just like /proc/sys/kernel/hotplug is.

But, that really wouldn't work for boot time, so, again just like
hotplug works, make it also a Kconfig option for those distros that
build their own kernels and keep their firmware in odd places, or don't
have a /lib/ directory, can override it easily.

thanks,

greg k-h
