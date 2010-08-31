Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab0HaWBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 18:01:16 -0400
Received: from m209-5.dsl.rawbw.com ([198.144.209.5]:50714 "EHLO
	kyoto.noir.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0HaWBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 18:01:15 -0400
Message-ID: <4C7D7BA5.6080607@noir.com>
Date: Tue, 31 Aug 2010 15:01:09 -0700
From: "K. Richard Pixley" <rich@noir.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.8) Gecko/20100802 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mike Fedyk <mfedyk@mikefedyk.com>
CC: Josef Bacik <josef@redhat.com>, Tomasz Chmielewski <mangoo@wpkg.org>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        hch@infradead.org, gg.mariotti@gmail.com,
        "Justin P. Mattock" <justinmattock@gmail.com>, mjt@tls.msk.ru,
        tytso@mit.edu
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
References: <4C7AB645.5090804@wpkg.org>	<20100830001441.GA838@dhcp231-156.rdu.redhat.com>	<4C7BD569.9000702@noir.com> <AANLkTin-BZvqCChXEmsDfjhVmRmJLaoaudnuFL6EXZQx@mail.gmail.com>
In-Reply-To: <AANLkTin-BZvqCChXEmsDfjhVmRmJLaoaudnuFL6EXZQx@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20100831 14:46, Mike Fedyk wrote:
 > There is little reason not to use duplicate metadata.  Only small
 > files (less than 2kb) get stored in the tree, so there should be no
 > worries about images being duplicated without data duplication set at
 > mkfs time.

My benchmarks show that for my kinds of data, btrfs is somewhat slower 
than ext4, (which is slightly slower than ext3 which is somewhat slower 
than ext2), when using the defaults, (ie, duplicate metadata).

It's a hair faster than ext2, (the fastest of the ext family), when 
using singleton metadata.  And ext2 isn't even crash resistant while 
btrfs has snapshots.

I'm using hardware raid for striping speed.  (Tried btrfs striping, it 
was close, but not as fast on my hardware).  I want speed, speed, speed. 
  My data is only vaguely important, (continuous builders), but speed is 
everything.

While the reason to use singleton metadata may be "little", it dominates 
my application.  If I were forced to use duplicate metadata then I'd 
still be arguing with my coworkers about whether the speed costs were 
worth it to buy snapshot functionality.  But the fact that btrfs is 
faster AND provides snapshots, (and less metadata overhead and bigger 
file systems and etc), makes for an easy sale.

Note that nilfs2 has similar performance, but somewhat different 
snapshot characteristics that aren't as useful in my current application.

--rich
