Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0DWT00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:26:26 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:59724 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab0DWT0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E/VFllqrvvJ9tChRXPlRQM8B0/0pTgWWX8LMo7baMbsri4XJcgTTJ05QbnhsAIkNBp
         mqZNWi5NmlAwQwoIgae42a5bpxYB3/W5UTLnbahJov1RARMgHRx3FvVqZbn1R4D7n3/u
         bIBhNv5hP1QgNGLibbK7vjo+BK0OfAStxuFqo=
Date: Sat, 24 Apr 2010 22:27:35 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: fix tid fdinfo
Message-ID: <20100424192735.GA5157@x200>
References: <4BD1BF57.7070201@redhat.com>
 <20100423111620.100840fe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423111620.100840fe.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 11:16:20AM -0700, Andrew Morton wrote:
> On Fri, 23 Apr 2010 17:40:07 +0200
> > -	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fd_operations),
> > +	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),

> hm, the code's been like that for over a year.  What are the
> user-visible effects of the bug, and of this change?

/proc/*/task/*/fdinfo contains symlinks to opened files like /proc/*/fd/
which is cool bug :-)
