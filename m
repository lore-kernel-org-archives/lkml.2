Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab1JRMLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:11:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43677 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757491Ab1JRMLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:11:05 -0400
Date: Tue, 18 Oct 2011 13:08:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rob Clark <rob.clark@linaro.org>
Cc: Hugh Dickins <hughd@google.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device
 independant
Message-ID: <20111018130843.170b71b2@lxorguk.ukuu.org.uk>
In-Reply-To: <CAN_cFWNKeD8sf-nmv9ZtVxKu1XMf3caNRKHtkzdq9zfSMig6-w@mail.gmail.com>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
	<20110705144140.23872.86541.stgit@localhost.localdomain>
	<alpine.LSU.2.00.1107071742250.10362@sister.anvils>
	<20110708093859.299958df@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107080917430.1781@sister.anvils>
	<20110711172517.46907e62@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107111033440.1752@sister.anvils>
	<CAMeQTsb7ZMbyt8avYNOiBssERmk6vEbg7RR6TQw7CaD55MK22A@mail.gmail.com>
	<alpine.LSU.2.00.1110101102330.21957@sister.anvils>
	<CAN_cFWNkYGSajh7eG1qK+A5tWSHNR2gH4EPiPg9tKd+yw8nRYQ@mail.gmail.com>
	<alpine.LSU.2.00.1110171031290.2545@sister.anvils>
	<20111017223928.4d5ed2c6@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1110171528520.6878@sister.anvils>
	<CAN_cFWP9jOGTPuoXQaXan_P1AKYrbvfLoB8hzG-YdCddfsu3Vw@mail.gmail.com>
	<20111018114518.5610a8c2@lxorguk.ukuu.org.uk>
	<CAN_cFWNKeD8sf-nmv9ZtVxKu1XMf3caNRKHtkzdq9zfSMig6-w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011 06:59:28 -0500
Rob Clark <rob.clark@linaro.org> wrote:

> On Tue, Oct 18, 2011 at 5:45 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> What troubles could you see for swap+uncached (or more likely,
> >> writecombine) pages?
> >
> > That should never occur. I would argue the driver is responsible for
> > putting the cache state of the page back sensibly before it unpins it.
> > That's a simple enough rule and one I think all the drivers follow at
> > this point.
> 
> no, what I'm trying to avoid is having two virtual mappings to the
> same physical page with different cache attributes.  This is not
> allowed on some architectures (like ARM)

Nor x86... that's a matter for the core architecture code to deal with
not the drivers.

Alan
