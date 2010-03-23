Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0CWPPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:15:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40624 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab0CWPPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:15:51 -0400
Date: Tue, 23 Mar 2010 15:15:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
 ioctl
Message-ID: <20100323151550.GK30031@ZenIV.linux.org.uk>
References: <20100323142200.GA2381@localhost.localdomain>
 <20100323142843.GG30031@ZenIV.linux.org.uk>
 <20100323143456.GC2381@localhost.localdomain>
 <20100323144828.GH30031@ZenIV.linux.org.uk>
 <20100323150301.GD2381@localhost.localdomain>
 <20100323150923.GI30031@ZenIV.linux.org.uk>
 <20100323151246.GJ30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323151246.GJ30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 03:12:46PM +0000, Al Viro wrote:
> On Tue, Mar 23, 2010 at 03:09:23PM +0000, Al Viro wrote:
> > On Tue, Mar 23, 2010 at 11:03:01AM -0400, Josef Bacik wrote:
> > > > sb is an active reference
> > > > 
> > > 
> > > I don't understand how this is an active reference?  We are talking about
> > > s_active right?
> > 
> > It's an opened file, for crying out loud!  If there is anything that makes
> > sure that superblock will stay alive, that is it...

Grr...  Make that "is alive and can be aliased without any problems, so
atomic_inc(sb->s_active) in caller would do just fine."
