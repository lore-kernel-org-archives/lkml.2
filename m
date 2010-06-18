Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab0FRTls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:41:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab0FRTlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:41:45 -0400
Date: Fri, 18 Jun 2010 15:41:18 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Andreas Dilger <andreas.dilger@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       "linux-kernel@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] d_ino considered harmful
Message-ID: <20100618194117.GA24188@shell>
References: <20100616185913.GA15566@shell> <20100616195359.GA24382@shell> <2F857D9A-3B76-4309-8967-4405C6D609F0@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2F857D9A-3B76-4309-8967-4405C6D609F0@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 05:39:17PM -0600, Andreas Dilger wrote:
> On 2010-06-16, at 13:54, Valerie Aurora wrote:
> > On Wed, Jun 16, 2010 at 02:59:13PM -0400, Valerie Aurora wrote:
> >> Who needs d_ino anyway?  I am running a kernel with this patch -
> >> Gnome, a browser, IRC, kernel compile, etc. and everything works.
> > 
> > Gosh, maybe it would help to patch the currently used readdir instead
> > of just old_readdir() (thanks, Arnd).  And return 1 instead of 0 so ls
> > doesn't think all files are deleted (thanks, Andreas).
> > 
> > I'm running a kernel with the below patch and everything still works.
> > Apparently "ls -i" is still using the bogus d_ino performance
> > improvement mentioned here because it returns all 1's for inode
> > number.
> > 
> > http://www.mail-archive.com/bug-findutils@gnu.org/msg02531.html
> 
> I don't see why the presence of d_ino is a "bogus" performance optimization.  It is useful for some things, and replacing this with "1" by no means helps anything IMHO, and destroys some useful optimizations (e.g. finding which inodes may be hard links), so I'm against this patch.

Ah, this particular performance optimization is bogus because the
output result is wrong in the case of mountpoints. (It's a long long
thread but maybe worth reading it all.) In general, there's nothing
wrong with using d_ino as a performance optimization.  I just posted
this patch (and tested it) to see how people actually use d_ino in
real life.  I don't think there's any danger of it being accepted,
although it is useful for testing programs that use d_ino.

Thanks for your help,

-VAL
