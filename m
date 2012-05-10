Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023Ab2EJPTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:19:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45223 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab2EJPTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:19:45 -0400
Date: Thu, 10 May 2012 08:19:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
Message-ID: <20120510151941.GA18302@kroah.com>
References: <1336027242-372-1-git-send-email-minchan@kernel.org>
 <1336027242-372-3-git-send-email-minchan@kernel.org>
 <4FA28907.9020300@vflare.org>
 <4FA2A2F0.3030509@linux.vnet.ibm.com>
 <4FA33DF6.8060107@kernel.org>
 <20120509201918.GA7288@kroah.com>
 <4FAB21E7.7020703@kernel.org>
 <20120510140215.GC26152@phenom.dumpdata.com>
 <4FABD503.4030808@vflare.org>
 <4FABDA9F.1000105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FABDA9F.1000105@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:11:27AM -0500, Seth Jennings wrote:
> On 05/10/2012 09:47 AM, Nitin Gupta wrote:
> 
> > On 5/10/12 10:02 AM, Konrad Rzeszutek Wilk wrote:
> >> struct zs {
> >>     void *ptr;
> >> };
> >>
> >> And pass that structure around?
> >>
> > 
> > A minor problem is that we store this handle value in a radix tree node.
> > If we wrap it as a struct, then we will not be able to store it directly
> > in the node -- the node will have to point to a 'struct zs'. This will
> > unnecessarily waste sizeof(void *) for every object stored.
> 
> 
> I don't think so. You can use the fact that for a struct zs var, &var
> and &var->ptr are the same.
> 
> For the structure above:
> 
> void * zs_to_void(struct zs *p) { return p->ptr; }
> struct zs * void_to_zs(void *p) { return (struct zs *)p; }

Do like what the rest of the kernel does and pass around *ptr and use
container_of to get 'struct zs'.  Yes, they resolve to the same pointer
right now, but you shouldn't "expect" to to be the same.

greg k-h
