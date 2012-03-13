Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2CMQOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:14:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42698 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab2CMQO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:14:27 -0400
Date: Tue, 13 Mar 2012 09:14:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 3/3] simple_open: Automatically convert to simple_open()
Message-ID: <20120313161417.GB18810@kroah.com>
References: <1331631988-20527-1-git-send-email-sboyd@codeaurora.org>
 <1331631988-20527-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331631988-20527-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 02:46:28AM -0700, Stephen Boyd wrote:
> Many users of debugfs copy the implementation of default_open()
> when they want to support a custom read/write function op. This
> leads to a proliferation of the default_open() implementation
> across the entire tree. Now that the common implementation has
> been consolidated into libfs we can replace all the users of this
> function with simple_open().
> 
> This replacement was done with the following semantic patch:
> 
> <smpl>
> @ open @
> identifier open_f != simple_open;
> identifier i, f;
> @@
> -int open_f(struct inode *i, struct file *f)
> -{
> (
> -if (i->i_private)
> -f->private_data = i->i_private;
> |
> -f->private_data = i->i_private;
> )
> -return 0;
> -}
> 
> @ has_open depends on open @
> identifier fops;
> identifier open.open_f;
> @@
> struct file_operations fops = {
> ...
> -.open = open_f,
> +.open = simple_open,
> ...
> };
> </smpl>
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

