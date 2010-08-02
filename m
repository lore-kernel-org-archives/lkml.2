Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0HBMYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:24:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50886 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab0HBMYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:24:22 -0400
Date: Mon, 2 Aug 2010 08:24:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ftp.linux.org.uk>, Kees Cook <kees.cook@canonical.com>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
Message-ID: <20100802122421.GA12130@infradead.org>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
 <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 12:18:46PM +1000, James Morris wrote:
> On Fri, 30 Jul 2010, James Morris wrote:
> 
> > One issue which needs to be addressed is to confirm that there is 
> > consensus on the new Yama LSM module.  I had thought there was, based on 
> > list discussion, but have since had differing feedback.
> 
> I'm going to revert the Yama stuff for 2.6.36 -- Christoph has nacked it 
> to me off-list.

I'm also happy to do it on-list, but I really didn't want to do it
before I've actually validated the patches in your tree still are the
same that were objected before.

As mentioned a few times during the past discussion moving broken
code into a LSM doesn't magically fix it.  In fact YAMA is not any kind
of (semi-)coherent security policy like Selinux, smack or similar but
just a random set of hacks that you didn't get past the subsystem
maintainers.

Al gave you some very clear advice how a the sticky check should be
done for symlinks (if we need it at all, which I tend to disagree with),
and the ptrace check completely breaks crash handlers that we have
in all kinds of applications.  If you can get it into the main ptrace
code past Roland and Oleg that's fine, but just pushing it out into
a tree that has percieved easier merge criteria doesn't work.
