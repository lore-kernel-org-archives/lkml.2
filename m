Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1GSPyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 11:54:37 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53980
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481Ab1GSPyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 11:54:36 -0400
Date: Tue, 19 Jul 2011 11:54:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Curt Wohlgemuth <curtw@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110719155431.GA5631@infradead.org>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
 <20110629005422.GQ32466@dastard>
 <BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
 <20110629081155.GA5558@infradead.org>
 <BANLkTinoFOnQoo3k3KiDgqd7+uBH6shNesxhmVRo9wWr0WCkEw@mail.gmail.com>
 <20110629180010.GB32236@infradead.org>
 <BANLkTi=5Jgrb_wQ_AKn3LJOYERTcTix01BCGPYnjGi4iJZhxgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=5Jgrb_wQ_AKn3LJOYERTcTix01BCGPYnjGi4iJZhxgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 02:30:17PM -0700, Curt Wohlgemuth wrote:
> I can definitely see how tagging with the start of sync would be
> helpful; also how going from three to two passes seems like a
> no-brainer.
> 
> But what's the real point of doing even two passes -- one SYNC_NONE
> followed by one SYNC_ALL?  Is it try to get through as many inodes as
> possible before we potentially lock up by waiting on an inode on an
> unavailable device?

Yes.  Or at least that's the idea, I'd love to see an actual
prove for it.

