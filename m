Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1G2SGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:06:52 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35098 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476Ab1G2SGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:06:50 -0400
Date: Fri, 29 Jul 2011 14:06:50 -0400
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Breno Leitao <leitao@linux.vnet.ibm.com>
Subject: Re: Very strange data loss with jsm driver
Message-ID: <20110729180650.GL8562@caffeine.csclub.uwaterloo.ca>
References: <20110729160416.GK8562@caffeine.csclub.uwaterloo.ca>
 <20110729172736.4b199d31@lxorguk.ukuu.org.uk>
 <20110729165342.GB8566@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729165342.GB8566@caffeine.csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 12:53:42PM -0400, Lennart Sorensen wrote:
> On Fri, Jul 29, 2011 at 05:27:36PM +0100, Alan Cox wrote:
> > > The trigger point appears to be lines of up to 14 bytes, followed by
> > > a newline.  With 15 bytes or more per line it seems to be OK.
> > > 
> > > Anyone got a clue?
> > 
> > FIFO size perhaps - and some kind of missed wakeup or tx handling bug ?
> 
> FIFO size is 64bytes, so that doesn't immediately sound related.
> 
> The thing I find weird is that it thinks everything was sent right away.
> 
> Also why should the newline have anything to do with it?  If you send
> 100100 bytes should it matter where the newlines are unless the tty
> layer or the driver is interpreting the newlines for some reason.

Same breakage on 2.6.18.  I suspect this has always been broken.

Hmm.

I noticed fifosize in the uart_port info is set to 16, even though the
fifo size is actually 64 bytes as all actual driver bits know.  What is
fifosize actually used for?

-- 
Len Sorensen
