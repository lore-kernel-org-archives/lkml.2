Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab2B0DlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 22:41:17 -0500
Received: from mail130c7-2520.megamailservers.com ([69.49.98.25]:48541 "EHLO
	mail130c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753317Ab2B0DlP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 22:41:15 -0500
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Feb 2012 22:41:14 EST
X-POP-User: lamanatorplus.shawbiz.ca
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk> <20120221180546.25235.50961.stgit@warthog.procyon.org.uk> <20120227000428.GA8044@thunk.org>
In-Reply-To: <20120227000428.GA8044@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <B5DCCBD9-F032-44E1-8368-146137487B83@dilger.ca>
Content-Transfer-Encoding: 8BIT
Cc: David Howells <dhowells@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "valerie.aurora@gmail.com" <valerie.aurora@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>,
        "linux-ext4@kernel.org" <linux-ext4@kernel.org>
X-Mailer: iPhone Mail (9A405)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 66/73] ext2: Split ext2_add_entry() from ext2_add_link() [ver #2]
Date: Sun, 26 Feb 2012 20:30:34 -0700
To: "Ted Ts'o" <tytso@mit.edu>
X-CSC: 0
X-CHA: v=1.1 cv=79WxUICzzgkw5ZYFfgr1yO8Z474l5jtalk6swozgZjE= c=1 sm=1
		a=ku11lMGN5J0A:10 a=kj9zAlcOel0A:10 a=I7mQGxDnXGc3WFdT/ZY6CQ==:17
		a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Y3TvZqSoOCCWDI7w-rQA:9
		a=1ctbN4LbBH44dLbJA2UA:7 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10
		a=LI9Vle30uBYA:10 a=I7mQGxDnXGc3WFdT/ZY6CQ==:117
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020209.4F4AF8C4.0067,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-26, at 17:04, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Feb 21, 2012 at 06:05:46PM +0000, David Howells wrote:
>> From: Valerie Aurora <vaurora@redhat.com>
>> 
>> Allow future code to use the guts of ext2_add_link().
>> 
>> Original-author: Valerie Aurora <vaurora@redhat.com>
>> Signed-off-by: David Howells <dhowells@redhat.com>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: linux-ext4@kernel.org
> 
> I'd suggest folding this in with the following patch (67/73).  It's
> not clear from this patch why renaming ext2_add_link to
> ext2_add_entry() makes sense and then adding a new ext2_add_link()
> which calls ext_add_entry().   It doesn't seem to clarify much....

Also, why is this being done in ext2, when it should only be done in ext4?

Fedora is already using ext4 for ext2- and ext3-formatted filesystems, to allow us to finally deprecate and then delete both of those trees and their ongoing duplicate maintenance.  Adding new features to ext2 doesn't help that goal at all.

Cheers, Andreas