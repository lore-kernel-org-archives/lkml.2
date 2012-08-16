Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2HPOZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:25:09 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48981 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2HPOZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:25:07 -0400
Date: Thu, 16 Aug 2012 15:29:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: leroy christophe <christophe.leroy@c-s.fr>
Cc: Alan Cox <alan@linux.intel.com>, Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Powerpc 8xx CPM_UART delay in receive
Message-ID: <20120816152918.5ed2649f@pyramind.ukuu.org.uk>
In-Reply-To: <502CF2A0.8080109@c-s.fr>
References: <201208141426.q7EEQSPc003956@localhost.localdomain>
	<20120814155227.018988da@pyramind.ukuu.org.uk>
	<502CF2A0.8080109@c-s.fr>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The PowerPC CPM is working differently. It doesn't use a fifo but 
> buffers. Buffers are handed to the microprocessor only when they are 
> full or after a timeout period which is adjustable. In the driver, the 

Which is different how - remembering we empty the FIFO on an IRQ

> buffers are configured with a size of 32 bytes. And the timeout is set 
> to the size of the buffer. That is this timeout that I'm reducing to 1 
> byte in my proposed patch. I can't see what it would break for high 
> speed I/O.

How can a timeout be measured in "bytes". Can we have a bit more clarity
on how the hardware works and take it from there ?

Alan
