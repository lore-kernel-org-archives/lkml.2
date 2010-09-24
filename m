Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab0IXGGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 02:06:02 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42028 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0IXGGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 02:06:01 -0400
X-Originating-Ip: 216.16.235.2
Date: Fri, 24 Sep 2010 02:05:57 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org
Subject: Re: ext3 filesystem corruption in user mode linux
Message-ID: <20100924060557.GA21238@foursquare.net>
References: <20100924041410.GA18040@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924041410.GA18040@foursquare.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 12:14:10AM -0400, Chris Frey wrote:
> If I do some heavy CPU and disk work in the guest, something like this:
> 
> 	# (cd /usr && tar cjf - portage) | tar xjf -
> 	# rm -rf portage
> 
> Then the filesystem corrupts itself, giving errors like the following
> in dmesg, during the rm:
> 
>     EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 51715


Update:

So far I have been unable to make 2.6.32.21 corrupt its filesystem
when running as the UML kernel (Host 2.6.35.4, UML 2.6.32.21)

When running UML 2.6.33.7, I get similar errors:

EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 21397
EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 13257
EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 13257
EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 21403
EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 21403
EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 13262
EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 13262
EXT3-fs error (device ubda): htree_dirblock_to_tree: bad entry in directory #13269: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
EXT3-fs (ubda): warning: empty_dir: bad directory (dir #13269) - no `.' or `..'
EXT3-fs (ubda): warning: ext3_rmdir: empty directory has nlink!=2 (3)


If anyone wants me to test a specific UML kernel, please let me know.

- Chris

