Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0EHAyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 20:54:44 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:64615 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0EHAyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 20:54:43 -0400
X-Authority-Analysis: v=1.1 cv=cbUT6B7wEcA8xSNNYfl1w4X1FOlyJIGpOcdyq2z1u20= c=1 sm=0 a=jbQAF9jGaHUA:10 a=IkcTkHD0fZMA:10 a=Ojb4KS2nAQbJgCTPCAnicg==:17 a=k-b6faDFtAYqCehWhMYA:9 a=vsr8YYNk1BBZ8GYIpIcmunC260wA:4 a=QEXdDO2ut3YA:10 a=Ojb4KS2nAQbJgCTPCAnicg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.121.210.183
Subject: Re: unified page and buffer cache?
From: Phillip Susi <psusi@cfl.rr.com>
To: tytso@mit.edu
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100508004617.GF18762@thunk.org>
References: <4BCC7C05.8000803@cfl.rr.com> <4BE417CB.7000806@cfl.rr.com>
	 <20100507135329.GA17259@parisc-linux.org> <4BE4359E.9020400@cfl.rr.com>
	 <20100508004617.GF18762@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 20:54:41 -0400
Message-ID: <1273280081.2444.5.camel@faldara>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would it be possible to somehow keep the current buffer heads, but
associate them with the inode such that readahead() on the directory
would work?

On Fri, 2010-05-07 at 20:46 -0400, tytso@mit.edu wrote:
> Ext2 does use the page cache for directories.  Ext3 and Ext4 access
> directories via buffer heads because of the journaling requirement.
> 
> In *theory* they could be modified to use the page cache, given that
> we can do data journaling for files, and files live in the page cache
> --- however, for cases where the PAGE_SIZE > FS_BLOCKSIZE, which will
> happen if you are using 1k or 2k block filesystems, or on the Power
> Architecture or on the Itanic where the page size is 16k, updates to
> the directory will be much less efficient, since we journal changes to
> data files on page granularity and not buffer granuality.
> 
> Furthermore, someone would have to supply me with the patches; it's
> pretty low on my priority list.  And people on the Power and ia64
> platforms won't be happy....
> 
> 						- Ted


