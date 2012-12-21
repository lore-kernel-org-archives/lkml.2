Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab2LUFTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:19:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49768 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2LUFTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:19:23 -0500
Date: Fri, 21 Dec 2012 05:19:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Vineet.Gupta1@synopsys.com, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: new architectures, time_t __kernel_long_t
Message-ID: <20121221051921.GQ4939@ZenIV.linux.org.uk>
References: <201211141218.02105.arnd@arndb.de>
 <20121221045731.GO4939@ZenIV.linux.org.uk>
 <50D3ECEB.1070401@zytor.com>
 <20121221050202.GP4939@ZenIV.linux.org.uk>
 <50D3EE1A.7020703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D3EE1A.7020703@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 09:05:30PM -0800, H. Peter Anvin wrote:
> >... as long as we do not have typedef __kernel_foo_t foo_t in linux/types.h.
> >
> 
> In the case of things like nlink_t and dev_t I would suggest we
> explicitly call out the types as kernel and user.  I would suggest
> knlink_t and unlink_t but the latter made me want to stab my eyes
> out due to its confusion potential, so I wonder if we should
> establish a new convention with _kt (kernel type) and _ut (user
> type) suffixes, so nlink_kt and nlink_ut, alternatively one could
> consider k_nlink_t and u_nlink_t.

What the hell for?  _Which_ userland nlink_t, anyway?  We have quite a few
struct stat variants in there.  Sorry, but I really don't see any point
in that, and a lot of potential for confusion.  Marshalling is about the
only thing we need the userland ones for and the code doing it is just fine
with the only object of that type in sight being the field of e.g. struct stat
with given name...
