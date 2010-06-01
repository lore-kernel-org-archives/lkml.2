Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab0FAReH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:34:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab0FAReE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:34:04 -0400
Subject: Re: [PATCH] rbtree: undo augmented damage -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <1275412748.27810.27883.camel@twins>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
	 <tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
	 <1275136178.27810.13539.camel@twins> <1275139902.27810.13737.camel@twins>
	 <AANLkTimZkyRwP5k290rUr-DUMhsynl9fzBkS68x-57KM@mail.gmail.com>
	 <1275412748.27810.27883.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Jun 2010 19:34:10 +0200
Message-ID: <1275413650.27810.27930.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 19:19 +0200, Peter Zijlstra wrote:
> On Tue, 2010-06-01 at 10:00 -0700, Venkatesh Pallipadi wrote:
> > I am not seeing how this can cover all the callbacks we will need to
> > maintain the augmented tree property. May be I am missing something.
> 
> Yes, indeed, how about the below delta, which my eevdf code did do but I
> overlooked on the conversion to the PAT code.
> 
> That removes the break as you said, but also adds code to update the
> child nodes when walking up the path.
> 
> So in your rotation case:
> 
>     G             P
>    / \    -->    / \
>   P   U         N   G
>  /        <--        \
> N                     U
> 
> Say we take the right rotation, then the traversal up from N to P will
> find that since N was the left child of P and it has a right child (G)
> it will also update G.

Hmm, that looks like it could well be folded in to the generic code..
let me spin a new patch.
