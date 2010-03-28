Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab0C1Xis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 19:38:48 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37194 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab0C1Xiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 19:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sLNsMVlEIXYPJIEEahVJJ9dbUyNjDetNaVbeGw8icvxNTyu02MONPrbF8NBeTVMThP
         7LGqjOFAOeztaGvOZTY7Ava4jCnJ4VwNL2bh2NyiAaC8cOMft1+Q65JFWqBURAm3DwVi
         V0d6b7ddluR6FGXuJIk6kZ6AEHKdXj1HD7qM0=
Date: Mon, 29 Mar 2010 01:38:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100328233847.GJ5116@nowhere>
References: <201003242240.54907.arnd@arndb.de> <20100328231847.GH5116@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100328231847.GH5116@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 01:18:48AM +0200, Frederic Weisbecker wrote:
> On Wed, Mar 24, 2010 at 10:40:54PM +0100, Arnd Bergmann wrote:
> > Arnd Bergmann (44):
> >       [...]
> >       procfs: kill BKL in llseek
> 
> 
> About this one, there is a "sensible" part:
> 
> 
> @@ -1943,7 +1949,7 @@ static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
>  }
>  
>  static const struct file_operations proc_fdinfo_file_operations = {
> -	.open		= nonseekable_open,
> +	.llseek		= generic_file_llseek,
>  	.read		= proc_fdinfo_read,
>  };
>  
> 
> Replacing default_llseek() by generic_file_llseek() as you
> did for most of the other parts is fine.
> 
> But the above changes the semantics as it makes it seekable.
> Why not just keeping it as is? It just ends up in no_llseek().
> 


There is also the ioctl part that takes the bkl in procfs.
I'll just check nothing weird happens there wrt file pos.
We probably first need to pushdown the bkl in the procfs
ioctl handlers.

