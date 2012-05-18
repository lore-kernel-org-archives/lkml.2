Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894Ab2ERLiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:38:07 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50179 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab2ERLiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:38:05 -0400
Date: Fri, 18 May 2012 12:40:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rabin Vincent <rabin@rab.in>
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Race in vt_event_wait() during suspend/resume
Message-ID: <20120518124051.6cd03ab0@pyramind.ukuu.org.uk>
In-Reply-To: <CAH+eYFAm-bp5nRgK4mBJa4CSoXw3V4wNvCUbnB+A8Ywvs3=M1w@mail.gmail.com>
References: <CAH+eYFAm-bp5nRgK4mBJa4CSoXw3V4wNvCUbnB+A8Ywvs3=M1w@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012 16:34:53 +0530
Rabin Vincent <rabin@rab.in> wrote:

> pm_restore_console() is called from the suspend/resume path,
> this calls vt_move_to_console(), which calls vt_event_wait().
> 
> There's a race in this path which causes the process
> which requests the suspend to sleep indefinitely waiting
> for an event which already happened:
> 
> P1					P2
>  vt_move_to_console()
>    set_console()
>      schedule_console_callback()
>    vt_waitactive()
>      check n == fg_console +1
> 					console_callback()
> 					  switch_screen()
> 					  vt_event_post() // no waiters
> 
>      vt_event_wait() // forever
> 
> I think the following should fix it.  Comments?
> 

Looks right to me.

Alan
