Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1AHBeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 20:34:25 -0500
Received: from smtp-out.google.com ([74.125.121.67]:61049 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1AHBeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 20:34:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=G5PKxvD//Whi/fLBd8RsFxEkjtrZcag9PE2mjMy6AmRzAncHMbaSfOtlWXNbmPzzUX
         H0AGvLOAC6mwLzGInxBw==
MIME-Version: 1.0
From: Mike Waychison <mikew@google.com>
Date: Fri, 7 Jan 2011 17:34:00 -0800
Message-ID: <AANLkTin215LOZDs_BL6r9Aa_fX60iwyEZQ-FzbcEhXCQ@mail.gmail.com>
Subject: Google firmware drivers in staging?
To: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Linus,

I'm going through our core dependencies for changes to the kernel that
we use in house.  FWIW, these "core" dependencies are essentially
required for our userland stack to function properly in our cluster
environment.  My goal is to make it seamless for other Google
engineers to use otherwise mainline kernels on our machines, enabling
them to develop more of their code against mainline.

Anyhow, rummaging down the list of stuff that we consider "core", I've
come across a couple firmware specific drivers.  These drivers are
specific to our machines, and would likely never apply to anyone
else's hardware.  That said, they aren't very complicated (they are
mostly isolated) and generally just help us plumb information between
userland and the firmware itself (like system event log data).

I'd like to get rid of these drivers as a delta between mainline and
our in-house trees.  Note that I can't really change anything on the
firmware side as those ABIs are sorta written in stone for all intents
and purposes, but I'd be happy to adapt the userland-exposed sides of
the drivers if needed.

I'd like to release these guys publicly if there is any hope that they
can wind up in the official tree.   What are your thoughts on putting
them through the staging tree?

Mike Waychison
