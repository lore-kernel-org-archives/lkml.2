Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0DVPUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:20:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab0DVPUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:20:39 -0400
Date: Thu, 22 Apr 2010 17:20:23 +0200
From: Jan Kara <jack@suse.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Jan Kara <jack@suse.cz>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: Do not corrupt backing device for inode
Message-ID: <20100422152023.GD5805@quack.suse.cz>
References: <20100415172300.GF3561@quack.suse.cz>
 <1271863269-5423-1-git-send-email-kirill@shutemov.name>
 <1271934535.11751.1550.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271934535.11751.1550.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 22-04-10 12:08:55, David Woodhouse wrote:
> On Wed, 2010-04-21 at 18:21 +0300, Kirill A. Shutemov wrote:
> > +		/*
> > +		 * We cannot modify file->f_mapping->backing_dev_info directly,
> > +		 * because it will corrupt backing device for inode, since
> > +		 * inode->i_mapping is equal to file->f_mapping. So we have to
> > +		 * copy f_mapping first.
> > +		 */
> > +		file->f_mapping = kmalloc(sizeof(*file->f_mapping), GFP_KERNEL);
> > +		memcpy(file->f_mapping, inode->i_mapping,
> > +				sizeof(*file->f_mapping));
> >  		file->f_mapping->backing_dev_info = mtd->backing_dev_info;
> > +	}
> 
> Ick. What about the rest of file->f_mapping? That'll still be inherited.
> 
> Jan pointed at drivers/char/raw.c as an example, but that doesn't do
> anything as ugly as this -- that sets file->f_mapping to point at
> bdev->bd_inode->i_mapping instead.
> 
> I suspect we should do something similar -- have an inode for the MTD
> device, with a valid i_data of its own.
  Yes, that's what I meant by my suggestion... Sorry if I wasn't clear
enough.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
