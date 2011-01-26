Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1AZOiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 09:38:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60942 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752841Ab1AZOiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 09:38:24 -0500
Date: Wed, 26 Jan 2011 14:38:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evan Lavelle <sa212+lkml@cyconix.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel deferring driver 'close' call: workaround?
Message-ID: <20110126143851.711c57df@lxorguk.ukuu.org.uk>
In-Reply-To: <4D402FDE.2050407@cyconix.com>
References: <4D401824.6090109@cyconix.com>
	<20110126131703.3033ad87@lxorguk.ukuu.org.uk>
	<4D402FDE.2050407@cyconix.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 14:29:50 +0000
Evan Lavelle <sa212+lkml@cyconix.com> wrote:

> On 26/01/2011 13:17, Alan Cox wrote:
> 
> > I imagine the user has a bug in their app. The close method is called on
> > the final close of the handle. That means if for example you do something
> > like fork off a child process and forget to close the handle then it
> > won't actually close down until the final user closes it.
> 
> That was my first reaction, but the strace output only shows an open and 
> close of two shared libs, open and close for this board, some mmaps from 
> the driver, and the basic brk/fstat/etc stuff. Unfortunately, I haven't 
> got the app source, or even the board... :(

An mmap reference counts as an open .... it won't be released until the
mmaps are gone
