Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2JBP4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:56:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60012
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659Ab2JBP4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:56:46 -0400
Date: Tue, 2 Oct 2012 11:56:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@ZenIV.linux.org.uk, eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH v7 03/49] audit: no need to walk list in audit_inode if
 name is NULL
Message-ID: <20121002155643.GC22698@infradead.org>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
 <1349137018-21948-4-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349137018-21948-4-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 08:16:12PM -0400, Jeff Layton wrote:
> If name is NULL then the condition in the loop will never be true. Also,
> with this change, we can eliminate the check for n->name == NULL since
> the equivalence check will never be true if it is.

Given that name == NULL is a static condition it seems like these
should be two different calls, E.g. audit_dentry and audit_path.

