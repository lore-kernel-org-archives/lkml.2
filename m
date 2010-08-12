Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab0HLAmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:42:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:32699 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758843Ab0HLAme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:42:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,355,1278313200"; 
   d="scan'208";a="544169565"
Subject: Re: +
 drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386.patch added to
 -mm tree
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gcosta@redhat.com" <gcosta@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "lenb@kernel.org" <lenb@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <20100811173327.3ae325ff.akpm@linux-foundation.org>
References: <201008112336.o7BNaNEj020805@imap1.linux-foundation.org>
	 <20100811164310.a4790773.randy.dunlap@oracle.com>
	 <20100811173327.3ae325ff.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 08:42:31 +0800
Message-ID: <1281573751.2744.1415.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 08:33 +0800, Andrew Morton wrote:
> On Wed, 11 Aug 2010 16:43:10 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Wed, 11 Aug 2010 16:06:24 -0700 akpm@linux-foundation.org wrote:
> > 
> > > 
> > > The patch titled
> > >      drivers/acpi/apei/erst-dbg.c: get_user(u64) doesn't work on i386
> > > has been added to the -mm tree.  Its filename is
> > >      drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386.patch
> > > 
> > > Before you just go and hit "reply", please:
> > >    a) Consider who else should be cc'ed
> > >    b) Prefer to cc a suitable mailing list as well
> > >    c) Ideally: find the original patch on the mailing list and do a
> > >       reply-to-all to that, adding suitable additional cc's
> > > 
> > > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > > 
> > > See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> > > out what to do about this
> > > 
> > > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > ------------------------------------------------------
> > > Subject: drivers/acpi/apei/erst-dbg.c: get_user(u64) doesn't work on i386
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > 
> > > Might be an x86 bug?  A get_user() on a u64 on i386 expands to
> > > 
> > > #define __get_user_8(__ret_gu, __val_gu, ptr)				\
> > > 		__get_user_x(X, __ret_gu, __val_gu, ptr)
> > > 
> > > which emits a call to __get_user_X(), which doesn't exist.
> > > 
> > > Kludge around it with copy_from_user().
> > > 
> > 
> > Reported and fixed yesterday.
> 
> Not very well.
> 
> +		rc = copy_from_user(&record_id, (void __user *)arg,
> +				    sizeof(u64));
> 
> better to use sizeof(record_id).

Will fix this with a new version. And the ssize printk format string.

> Where's Len??
>
> Anyway, this should be fixed in x86 core, I suspect.

Yes. I think so too.

Best Regards,
Huang Ying


