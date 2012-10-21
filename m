Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2JUQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 12:25:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47931 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab2JUQZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 12:25:55 -0400
Date: Sun, 21 Oct 2012 09:26:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [ 02/37] lockd: use rpc clients cl_nodename for id encoding
Message-ID: <20121021162618.GB25856@kroah.com>
References: <20121019031302.789593147@linuxfoundation.org>
 <20121019031303.167008948@linuxfoundation.org>
 <20121019231518.GE13292@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019231518.GE13292@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 12:15:18AM +0100, Ben Hutchings wrote:
> On Thu, Oct 18, 2012 at 08:16:25PM -0700, Greg Kroah-Hartman wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Stanislav Kinsbursky <skinsbursky@parallels.com>
> > 
> > commit 303a7ce92064c285a04c870f2dc0192fdb2968cb upstream.
> > 
> > Taking hostname from uts namespace if not safe, because this cuold be
> > performind during umount operation on child reaper death. And in this case
> > current->nsproxy is NULL already.
>  
> In this case (3.0.y) you haven't included the following change
> (commit cb7323fffa85 'lockd: create and use per-net NSM RPC clients on
> MON/UNMON requests') that makes lockd actually use cl_nodename.  I
> think this patch alone won't fix the bug, as nsm_args::nodename can
> end up pointing to freed memory.
> 
> (I also wonder whether clients should really be per-net or per UTS
> namespace, and whether those should be orthogonal namespaces at all.)

Hm, Trond, should I also include the other commit above in the next
3.0-stable release?

Or should this one be dropped?

thanks,

greg k-h
