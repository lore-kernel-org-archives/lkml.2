Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1GHIhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:37:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41065 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754047Ab1GHIg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:36:59 -0400
Date: Fri, 8 Jul 2011 09:38:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device
 independant
Message-ID: <20110708093859.299958df@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LSU.2.00.1107071742250.10362@sister.anvils>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
	<20110705144140.23872.86541.stgit@localhost.localdomain>
	<alpine.LSU.2.00.1107071742250.10362@sister.anvils>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As example, below is the patch where I updated drm/i915 to be ready
> for the changeover.  They set __GFP_RECLAIMABLE on the mapping because
> they've got a way to discard unpinned object pages when memory is tight;
> and sometimes add in __GFP_NORETRY|__GFP_NOWARN when allocating.
> 
> I'm guessing you'd just want to use shmem_read_mapping_page() throughout,
> after initializing mapping with the appropriate flags (GFP_HIGHUSER_MOVABLE
> is fs/inode.c's default: maybe your pages aren't easily movable and you'd
> better say GFP_HIGHUSER, or maybe you have reason to need GFP_KERNEL).

I need the pages in the low 4GB ideally and have no way to release them
if they are pinned. For the usage pattern I have that's not a problem.

At the moment the 4G isn't a problem either as you can't attach enough
memory to cause problems to any of these devices.


What I don't entirely understand from your change is what stops another
user task with the shmemfs file handle open from doing something else
which changes the mapping flags, or is it guaranteed that only the
mapping owner gets to play ?

Alan
