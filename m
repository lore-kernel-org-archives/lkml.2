Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2HNWWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:22:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab2HNWWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:22:40 -0400
Date: Wed, 15 Aug 2012 00:22:38 +0200
From: Jan Kara <jack@suse.cz>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: Bug in UDF, setting larger file size when data in ICB
Message-ID: <20120814222238.GO7122@quack.suse.cz>
References: <500D6B87.7070700@mev.co.uk>
 <500D7F39.2000506@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500D7F39.2000506@mev.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 23-07-12 17:43:37, Ian Abbott wrote:
> On 2012-07-23 16:19, Ian Abbott wrote:
> >Hi folks,
> >
> >in fs/udf/inode.c, udf_setsize(), if the new size is larger than the old
> >size and the old data is in the ICB and the new size still fits in the
> >ICB (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB and iinfo->i_lenAlloc
> >= newsize), udf_extend_file() is called which promptly calls BUG()
> >because it does not like this i_alloc_type value.
> >
> >I think the simplest fix would be to add a 'goto' after the assignment
> >to iinfo->i_lenAlloc, bypassing the call to udf_extend_file().
> 
> Jan is on vacation until early August, so I submitted my own patch:
> 
> Date: Mon, 23 Jul 2012 17:39:29 +0100
> Subject: [PATCH] udf: fix udf_setsize() for file data in ICB
> Message-ID: <1343061569-3629-1-git-send-email-abbotti@mev.co.uk>
  Thanks for the patch. I've added it to my tree and will send it to Linus
soon.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
