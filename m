Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2HTTLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:11:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42164 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2HTTLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:11:45 -0400
MIME-Version: 1.0
In-Reply-To: <CANN689Hch8ao9MnV0Luk6_b0kFJtcvfZZ7jEGWyvUN41Q=FWnA@mail.gmail.com>
References: <20120816024610.GA5350@evergreen.ssec.wisc.edu>
	<502D42E5.7090403@redhat.com>
	<20120818000312.GA4262@evergreen.ssec.wisc.edu>
	<502F100A.1080401@redhat.com>
	<alpine.LSU.2.00.1208200032450.24855@eggly.anvils>
	<CANN689Ej7XLh8VKuaPrTttDrtDGQbXuYJgS2uKnZL2EYVTM3Dg@mail.gmail.com>
	<50321CD3.5050501@redhat.com>
	<CANN689Hch8ao9MnV0Luk6_b0kFJtcvfZZ7jEGWyvUN41Q=FWnA@mail.gmail.com>
Date: Mon, 20 Aug 2012 12:11:43 -0700
Message-ID: <CANN689FiU87Vju7zTJ2yZNkw2aDd=K05fRKhoRGTn6Dp8btjLg@mail.gmail.com>
Subject: Re: Repeated fork() causes SLAB to grow without bound
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 4:53 AM, Michel Lespinasse <walken@google.com> wrote:
> I wonder if it might help to add the child VMA onto the parent's
> anon_vma only at the first child COW event. That way it would at least
> be possible (with userspace changes) for any forking servers to
> separate the areas they want to write into from the parent (such as
> things that need expensive initialization), from the ones that they
> want to write into from the child, and have none of the anon_vma lists
> grow too large.

Actually that wouldn't work. The parent's anon pages are visible from
the child, so the child vma needs to be on the parent anon_vma list.
Sorry for the noise :/

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
