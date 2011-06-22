Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab1FVPh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:37:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab1FVPh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:37:56 -0400
Date: Wed, 22 Jun 2011 08:37:42 -0700
From: Greg KH <gregkh@suse.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110622153742.GA18983@suse.de>
References: <20110622095341.GA3353@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622095341.GA3353@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 01:53:41PM +0400, Vasiliy Kulikov wrote:
> This patch escapes all characters outside of allowed '\n' plus 0x20-0x7E
> charset passed to printk().
> 
> There are numerous printk() instances with user supplied input as "%s"
> data, and unprivileged user may craft log messages with substrings
> containing control characters via these printk()s.  Control characters
> might fool root viewing the logs via tty.

There are "numerous" places this could happen?  Shouldn't this be
handled by the viewers of the log file and not the kernel itself?

And what could these control characters cause to be "fooled"?

greg k-h
