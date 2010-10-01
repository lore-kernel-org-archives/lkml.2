Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab0JAP12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 11:27:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52145 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab0JAP10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 11:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pi+Zsl7OxnTHda7IP0dwFG8AtsDqewfzW8KvPwQHXgy56BDPkPmZJYTs5oX3NjUN+P
         mIGr4B+JETPf2JyidJUtNmURTZjnnYVRmjmNsrWwOx4Er/wNtce7VC7sBgV6V7iNHo/I
         xUn/QVZ85cmbbfq/9+GtO15hTFbVCC30G27/s=
Date: Fri, 1 Oct 2010 17:27:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        "Wu, Xia" <xia.wu@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhu, Daniel" <daniel.zhu@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: unnecessary timer interrupt of slab.c and bdi tasks when the
	system is in sleep state
Message-ID: <20101001152715.GA5338@nowhere>
References: <A24AE1FFE7AEC5489F83450EE98351BF221878E0FB@shsmsx502.ccr.corp.intel.com> <alpine.DEB.2.00.1009300908050.27201@router.home> <20101001141932.GA5467@nowhere> <26E9B811E137AB4B95200FD4C950886BA64E0E96@orsmsx507.amr.corp.intel.com> <20101001143546.GA6194@nowhere> <26E9B811E137AB4B95200FD4C950886BA64E0ECD@orsmsx507.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26E9B811E137AB4B95200FD4C950886BA64E0ECD@orsmsx507.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 08:20:22AM -0700, Van De Ven, Arjan wrote:
> 
> > > the slab timer is already deferable... which means it won't hit while
> > the system is completely idle.
> > 
> > 
> > I'm not sure what you mean exactly. The slab work seems to be scheduled
> > strictly
> > periodically, unless the cpu goes offline. But I can't find any nohz-
> > wise adaptation.
> > 
> 
>                 INIT_DELAYED_WORK_DEFERRABLE(reap_work, cache_reap);
> 
> that will cause it to only run when the cpu is actually idle...


Aah ok, I missed that. Thanks.

