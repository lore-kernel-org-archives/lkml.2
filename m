Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1HSPyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:54:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45542 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1HSPyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:54:11 -0400
Subject: Re: [PATCH] ubifs: Do not build debug messages with
 CONFIG_UBIFS_FS_DEBUG disabled
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Michal Marek <mmarek@suse.cz>
Cc: adrian.hunter@intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 19 Aug 2011 18:55:56 +0300
In-Reply-To: <1313058586-24239-1-git-send-email-mmarek@suse.cz>
References: <1313058586-24239-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313769360.6607.70.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 12:29 +0200, Michal Marek wrote:
> With
>   $ grep -e UBIFS_FS_DEBUG -e DYNAMIC_DEBUG .config
>   # CONFIG_UBIFS_FS_DEBUG is not set
>   CONFIG_DYNAMIC_DEBUG=y
> 
> Debug messages are kept in the object files due to the
> dynamic_pr_debug() macro, even if they are never going to be printed:
>   $ make fs/ubifs/super.o
>   $ strings fs/ubifs/super.o | grep 'compiled on'
>   compiled on:         Aug 11 2011 at 12:21:38
> 
> Use plain printk to fix this.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Good catch, thanks! Pushed to ubifs-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

