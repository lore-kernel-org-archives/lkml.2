Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab0FVPMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:12:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59766 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab0FVPMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 11:12:50 -0400
Message-ID: <4C20D2FC.7010307@vflare.org>
Date: Tue, 22 Jun 2010 20:43:00 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, chris.mason@oracle.com,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@Sun.COM,
       tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
       konrad.wilk@oracle.com
Subject: Re: [PATCH V3 3/8] Cleancache: core ops functions and configuration
References: <20100621231939.GA19505@ca-server1.us.oracle.com> <20100622144320.GA13324@infradead.org>
In-Reply-To: <20100622144320.GA13324@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 08:13 PM, Christoph Hellwig wrote:
> On Mon, Jun 21, 2010 at 04:19:39PM -0700, Dan Magenheimer wrote:
>> [PATCH V3 3/8] Cleancache: core ops functions and configuration
>>
>> Cleancache core ops functions and configuration
> 
> NACK for code that just adds random hooks all over VFS and even
> individual FS code, does an EXPORT_SYMBOL but doesn't actually introduce
> any users.
> 
> And even if it had users these would have to be damn good ones given how
> invasive it is.  So what exactly is this going to help us?  Given your
> affiliation probably something Xen related, so some real use case would
> be interesting as well instead of just making Xen suck slightly less.
> 
> 

One use case of cleancache is to provide transparent page cache compression
support. Currently, I'm working 'zcache' which provides hooks for cleancache
callbacks to implement the same.

Page cache compression is expected is benefit use cases where memory is the
bottleneck. In particular, I'm interested in KVM virtualization case where
this can allow running more VMs per host for given amount of RAM.

The zcache code is under active development and a working snapshot can be
found here:
http://code.google.com/p/compcache/source/browse/#hg/sub-projects/zcache
(sorry for lack of code comments in its current state)

Thanks,
Nitin
