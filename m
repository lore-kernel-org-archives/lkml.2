Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab0GBOim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 10:38:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:48261 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab0GBOik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 10:38:40 -0400
Subject: Re: reiserfs locking (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Jeff Mahoney <jeffm@jeffreymahoney.com>
In-Reply-To: <20100702143419.GC5324@nowhere>
References: <20100702093451.GA3973@swordfish.minsk.epam.com>
	 <20100702131248.GA5324@nowhere> <1278078267.1917.254.camel@laptop>
	 <20100702143419.GC5324@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 02 Jul 2010 16:38:33 +0200
Message-ID: <1278081513.1917.260.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-02 at 16:34 +0200, Frederic Weisbecker wrote:
> vfs_readdir() locks the directory before calling the fs, and none
> of the nested classes would be in its good right there, as the
> directory is the current inode to work on, not a parent nor a
> child or so. 

Nah, what I was referring to is sticking the i_mutex into a different
class on inode creation, but apparently we already do, see
unlock_new_inode().

So its not a pure directory thing.. 
