Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab0ENIE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:04:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:57163 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0ENIEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:04:21 -0400
Subject: Re: [PATCH 1/9] mm: add generic adaptive large memory allocation
 APIs
From: Peter Zijlstra <peterz@infradead.org>
To: Changli Gao <xiaosuo@gmail.com>
Cc: akpm@linux-foundation.org, Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Divy Le Ray <divy@chelsio.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, containers@lists.linux-foundation.org,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
In-Reply-To: <AANLkTinLT5g5SKjqmQlS2kxvvMq1gsi1jPDgOKTnrT-q@mail.gmail.com>
References: <1273744285-8128-1-git-send-email-xiaosuo@gmail.com>
	 <1273756816.5605.3547.camel@twins>
	 <AANLkTinLT5g5SKjqmQlS2kxvvMq1gsi1jPDgOKTnrT-q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 14 May 2010 10:03:34 +0200
Message-ID: <1273824214.5605.3625.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 22:08 +0800, Changli Gao wrote:
> > NAK, I really utterly dislike that inatomic argument. The alloc side
> > doesn't function in atomic context either. Please keep the thing
> > symmetric in that regards.
> >
> 
> There are some users, who release memory in atomic context. for
> example: fs/file.c: fdmem. 

urgh, but yeah, aside from not using vmalloc to allocate fd tables one
needs to deal with this.

But if that is the only one, I'd let them do the workqueue thing that's
already there. If there really are more people wanting to do this, then
maybe add: kvfree_atomic().
