Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab1LOK4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:56:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51515 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab1LOK4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:56:20 -0500
Message-ID: <1323946517.18942.29.camel@twins>
Subject: Re: printk() vs tty_io
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Thu, 15 Dec 2011 11:55:17 +0100
In-Reply-To: <20111215103220.7c08498f@pyramind.ukuu.org.uk>
References: <1323804803.9082.40.camel@twins>
	 <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
	 <20111214104308.14d0500c@pyramind.ukuu.org.uk>
	 <1323860206.28489.35.camel@twins> <20111214140527.GA18080@thunk.org>
	 <1323872631.28489.37.camel@twins>
	 <CA+55aFwu+oSPtqfN+bS3_fHXWU+VMd5BGhNd=J4MjuAJZT+fTQ@mail.gmail.com>
	 <1323943005.18942.18.camel@twins>
	 <20111215103220.7c08498f@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 10:32 +0000, Alan Cox wrote:

> For lockdep spews do they need to be spewed synchronously - clearly it's
> good if they can be but its possible that they could be buffered ?

This wasn't about lockdep per-se, it all started with me trying to
cleanup printk()'s abuse of lockdep_off()/lockdep_on. Which then grew
into something a little bigger.

I'm fine with dropping the larger goal of making printk() work in all
but NMI context and focus on the initial cleanup.


