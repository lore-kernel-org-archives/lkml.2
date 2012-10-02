Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab2JBDtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 23:49:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54813 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2JBDtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 23:49:51 -0400
Date: Mon, 1 Oct 2012 20:49:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tim Shepard <shep@alum.mit.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_EXPERT is a booby trap
In-Reply-To: <E1TIVdh-0007iT-00@www.xplot.org>
Message-ID: <alpine.DEB.2.00.1210012045580.31644@chino.kir.corp.google.com>
References: <E1TIVdh-0007iT-00@www.xplot.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2012, Tim Shepard wrote:

> And may I suggest that CONFIG_EXPERT should be factored into two
> CONFIGs, one of which makes configuration things visible, and another
> which changes the default values to something more appropriate for
> embedded systems (perhaps call it CONFIG_EMBEDDED_DEFAULTS).  That way
> you'd have to select CONFIG_EXPERT, and then select the
> CONFIG_EMBEDDED_DEFAULTS option that CONFIG_EXPERT made visible to
> actually change any configuration, and the documentation for
> CONFIG_EMBEDDED_DEFAULTS could explain that it changes defaults
> throughout the tree (and selecting CONFIG_EXPERT alone would not go off
> and muck things up with no warning).
> 

I think you can get away with changing everything that is doing "default 
!EXPERT" to do "default !EMBEDDED" since it's usually only done for things 
that are known not to be interesting for the embedded world and 
significantly increase the size of the kernel memory footprint.  What it's 
really saying is to "enable it by default on everything that doesn't need 
to make the smallest kernel possible."

Aside from that, separating CONFIG_EXPERT from CONFIG_EMBEDDED is 
something that has been discussed a few times and can be done when it 
makes clear sense and you can get consensus on the change.  We always 
accept patches.
