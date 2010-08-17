Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab0HQPFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:05:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187Ab0HQPFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:05:20 -0400
Date: Tue, 17 Aug 2010 07:54:03 -0700
From: Greg KH <gregkh@suse.de>
To: Nelson Zhang <nxz@cypress.com>
Cc: "'David Cross'" <david.cross@cypress.com>, hirofumi@mail.parknet.co.jp,
        linux-kernel@vger.kernel.org
Subject: Re: EXPORT_SYMBOL(fat_get_block)
Message-ID: <20100817145403.GA28926@suse.de>
References: <20100813190128.GA1372@suse.de>
 <1281727059.16672.20.camel@odc-laptop>
 <20100813192826.GA5078@suse.de>
 <1281731535.29175.17.camel@odc-laptop>
 <20100813221749.GA19569@suse.de>
 <1281741733.22119.20.camel@odc-laptop>
 <20100814002514.GA3182@suse.de>
 <1281748363.7882.15.camel@odc-laptop>
 <20100814030408.GB4779@suse.de>
 <ABE41F255A574632903665A7D1F90907@mis.cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ABE41F255A574632903665A7D1F90907@mis.cypress.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 06:57:54AM +0800, Nelson Zhang wrote:
> Hi David, Greg,
> 
> What I have done so far is following:
> 
> 1. Open a file 
> 2. Seek to the end of file

That just created a "sparse file"

> What I have not done is:
> 
> 3. mmap the whole file. 
> 
> Without #3, the file is not allocated until I write to the file.

That is by design.

> I think we can try to use mmap to allocate the file but we still need
> a function that can get file block info once the file is allocated.

No, why would you want the file block info?

Just treat it as a file, using mmap() and all the other userspace
goodness that we have to get data to a file very quickly.  You don't
need to preallocate the file from userspace, or anything else like that.

I suggest looking at some documentation on how to use the Unix file apis
properly to implement this better.

thanks,

greg k-h
