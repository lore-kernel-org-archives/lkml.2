Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab2EPUFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:05:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab2EPUFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:05:12 -0400
Date: Wed, 16 May 2012 22:04:59 +0200
From: Jan Kara <jack@suse.cz>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/8] Support non-BMP characters in UDF
Message-ID: <20120516200459.GD1687@quack.suse.cz>
References: <4FB2E25E.900@gmail.com>
 <20120516143448.GD27661@quack.suse.cz>
 <4FB3C44F.6080409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FB3C44F.6080409@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-05-12 17:14:23, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> On 16.05.2012 16:34, Jan Kara wrote:
> > On Wed 16-05-12 01:10:22, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> >> I also have a counterpart for mkudffs/udf-tools but sourceforge homepage
> >> seems to be abandoned does anybody know if there is a new homepage for
> >> mkudffs?
  Oh, and I forgot to reply here: mkudffs is really unmaintained. But also
it's not used too much AFAIK. Most people use genisoimage to generate udf
filesystems.

> >   Thanks for the patch!
> 
> You're welcome. Thanks for reviewing.
> 
>  It looks OK but shouldn't we rather use the helper
> > functions you introduced in the NLS code? It look wrong to replicate
> > decoding of UTF16 here.
> > 
> 
> The helper functions are limited to buffers aligned on 16-bit boundary
> which is not the case of this buffer. I see following solutions:
  I see.

> 0) Homegrown like in previous patch
> 1) Add a new "endianness" UTF16_LITTLE_ENDIAN_UNALIGNED
> 2) Split code for "compressed" vs "uncompressed" and copy the string to
> a temporary buffer in "uncompressed" branch.
> 3) Like 2 but make buffer sliding and contain only 2 elements.
> 
> I think 1 or 3 would be the most reasonable. Which solution do you prefer?
  I think 1 would be the best since then it can be easily reused by other
filesystems which may have similar issue.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
