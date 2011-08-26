Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab1HZKnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:43:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab1HZKno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:43:44 -0400
Date: Fri, 26 Aug 2011 11:43:37 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm-kcopyd: Correctly free requests
Message-ID: <20110826104337.GN31980@agk-dp.fab.redhat.com>
Mail-Followup-To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
References: <20110826101542.GB20197@wavehammer.waldi.eu.org> <20110826103747.GA15125@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826103747.GA15125@agk-dp.fab.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:37:47AM +0100, Alasdair G Kergon wrote:
> On Fri, Aug 26, 2011 at 12:15:42PM +0200, Bastian Blank wrote:
> > kcopyd only frees the requests if the master job information is set up
> > correctly, but it was not in the recently added path. This leads to many
> > unfreed slabs during snapshot usage.
> Referring to commit c6ea41fbbe08f270a8edef99dc369faf809d1bd6
>   dm kcopyd: preallocate sub jobs to avoid deadlock
> which added the master_job field.
 
and commit a6e50b409d3f9e0833e69c3c9cca822e8fa4adbb
    dm snapshot: skip reading origin when overwriting complete chunk
which indeed forgets to set the new field.

I'll submit the patch shortly, together with some other minor fixes
sitting in linux-next.

Alasdair

