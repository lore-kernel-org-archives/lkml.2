Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0GRIuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 04:50:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0GRIt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 04:49:57 -0400
Date: Sun, 18 Jul 2010 04:49:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 09/18] xstat: Make special system filesystems return
 FS_SPECIAL_FL [ver #6]
Message-ID: <20100718084955.GB27794@infradead.org>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
 <20100715021720.5544.19973.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715021720.5544.19973.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

special is not a very useful identifier.  Also what you are returning
is per-filesystem data, not per-file.  This needs to go into statfs,
not into stat.  We're about to introduce flags for statfs, so try
to do it ontop of those.

The same thing applies to the remote flag in the next patch.

