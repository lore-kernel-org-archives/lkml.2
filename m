Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab0CXSGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:06:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50546 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab0CXSGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:06:24 -0400
Date: Wed, 24 Mar 2010 18:06:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
Message-ID: <20100324180622.GS30031@ZenIV.linux.org.uk>
References: <4BAA3493.1030802@panasas.com>
 <20100324160037.GP30031@ZenIV.linux.org.uk>
 <4BAA3828.2070506@panasas.com>
 <20100324160754.GQ30031@ZenIV.linux.org.uk>
 <4BAA398C.5050901@panasas.com>
 <20100324163948.GR30031@ZenIV.linux.org.uk>
 <4BAA48A3.1030801@panasas.com>
 <4BAA4CAC.6060104@panasas.com>
 <4BAA5035.1060906@panasas.com>
 <4BAA52A8.2080304@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA52A8.2080304@panasas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 07:58:00PM +0200, Boaz Harrosh wrote:
> Al hi
> 
> Would you like to attempt a revert of this patch (or group of patches)
> Just to get rid of the thought that git bisect was just peeking the
> wrong guy. Maybe it's just something else? Can you understand the
> relevance of all this?

If you see breakage at that commit and do not see it on its parent, we
do have the right guy...

As for reverting, try reverting 781b16775ba0bb55fac0e1757bf0bd87c8879632
first, then this commit.

How consistent are the effects you are seeing from test to test on the same
kernel?  This one was very interesting, since it seemed to fail with
-EISDIR while opening .git/objects/pack.  Which is a directory and which
should fail with -EISDIR if and only if we pass O_CREAT to open().  And
passing O_CREAT on that one is probably not an intended behaviour of git...

Does anybody else see NFS breakage starting at that commit, BTW?  Other
testcases would be useful...
