Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab2FUPp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 11:45:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60531 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932478Ab2FUPp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 11:45:26 -0400
Date: Thu, 21 Jun 2012 16:45:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torsten.hilbrich@secunet.com,
        Nick Piggin <npiggin@kernel.dk>
Message-ID: <20120621154518.GR2753@decadent.org.uk>
References: <x49txy5yi9z.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49txy5yi9z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [patch] block: fix off-by-one in init_page_buffers
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 02:01:28PM -0400, Jeff Moyer wrote:
[...]
> This needs backporting to the stable trees where the offending commit
> was backported.  I'm sure that includes 3.0 and 3.3, but not sure where
> else it was committed.

3.2 as well.

> Is there an easy way to tell what trees got the commit?
[...]

I don't know about easy, but if you have 'stable' as a remote then
this works:

$ git branch -r | sed 's/^ *stable\/linux-\([0-9.]*\)\.y/\1/; t; d' | while read version; do git rev-list --grep=080399aaaf3531f5b8761ec0ac30ff98891e8686 v$version..stable/linux-$version.y | grep -q . && echo $version; done
3.0
3.2
3.3

(Maybe I'll wrap that up in a script.)
 
Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
