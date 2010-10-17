Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab0JQN75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 09:59:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:48837 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0JQN74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 09:59:56 -0400
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Paris <eparis@parisplace.org>
Cc: eparis@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
        devel@lists.fedoraprojet.org
In-Reply-To: <AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
References: <20101016065206.GO4681@dastard>
	 <20101016192027.GA6883@infradead.org>
	 <1287295077.3020.83.camel@localhost.localdomain>
	 <1287313332.1998.172.camel@laptop>
	 <AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Oct 2010 15:59:20 +0200
Message-ID: <1287323960.1998.360.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 09:12 -0400, Eric Paris wrote:
> We could split this into 2 structures, thus greatly shrinking the size
> of the structure needed for the default/disabled case,

Well, it does suck it needs to bloat data and code when its effectively
disabled. Isn't there a way to gather this data before we enable it, eg.
scan the files list on enable or somesuch?

I mean, if you mandate an external storage you might as well extend
struct inode, that's cheaper in each respect.

Me, I'm henceforth making sure to have CONFIG_IMA disabled...

>  but it doesn't
> help the fact that the suggested structure for storage (the radix
> tree) is apparently quite inefficient.  I'd love to hear other
> suggestions for a better structure.... 

radix tree is efficient for dense sets, not sparse sets.


