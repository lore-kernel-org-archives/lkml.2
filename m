Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2CHVOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:14:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33369 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab2CHVOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:14:11 -0500
Date: Thu, 8 Mar 2012 13:14:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Masami Ichikawa <masami256@gmail.com>, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Fix memory leak in sysfs_sd_setsecdata().
Message-ID: <20120308211406.GA24445@kroah.com>
References: <1329777830-2942-1-git-send-email-masami256@gmail.com>
 <m11up2zu03.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11up2zu03.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 01:02:20PM -0800, Eric W. Biederman wrote:
> Masami Ichikawa <masami256@gmail.com> writes:
> 
> > This patch fixies follwing two memory leak patterns that reported by kmemleak.
> > sysfs_sd_setsecdata() is called during sys_lsetxattr() operation.
> > It checks sd->s_iattr is NULL or not. Then if it is NULL, it calls
> > sysfs_init_inode_attrs() to allocate memory.
> > That code is this.
> 
> I don't know how you count two memory leaks.  But there is definitely a
> leak here sd->s_iattr is allocated and then never assigned.  It looks
> like I introduced that leak when I re-factored the code to protect
> the code with sysfs_mutex at the end of 2009.
> 
> I am surprise the securlity label crowd has not been screaming about
> selinux protection not working on sysfs for the last two years.
> 
> I have reviewed the code and the fix looks obvious and correct.
> 
> Greg can you pick this up?

I applied it a while ago to my tree already :)

thanks,

greg k-h
