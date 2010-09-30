Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0I3W1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 18:27:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:57196 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863Ab0I3W1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 18:27:21 -0400
Date: Fri, 1 Oct 2010 00:26:25 +0200
From: Jan Kara <jack@suse.cz>
To: Jan Andres <jandres@gmx.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] isofs: Fix lseek() to position beyond 4 GB
Message-ID: <20100930222625.GH3573@quack.suse.cz>
References: <20100803211814.GA4436@pitr.home.jan>
 <20100804205245.GA5312@pitr.home.jan>
 <20100930221429.GF3573@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930221429.GF3573@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 01-10-10 00:14:30, Jan Kara wrote:
> On Wed 04-08-10 22:52:46, Jan Andres wrote:
> > isofs supports files larger than 4 GB by using multi-extent files.
> > However an lseek() to a position beyond 4 GB in such a file will
> > fail with EINVAL, because s_maxbytes in the isofs superblock is
> > initialized to 2^32-1, and generic_file_llseek() checks against
> > that value.
> > 
> > I therefore suggest increasing the value of s_maxbytes to have
> > full support for large files in isofs. With multi-extent files, file
> > size is only limited by the maximum size of the file system (8 TB),
> > so this seems a reasonable value for s_maxbytes.
>   OK, I had a look into the relevant code and it seems that the isofs
> code should properly handle files upto 4TB and with a small fix (attached)
> upto 8TB as you claim. So I'll take your patch and merge it with Linus.
  Oops, I now noticed that Al has already merged your patch. OK, so I'll
just merge my fix separately.

 								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
