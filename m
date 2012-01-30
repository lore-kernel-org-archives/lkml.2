Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2A3WBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:01:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2A3WBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:01:32 -0500
Date: Mon, 30 Jan 2012 14:01:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanup of rw_copy_check_uvector and
 compat_rw_copy_check_uvector
Message-Id: <20120130140128.037aca27.akpm@linux-foundation.org>
In-Reply-To: <20120130172337.GA12696@redhat.com>
References: <20120130145114.4c084a6a@Gantu.yeoh.info>
	<20120130172337.GA12696@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 18:23:37 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/30, Christopher Yeoh wrote:
> >
> >  ssize_t compat_rw_copy_check_uvector(int type,
> >  		const struct compat_iovec __user *uvector, unsigned long nr_segs,
> >  		unsigned long fast_segs, struct iovec *fast_pointer,
> > -		struct iovec **ret_pointer, int check_access)
> > +		struct iovec **ret_pointer)
> >  {
> >  	compat_ssize_t tot_len;
> >  	struct iovec *iov = *ret_pointer = fast_pointer;
> > @@ -586,7 +586,7 @@ ssize_t compat_rw_copy_check_uvector(int type,
> >  		}
> >  		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
> >  			goto out;
> > -		if (check_access &&
> > +		if (type >=0 &&
> 
> I bet checkpatch.pl will complain, this needs the space after '>' ;)
> 
> Otherwise this is nice cleanup, imho.
> 
> Christopher, this is up to Andrew but perhaps you should update
> the changelog. It should explain what this patch does (overload
> "int type", remove the unnecessary "check_access", etc). It should
> not simply mention the previous discussion.
> 

Yes please.  Put oneself in the position of a developer reading the
changelog two years from now.

Also, please use our conventional comment layout style in fs.h.
