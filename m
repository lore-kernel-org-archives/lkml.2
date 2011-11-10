Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207Ab1KJKuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 05:50:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59067 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932511Ab1KJKuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 05:50:19 -0500
Date: Thu, 10 Nov 2011 10:51:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Do not stall in synchronous compaction for THP
 allocations
Message-ID: <20111110105100.23fa78f9@lxorguk.ukuu.org.uk>
In-Reply-To: <20111110100616.GD3083@suse.de>
References: <20111110100616.GD3083@suse.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011 10:06:16 +0000
Mel Gorman <mgorman@suse.de> wrote:

> Occasionally during large file copies to slow storage, there are still
> reports of user-visible stalls when THP is enabled. Reports on this
> have been intermittent and not reliable to reproduce locally but;

If you want to cause a massive stall take a cheap 32GB USB flash drive
plug it into an 8GB box and rsync a lot of small files to it. 400,000
emails in maildir format does the trick and can easily be simulated. The
drive drops to about 1-2 IOPS with all the small mucking around and the
backlog becomes massive.

> Internally in SUSE, I received a bug report related to stalls in firefox
> 	when using Java and Flash heavily while copying from NFS
> 	to VFAT on USB. It has not been confirmed to be the same problem
> 	but if it looks like a duck and quacks like a duck.....

With the 32GB USB flash rsync I see firefox block for up to 45 minutes
although operating entirely on an unrelated filesystem. I suspect it may
be a problem that is visible because an fsync is getting jammed up in
the mess.

Alan
