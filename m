Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1HBOWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:22:32 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47200 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab1HBOW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:22:26 -0400
Date: Tue, 2 Aug 2011 10:22:25 -0400
To: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Very strange data loss with jsm driver
Message-ID: <20110802142225.GO8562@caffeine.csclub.uwaterloo.ca>
References: <20110729160416.GK8562@caffeine.csclub.uwaterloo.ca>
 <20110729172736.4b199d31@lxorguk.ukuu.org.uk>
 <20110729165342.GB8566@caffeine.csclub.uwaterloo.ca>
 <20110729180650.GL8562@caffeine.csclub.uwaterloo.ca>
 <20110729191442.35d09111@lxorguk.ukuu.org.uk>
 <20110729181337.GM8562@caffeine.csclub.uwaterloo.ca>
 <4E380710.1010204@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E380710.1010204@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 11:17:52AM -0300, Breno Leitao wrote:
> Well, I finally tested it over here, and what I found is:
> 
> If the line has a \r among the first 16 bytes, then the information
> is TXed immediately. If there is no \r in the first 16 bytes, then the
> information seems to be buffered.

Where in the driver is this happening?

> So, it seems that that the patch should ask the driver to TX the
> information when we receive a \r or when the buffer is full. Does it
> make sense to you ?

Not sure.  I just wonder why the data is disappearing rather than getting
buffered somewhere.  Clearly the other serial drivers are doing that
successfully.

I don't even know why the driver should care about the contents at all.
Just send data when it is ready.

-- 
Len Sorensen
