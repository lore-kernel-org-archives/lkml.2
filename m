Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab1J1I3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 04:29:54 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54517
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159Ab1J1I3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 04:29:52 -0400
Date: Fri, 28 Oct 2011 04:29:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, akpm@linux-foundation.org, toshi.okajima@jp.fujitsu.com
Subject: Re: [PATCH 12/13] vfs: count unlinked inodes
Message-ID: <20111028082950.GA31605@infradead.org>
References: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
 <1318430946-7091-13-git-send-email-miklos@szeredi.hu>
 <20111028060801.GA15345@infradead.org>
 <1319788433.13842.8.camel@tucsk.pomaz.szeredi.hu>
 <20111028080445.GA10318@infradead.org>
 <87hb2t5xzd.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hb2t5xzd.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 10:20:06AM +0200, Miklos Szeredi wrote:
> Okay, so a WARN_ON is not warranted.  Perhaps a printk instead?
> 
> While initializing nlink with zero normally shouldn't be a problem it
> might indicate something unexpected.

Please do a ratelimited printk.  If the log recovery case hits any fs
it will usually do it for tons of inodes in a short period.

Also please try to stick to 80 character lines if possible.

