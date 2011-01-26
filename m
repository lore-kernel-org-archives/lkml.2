Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab1AZNQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:16:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41841 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751594Ab1AZNQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:16:44 -0500
Date: Wed, 26 Jan 2011 13:17:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evan Lavelle <sa212+lkml@cyconix.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel deferring driver 'close' call: workaround?
Message-ID: <20110126131703.3033ad87@lxorguk.ukuu.org.uk>
In-Reply-To: <4D401824.6090109@cyconix.com>
References: <4D401824.6090109@cyconix.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 'strace' shows that the 'close' succeeds, but the driver debug output 
> shows that the driver close/release (step 2) is not called before the 
> next open (step 3), so the open fails.

I imagine the user has a bug in their app. The close method is called on
the final close of the handle. That means if for example you do something
like fork off a child process and forget to close the handle then it
won't actually close down until the final user closes it.

Alan
