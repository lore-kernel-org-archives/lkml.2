Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab1CaKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:25:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37055 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752015Ab1CaKZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:25:28 -0400
Date: Thu, 31 Mar 2011 11:25:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: locks inside receive_buf
Message-ID: <20110331112559.090948a7@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=FrmB=u09wvLoXzQstnV3h-U58R728t3k6_-B-@mail.gmail.com>
References: <AANLkTi=FrmB=u09wvLoXzQstnV3h-U58R728t3k6_-B-@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 17:51:27 +0530
Pavan Savoy <pavan_savoy@sify.com> wrote:

> Hi,
> 
> Does holding a lock make any sense inside the line discipline's
> ops->receive_buf?
> I see the locks being held and released - during some calls like
> flush_to_ldisc, which end up calling receive_buf....
> 
> 
> and yes, I would like to have a lock because, there are other
> functions in my ldisc driver executed in process context ...
> Is there some hints as to what should be the do's and don'ts inside
> the ldisc ops functions ? (say tty_wakeup ...)

It's not well documented no. Your ld->receive_buf is single threaded and
runs from a sleeping context (but please don't sleep too long)

The output path from user space will be in a sleeping context too, but
you can call the write method of the tty your driver is using from
interrupt context or holding a spinlock (eg from timers)



