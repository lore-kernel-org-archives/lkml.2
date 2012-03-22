Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031048Ab2CVV0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:26:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758358Ab2CVV0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:26:49 -0400
Date: Thu, 22 Mar 2012 14:26:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 00/16] mm: prepare for converting vm->vm_flags to 64-bit
Message-Id: <20120322142647.42395398.akpm@linux-foundation.org>
In-Reply-To: <4F69D496.2040509@openvz.org>
References: <20120321065140.13852.52315.stgit@zurg>
	<20120321100602.GA5522@barrios>
	<4F69D496.2040509@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 17:16:06 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Minchan Kim wrote:
> > Hi Konstantin,
> >
> > It seems to be nice clean up to me and you are a volunteer we have been wanted
> > for a long time. Thanks!
> > I am one of people who really want to expand vm_flags to 64 bit but when KOSAKI
> > tried it, Linus said his concerning, I guess you already saw that.
> >
> > He want to tidy vm_flags's usage up rather than expanding it.
> > Without the discussion about that, just expanding vm_flags would make us use
> > it up easily so that we might need more space.
> 
> Strictly speaking, my pachset does not expands vm_flags, it just prepares to this.
> Anyway vm_flags_t looks better than hard-coded "unsigned long" and messy type-casts around it.

It would be nice to find some way of triggering compiler warnings or
sparse warnings if someone mixes a 32-bit type with a vm_flags_t.  Any
thoughts on this?

(Maybe that's what __nocast does, but Documentation/sparse.txt doesn't
describe it)
