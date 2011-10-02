Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1JBLyu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 07:54:50 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43262
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196Ab1JBLyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 07:54:44 -0400
Date: Sun, 2 Oct 2011 07:54:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Dilger <aedilger@gmail.com>
Cc: Jeff liu <jeff.liu@oracle.com>, Yongqiang Yang <xiaoqiangnk@gmail.com>,
        Dave Young <hidave.darkstar@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [BUG] copy file result with zero
Message-ID: <20111002115438.GA24073@infradead.org>
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com>
 <20111001143900.GH28234@thunk.org>
 <CABqxG0eiRiCSirXi5rBB0bJ2AJSQjF2dje2BcjbVYEYWgf-zpw@mail.gmail.com>
 <A2FF8835-2386-47F9-AFF8-4E09BEC4F80E@oracle.com>
 <89E75765-AC24-4EF4-9547-6EE7A1A38B5A@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89E75765-AC24-4EF4-9547-6EE7A1A38B5A@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 12:59:22AM -0700, Andreas Dilger wrote:
> My understanding is that cp uses the blocks count to determine whether the file is sparse or not.  In the case of delayed allocation (where blocks are not yet allocated, if they are not reflected in the i_blocks count) it might mistakenly think that the file is sparse.

Ext4 fortunatley is smart enough to add the delalloc blocks to st_blocks
for state, just like all other filesystems implementing delayed
allocations.

