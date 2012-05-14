Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab2ENXC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:02:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab2ENXCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:02:55 -0400
Date: Tue, 15 May 2012 01:02:40 +0200
From: Jan Kara <jack@suse.cz>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix minixfs size check
Message-ID: <20120514230240.GZ5353@quack.suse.cz>
References: <4FAFBBC7.9020101@gmail.com>
 <20120514221948.GV5353@quack.suse.cz>
 <4FB18850.8090704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FB18850.8090704@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-05-12 00:33:52, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> On 15.05.2012 00:19, Jan Kara wrote:
> 
> > On Sun 13-05-12 15:48:55, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> >> minixfs file size check is buggy and it doesn't allow creating a block which
> >> can't be fully filled
> >   Umm, I'm not really minix expert but who'd set s_max_size to something
> > which is not a multiple of block size? This looks rather artifical problem
> > to me...
> > 
> 
> The usual and natural limit comes from interpreting 32-bit size field as
> signed or unsigned. So it's either 2G - 1 or 4G - 1. Neither of which is
> a multiple of block size.
  Oh, right. Then your patch should be OK, just it's enough to cast one of
the arguments to u64. And BTW looking at minix, it should also set
s_maxbytes to s_max_size. Otherwise it will be always limited by
MAX_NON_LFS which is 2^31-1.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
