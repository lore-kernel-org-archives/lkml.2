Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab1GAQ7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:59:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64738 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab1GAQ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:59:31 -0400
Date: Fri, 1 Jul 2011 19:58:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Marcus Klemm <marcus.klemm@googlemail.com>, kvm@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@linuxdriverproject.org
Subject: Re: [PATCH v2] staging: zcache: support multiple clients, prep for
 KVM and RAMster
Message-ID: <20110701165845.GG2544@shale.localdomain>
References: <1d15f28a-56df-4cf4-9dd9-1032f211c0d0@default20110630224019.GC2544@shale.localdomain>
 <3b67511f-bad9-4c41-915b-1f6e196f4d43@default20110701083850.GE2544@shale.localdomain>
 <871d7dbc-041f-411f-b91a-cbc5aeb9db98@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871d7dbc-041f-411f-b91a-cbc5aeb9db98@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 07:31:54AM -0700, Dan Magenheimer wrote:
> > Off by one errors are kind of insidious.  People cut and paste them
> > and they spread.  If someone adds a new list of chunks then there
> > are now two examples that are correct and two which have an extra
> > element, so it's 50/50 that he'll copy the right one.
> 
> True, but these are NOT off-by-one errors... they are
> correct-but-slightly-ugly code snippets.  (To clarify, I said
> the *ugliness* arose when debugging an off-by-one error.)
> 

What I meant was the new arrays are *one* element too large.

> Patches always welcome, and I agree that these should be
> fixed eventually, assuming the code doesn't go away completely
> first.. I'm simply stating the position
> that going through another test/submit cycling to fix
> correct-but-slightly-ugly code which is present only to
> surface information for experiments is not high on my priority
> list right now... unless GregKH says he won't accept the patch.
>  
> > Btw, looking at it again, this seems like maybe a similar issue in
> > zbud_evict_zbpg():
> > 
> >    516          for (i = 0; i < MAX_CHUNK; i++) {
> >    517  retry_unbud_list_i:
> > 
> > 
> > MAX_CHUNKS is NCHUNKS - 1.  Shouldn't that be i < NCHUNKS so that we
> > reach the last element in the list?
> 
> No, the last element in that list is unused.  There is a comment
> to that effect someplace in the code.  (These lists are keeping
> track of pages with "chunks" of available space and the last
> entry would have no available space so is always empty.)

The comment says that the first element isn't used.  Perhaps the
comment is out of date and now it's the last element that isn't
used.  To me, it makes sense to have an unused first element, but it
doesn't make sense to have an unused last element.  Why not just
make the array smaller?

Also if the last element of the original arrays isn't used, then
does that mean the last *two* elements of the new arrays aren't
used?

Getting array sizes wrong is not a "correct-but-slightly-ugly"
thing.  *grumble* *grumble* *grumble*.  But it doesn't crash the
system so I'm fine with it going in as is...

> 
> Thanks again for your interest... are you using zcache?

No.  I was just on the driver-devel list reviewing patches at
random.

regards,
dan carpenter

