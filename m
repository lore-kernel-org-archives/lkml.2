Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab1LPN1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 08:27:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:34487 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab1LPN06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 08:26:58 -0500
Message-ID: <1324041955.18942.97.camel@twins>
Subject: Re: printk() vs tty_io
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Fri, 16 Dec 2011 14:25:55 +0100
In-Reply-To: <CA+55aFwhFoU5Fp_VTMtVU7XFMZiNvy1J7n7YJsVBu+-k-EH0Nw@mail.gmail.com>
References: <1323804803.9082.40.camel@twins>
	 <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
	 <20111214104308.14d0500c@pyramind.ukuu.org.uk>
	 <1323860206.28489.35.camel@twins> <20111214140527.GA18080@thunk.org>
	 <1323872631.28489.37.camel@twins>
	 <CA+55aFwu+oSPtqfN+bS3_fHXWU+VMd5BGhNd=J4MjuAJZT+fTQ@mail.gmail.com>
	 <1323943005.18942.18.camel@twins>
	 <CA+55aFwhFoU5Fp_VTMtVU7XFMZiNvy1J7n7YJsVBu+-k-EH0Nw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 09:08 -0800, Linus Torvalds wrote:
>    Peter, why do you want to try to work from under the rq lock?

As Ingo already mentioned, there was no strong reason. The rationale was
reducing surprise lockups like that xtime_lock thing. Also, there are
various WARNs in the scheduler code that could possibly trigger and
cause a deadlock.

Then again, they're not supposed to trigger and mostly if they do we
don't get an insta deadlock (at least not on the consoles I've used),
but there is the possibility of course.

I'm not sure the WARNs are enough reason to invent a new async printk
facility, but if you feel strongly about that I can look into doing it.
