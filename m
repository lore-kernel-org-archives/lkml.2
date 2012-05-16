Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2EPORj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:17:39 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17512 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2EPORh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:17:37 -0400
MIME-Version: 1.0
Message-ID: <c3a17d64-0d63-4948-8e1b-d170626adff5@default>
Date: Wed, 16 May 2012 07:17:02 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RE: linux-next: build failure after merge of the final tree (staging
 tree related)
References: <20120516200659.000314e53de07a7a7fda46b8@canb.auug.org.au>
 <20120516124924.GB32064@kroah.com>
In-Reply-To: <20120516124924.GB32064@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:greg@kroah.com]
> Subject: Re: linux-next: build failure after merge of the final tree (staging tree related)
> 
> On Wed, May 16, 2012 at 08:06:59PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> >
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >
> > drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_map_object':
> > drivers/staging/zsmalloc/zsmalloc-main.c:704:3: error: implicit declaration of function 'set_pte' [-
> Werror=implicit-function-declaration]
> > drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_unmap_object':
> > drivers/staging/zsmalloc/zsmalloc-main.c:738:3: error: implicit declaration of function
> '__flush_tlb_one' [-Werror=implicit-function-declaration]
> >
> > Presumably caused by commit 49b81a3c7415 ("ramster: switch over to
> > zsmalloc and crypto interface") which now has CONFIG_RAMSTER selecting
> > CONFIG_ZSMALLOC explicitly which in turn ignores the dependency of
> > CONFIG_ZSMALLOC on X86 ...
> >
> > I have reverted that commit for today.
> 
> Ick, sorry about that.
> 
> Dan, care to send me a follow-on patch, or do you just want me to revert
> this patch from my tree for now?

Rats.  Sorry.

Greg, given that the solution for making zsmalloc portable
is still being debated[1] and it doesn't look like it will
be finalized before the looming window,  I guess the
best choice is to revert the patch and ramster will fall
back to its captive copy of the less-efficient-but-portable
xvmalloc for now. :-(

Thanks and sorry for the churn,
Dan

[1] http://comments.gmane.org/gmane.linux.kernel.mm/78470 
