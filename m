Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486Ab0EEKg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:36:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30668 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934369Ab0EEKgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:36:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=CYX6eXLnF6m+LU5c7QN9Mtz3ilYzS9mdhs0MuZG3ysXtjpqP7ezmxEhvhrOiPuJgL
	gbix1vlMrz+hwsU3NO5XQ==
Date: Wed, 5 May 2010 03:36:46 -0700
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       Ying Han <yinghan@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: rwsem: down_read_unfair() proposal
Message-ID: <20100505103646.GA32643@google.com>
References: <20100505032033.GA19232@google.com> <22933.1273053820@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22933.1273053820@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 11:03:40AM +0100, David Howells wrote:
> If the system is as heavily loaded as you say, how do you prevent
> writer starvation?  Or do things just grind along until sufficient
> threads are queued waiting for a write lock?

Reader/Writer fairness is not disabled in the general case - it only is
for a few specific readers such as /proc/<pid>/maps. In particular, the
do_page_fault path, which holds a read lock on mmap_sem for potentially long
(~disk latency) periods of times, still uses a fair down_read() call.
In comparison, the /proc/<pid>/maps path which we made unfair does not
normally hold the mmap_sem for very long (it does not end up hitting disk);
so it's been working out well for us in practice.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
