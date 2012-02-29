Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab2B2JIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:08:11 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57409
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618Ab2B2JIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:08:06 -0500
Date: Wed, 29 Feb 2012 04:08:03 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Zach Brown <zab@zabbo.net>
Cc: Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/22] loop: Issue O_DIRECT aio with pages
Message-ID: <20120229090803.GA9995@infradead.org>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
 <20120228092926.GA2766@infradead.org>
 <4F4CEF5A.1020207@zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4CEF5A.1020207@zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:14:34AM -0500, Zach Brown wrote:
> Yeah, that's reasonable.  Perhaps obviously, we started with new entry
> points to minimize the amount of churn we'd have to go through to test
> the change in behaviour.
> 
> It's going to be messy to try and abstract away the pinning and dirtying
> of the iter regions from direct IO through the iter interface, but maybe
> not horribly so.

I don't really care to much about the implementation inside fs/direct-io.c
(at least for now - once I see it I might still scream "bloody
murder!").

The point is to pass the iov_iter all the way down to a common entry
point in fs/direct-io.c, so that the filesystems don't have to care
for that difference.
