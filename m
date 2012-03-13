Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200Ab2CMJet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:34:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48727
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760169Ab2CMJer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:34:47 -0400
Date: Tue, 13 Mar 2012 05:34:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, mszeredi@suse.cz
Subject: Re: [PATCH 7/9] vfs: reorganize do_lookup
Message-ID: <20120313093445.GB11797@infradead.org>
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
 <1331038601-20353-8-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331038601-20353-8-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * Don't bother with __d_lookup: callers are for creat as
> +	 * well as unlink, so a lot of the time it would cost
> +	 * a double lookup.
> +	 */
> +	dentry = d_lookup(base, name);

This comment isn't true anymore now, although the actual code should
still be fine given that we already did the __d_lookup before for
regular lookups.
