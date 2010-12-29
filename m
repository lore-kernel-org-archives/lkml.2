Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab0L2Gqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 01:46:45 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:60252 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0L2Gqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 01:46:43 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=sma64emKALigICJU+V2L7RL3kPAolu7RCFSKDgo279k= c=1 sm=1
 a=SU0sOTISozAA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=VpzQvIIsWBTNGwlY5poA:9
 a=K6rGnwgf-_7bXpRsIiFxJ-i660oA:4 a=CjuIK1q_8ugA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: Bug in ext4/btrfs fallocate?
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <4D1A0B1C.70406@gmail.com>
Date: Tue, 28 Dec 2010 23:46:39 -0700
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>, tytso@mit.edu,
        chris.mason@oracle.com
Content-Transfer-Encoding: 8BIT
Message-Id: <6A86E6B8-E14E-484B-BBF5-F3C580337661@dilger.ca>
References: <4D1A0B1C.70406@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-28, at 09:06, Marco Stornelli wrote:
> it seems that ext4/btrfs code for fallocate doesn't check for
> immutable/append inode flag.

fallocate() probably shouldn't be allowed for immutable files, but it makes a lot of sense to call fallocate() on append-only files to avoid fragmentation, though it should only be called with the KEEP_SIZE flag.

Cheers, Andreas





