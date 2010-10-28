Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab0J1EJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 00:09:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab0J1EJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 00:09:40 -0400
Date: Wed, 27 Oct 2010 21:08:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Patch] Convert max_user_watches to long.
Message-Id: <20101027210855.11c5a564.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1010271751090.12650@davide-lnx1>
References: <20101027190914.146006767@gulag1.americas.sgi.com>
	<20101027190921.059806977@gulag1.americas.sgi.com>
	<20101027164502.d6e2068d.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1010271751090.12650@davide-lnx1>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 19:03:55 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:

> > Is the expected use case one-watch-per-user-per-fd?  If so, then
> > perhaps the max number of user_watches should have some realtionship
> > with the max number of fds?
> 
> Yes, the expected case is one watch per fd, but the reason the watch limit 
> went in in the first place, was because of DoS potential of someone not 
> playing nicely.

Sometimes DoS's are accidental.  It only takes 25 people to be running
the same buggy (eg, slowly-leaky) app (or shared lib) at the same time...

There are surely plenty of ways of that sort of thing happening, of
course.  Not that this fact actually improves anything.
