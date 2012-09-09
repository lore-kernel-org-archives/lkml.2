Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2IIHsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 03:48:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:36491 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab2IIHsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 03:48:12 -0400
Message-ID: <1347176866.2385.100.camel@pasglop>
Subject: Re: [RFC PATCH 0/5] driver core: driver probe asynchronously
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Date: Sun, 09 Sep 2012 17:47:46 +1000
In-Reply-To: <20120909025702.GB9525@kroah.com>
References: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
	 <20120909025702.GB9525@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-08 at 19:57 -0700, Greg Kroah-Hartman wrote:
> As you state, this doesn't really solve the problem, and will cause a
> lot more (think about all the busses that aren't expecting to have
> their
> probe functions called at the same time as other probe functions are
> being called.)
> 
> So while I applaud the effort, I can't accept this due to the past
> history of when it was tried before. 

Maybe a compromise would be to have ->probe() be called synchronously as
done currently, but to add support for a specific -EAGAIN return from
it, requiring a later asynchronous re-probe ? (Possibly requiring an
explicit trigger)

That would allow drivers who fail some kind of "oddball" dependency (the
firmware load is such as case, there are a few others) to basically
install some kind of notifier and try again later when the dependency
has been fulfilled.

That way existing drivers still behave synchronously, there is no
breakage unless drivers are explicitly modified for async probing.

Cheers,
Ben.


