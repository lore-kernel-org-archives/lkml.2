Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab2LEW6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:58:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab2LEW6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:58:49 -0500
Message-ID: <1354748328.3224.59.camel@bling.home>
Subject: Re: [RFC PATCH 4/6] kvm: Move private memory slots to start of
 memslots array
From: Alex Williamson <alex.williamson@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, gleb@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 05 Dec 2012 15:58:48 -0700
In-Reply-To: <20121205212403.GC20260@amt.cnet>
References: <20121203231912.3661.57179.stgit@bling.home>
	 <20121203233930.3661.7744.stgit@bling.home>
	 <20121205212403.GC20260@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-05 at 19:24 -0200, Marcelo Tosatti wrote:
> On Mon, Dec 03, 2012 at 04:39:30PM -0700, Alex Williamson wrote:
> > In order to make the memslots array grow on demand, move the private
> > slots to the lower indexes of the array.  The private slots are
> > assumed likely to be in use, so if we didn't do this we'd end up
> > allocating the full memslots array all the time.
> 
> You're changing private slot ids. Fail to see why is that relevant
> to on-demand growing.

This series takes a really simple approach and grows the array up to the
given slot->id.  If we have private slots at the end of the array then
we always allocate the whole thing.  I'm playing with a version now that
fixes this, but complexity becomes a much more significant factor.
Thanks,

Alex

