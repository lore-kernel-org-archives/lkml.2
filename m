Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2FXJUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 05:20:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42832 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2FXJUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 05:20:35 -0400
Date: Sun, 24 Jun 2012 10:20:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: wfg@linux.intel.com
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: vfs/for-next: NULL pointer dereference in sysfs_dentry_delete()
Message-ID: <20120624092034.GP14083@ZenIV.linux.org.uk>
References: <20120624080740.GA8331@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120624080740.GA8331@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 04:07:40PM +0800, wfg@linux.intel.com wrote:
> Hi Al,
> 
> This commit
> 
>         commit 08eaca322cb2720f1730e46793dee9464ebd26f2
>         Author: Al Viro <viro@zeniv.linux.org.uk>
>         Date:   Thu Jun 7 20:51:39 2012 -0400
> 
>             sysfs: switch to ->s_d_op and ->d_release()
>             
> triggers the following bug:

Arrgh....
It needs
static int sysfs_dentry_delete(const struct dentry *dentry)
{
        struct sysfs_dirent *sd = dentry->d_fsdata;
        return !(sd && !(sd->s_flags & SYSFS_FLAG_REMOVED));
}

Will fold and push in a few

