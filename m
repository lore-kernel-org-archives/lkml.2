Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2DRPca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:32:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55098 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2DRPc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:32:28 -0400
Date: Wed, 18 Apr 2012 16:32:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alex Elder <elder@dreamhost.com>
Cc: Sage Weil <sage@newdream.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: osd_req_encode_op() breakage?
Message-ID: <20120418153225.GA6589@ZenIV.linux.org.uk>
References: <4F8ED911.90309@dreamhost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8ED911.90309@dreamhost.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 10:09:05AM -0500, Alex Elder wrote:

> Yes, you are absolutely correct.
> 
> We have obviously not done endianness checks in this code for
> some time.
> 
> I will commit a fix and credit you for it.  I'll also make sure
> we are doing proper testing for this sort of thing on a regular
> basis.

FWIW, that got caught by sparse, but I would really recommend _testing_
on big-endian - getting an emulated headless e.g. mips box is fairly
easy with qemu; I'd done that with debian big-endian mips userland on
emulated malta and it didn't take much work to set up.

Speaking of sparse, I think we simply ought to add -D__CHECK_ENDIAN__
to CHECKFLAGS in top-level Makefile.  It's not _that_ much noise
these days...  Not sure which tree should that go through, though...
