Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1D0DSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 23:18:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49930 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1D0DSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 23:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZM4SN08CgXRvTySjK0FCx85zk4otOWgU/8tLm0HCfU70Gb0EE7dXbAeR4+bj2c0rve
         f+xGKhEWnubEYpKuVgpFef22HOUwPJtRsSpGZ73dYcG1PvdLS2lXtpb02G7pxx8+K9fB
         mCzJPZkWfBRKjnuliLh9O/YFfvnS+vAyQuu/U=
Date: Wed, 27 Apr 2011 06:18:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to export information larger than PROC_BLOCK_SIZE via /proc
 file system?
Message-ID: <20110427031844.GA5595@p183>
References: <BANLkTinQJ6wzOR++c-OSiCkf=MjOU=y=1A@mail.gmail.com>
 <BANLkTik+9oz9fbeTwS4qd32ukw6uPHtrWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik+9oz9fbeTwS4qd32ukw6uPHtrWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 11:00:32AM +0800, Am??rico Wang wrote:
> On Wed, Apr 27, 2011 at 8:54 AM, Jidong Xiao <jidong.xiao@gmail.com> wrote:
> > Hi,
> >
> > I am tracing some data inside the kernel, and I plan to export the
> > tracing data through /proc file system. I created a file under /proc
> > file system, and I use cat to display the tracing data. However, every
> > time there is only 3072 bytes data displayed, which is the size
> > defined by PROC_BLOCK_SIZE. And I wonder that how to export
> > information more than that limit? Judging from the function
> > fs/proc/generic.c/proc_file_read(), if the size returned by my
> > read_proc function is large than a PAGE_SIZE, then I will get a
> > KERN_ERR message which says "proc_file_read: Apparent buffer
> > overflow!". Any help would be appreciated!
> >
> 
> Why not switch to use debugfs?

Or use seq_file/proc_create.
