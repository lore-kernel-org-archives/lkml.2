Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab1FFWaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:30:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53972 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1FFWae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:30:34 -0400
Date: Mon, 6 Jun 2011 23:30:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lacombar@gmail.com
Subject: Re: [PATCH -v2] vfs: make unlink() return ENOENT in preference to
 EROFS
Message-ID: <20110606223030.GN11521@ZenIV.linux.org.uk>
References: <BANLkTimX_R8-mT4PqAhqwvCPm_-bcDFqVQ@mail.gmail.com>
 <1307393893-28672-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307393893-28672-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 04:58:13PM -0400, Theodore Ts'o wrote:
> If user space attempts to unlink a non-existent file, and the file
> system is mounted read-only, return ENOENT instead of EROFS.  Either
> error code is arguably valid/correct, but ENOENT is a more specific
> error message.

Umm...  I can live with that.  What about rmdir(2)?  We have similar situation
there as well.  If we care about one, why not the other?

Mind you, I'm not at all convinced that it matters enough to bother, but
yes, ENOENT is a bit more specific (and likelier to be handled by luserland
code).
