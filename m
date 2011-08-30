Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab1H3DvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 23:51:12 -0400
Received: from govinda.solana.com ([198.99.130.30]:38303 "EHLO
	govinda.addtoit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1H3DvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 23:51:07 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Aug 2011 23:51:04 EDT
Date: Mon, 29 Aug 2011 23:41:34 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [uml-devel] [PATCH 8/9] um: fix strrchr problems
Message-ID: <20110830034134.GA20366@parts.user-mode-linux.org>
References: <1314634419-24766-1-git-send-email-richard@nod.at>
 <1314634419-24766-9-git-send-email-richard@nod.at>
 <20110829142705.5be82d7c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829142705.5be82d7c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 02:27:05PM -0700, Andrew Morton wrote:
> ok, I give up.  How does this work?

It fixes symbol clashes between libc and kernel names by redefining
the kernel name in any file that is built against kernel headers.

This fix is fairly nasty, but simple and it works.  My long-range plan
was to build all of the kernel objects into a single self-contained
object with no dangling references and link it into the userspace
stuff, but I never acquired the ld-fu to pull that off.

				Jeff
