Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1DTJid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:38:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49901 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388Ab1DTJic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:38:32 -0400
Date: Wed, 20 Apr 2011 10:39:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Linn <John.Linn@xilinx.com>
Cc: Greg KH <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>
Subject: Re: [PATCH] tty/serial: add support for Xilinx PS UART
Message-ID: <20110420103928.4049573f@lxorguk.ukuu.org.uk>
In-Reply-To: <68925dd6-03b8-48af-9f96-0a3f611712e1@VA3EHSMHS020.ehs.local>
References: <e35578a9-909d-4594-bbe4-41d89b5f9b3e@VA3EHSMHS014.ehs.local>
	<20110419221530.7370d013@lxorguk.ukuu.org.uk>
	<8d05c32c-9ff1-4eda-9563-6857ede6541a@VA3EHSMHS020.ehs.local>
	<20110419232141.GA27491@kroah.com>
	<68925dd6-03b8-48af-9f96-0a3f611712e1@VA3EHSMHS020.ehs.local>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reading up on it a bit as I'm not an expert on it (like you). 
> It's not clear to me what the device driver uses for it's major/minor in
> this case.  

If you don't specify then the kernel picks one. udev can then create the
right /dev/ttyPS1/2/3 nodes itself. If you have devtmpfs enabled then
devtmpfs is a virtual file system which will just have the nodes in at as
specified by the drivers. It eliminates all the hard work maintaining
device nodes/ranges in user space.

> The only reason we didn't just use ttyS0 was that it's not a 8250 really

If you'd attempted to use ttyS0 you would indeed have been told to change
it
> and
> since we have are an FPGA people can add real 8250s in soft logic and
> then
> the system would get confusing.

and that's exactly why !

Alan
