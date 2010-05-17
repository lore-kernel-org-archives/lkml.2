Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0EQTwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:52:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab0EQTwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:52:00 -0400
Date: Mon, 17 May 2010 15:51:45 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Blunck <jblunck@suse.de>, David Woodhouse <dwmw2@infradead.org>,
       linux-nfs@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 05/39] whiteout/NFSD: Don't return information about whiteouts to userspace
Message-ID: <20100517195145.GB18568@shell>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com> <1272928358-20854-6-git-send-email-vaurora@redhat.com> <20100504093731.3a45ff5f@notabene.brown> <20100506180151.GA21062@shell> <20100507071808.20028458@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507071808.20028458@notabene.brown>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 07:18:08AM +1000, Neil Brown wrote:
> On Thu, 6 May 2010 14:01:51 -0400
> Valerie Aurora <vaurora@redhat.com> wrote:
> 
> > On Tue, May 04, 2010 at 09:37:31AM +1000, Neil Brown wrote:
> > > On Mon,  3 May 2010 16:12:04 -0700
> > > Valerie Aurora <vaurora@redhat.com> wrote:
> > > 
> > > > From: Jan Blunck <jblunck@suse.de>
> > > > 
> > > > Userspace isn't ready for handling another file type, so silently drop
> > > > whiteout directory entries before they leave the kernel.
> > > 
> > > Feels very intrusive doesn't it....
> > > 
> > > Have you considered something like the following?
> > 
> > Hrm, I see how that could be more elegant, but I'd rather avoid yet
> > another layer of function pointer passing around.  This code is
> > already hard enough to review...
> 
>  Yes, the extra indirection is a bit of a negative, but I don't think this
>  patch is harder to review than the alternate.
>  From a numerical perspective, with this patch you only need to look at the
>  various places that ->readdir is called to be sure it is always correct.
>  There are about 3.  With the original you need to look at ever filldir
>  function.  Jan has found 9.  
> 
>  And from a maintainability perspective, I think my approach is safer.  Given
>  that there are 9 filldir functions already, the chance that a need will be
>  found for another seems good, and the chance that the coder will know to
>  check for DT_WHT is a best even.  Conversely if another call to ->readdir
>  were added it is likely that nothing would need to be done.
> 
>  Of course just counting things doesn't give a completely picture but I think
>  it can be indicative.

Okay, good points.  Let me try it out after getting this next rewrite done.

Thanks,

-VAL
