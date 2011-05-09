Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1EIOGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:06:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57378 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1EIOGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:06:19 -0400
Date: Mon, 9 May 2011 10:06:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hch@infradead.org
Subject: Re: [PATCH] fs: kill default_llseek
Message-ID: <20110509140614.GB7669@infradead.org>
References: <1304605677-1882-1-git-send-email-josef@redhat.com>
 <201105081623.39876.arnd@arndb.de>
 <4DC7EAD7.9070606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC7EAD7.9070606@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 09:23:35AM -0400, Josef Bacik wrote:
> So every sb has s_maxbytes set to something, is this not acceptable
> for character devices?  I guess some can let you seek well past this
> point so we should just do some if (S_ISCHR()) return or whatever?

Probably for all special files just to be sure, although
pipes/sockets/fifos aren't searchable, and block devices tend to
get redirected to their own superblock.

