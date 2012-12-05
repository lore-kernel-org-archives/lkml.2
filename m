Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab2LEW6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:58:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab2LEW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:58:23 -0500
Message-ID: <1354748302.3224.58.camel@bling.home>
Subject: Re: [RFC PATCH 3/6] kvm: Merge id_to_index into memslots
From: Alex Williamson <alex.williamson@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, gleb@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 05 Dec 2012 15:58:22 -0700
In-Reply-To: <20121205212200.GB20260@amt.cnet>
References: <20121203231912.3661.57179.stgit@bling.home>
	 <20121203233924.3661.81373.stgit@bling.home>
	 <20121205212200.GB20260@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-05 at 19:22 -0200, Marcelo Tosatti wrote:
> On Mon, Dec 03, 2012 at 04:39:24PM -0700, Alex Williamson wrote:
> > This allows us to resize this structure and therefore the number of
> > memslots as part of the RCU update.
> 
> Why is this necessary? "struct memslots" is updated, message above
> conflicts with that.
> 
> If there is a reason, "id_to_index" becomes confusing.
> 

I can't have two indeterminate sized arrays in the same structure, so by
moving id_to_index into struct kvm_memory_slot I get back to one array.
I'm playing with whether this is worthwhile.  If we reduce id_to_index
to a short then we can leave it with a static size and still get a
memory savings for the typical case.  Thanks,

Alex

