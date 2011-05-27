Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1E0NIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:08:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1E0NIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:08:44 -0400
Date: Fri, 27 May 2011 09:07:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Eric Paris <eparis@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527130731.GA8053@redhat.com>
References: <1306269105.21443.20.camel@dan>
 <20110526203502.GK29496@redhat.com>
 <20110526204030.GL29496@redhat.com>
 <1306442674.2279.29.camel@dan>
 <20110526205549.GM29496@redhat.com>
 <20110527093853.GI21386@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527093853.GI21386@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:38:53AM +0200, Ingo Molnar wrote:
> 
> * Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > > Is it common to run kexec-tools as non-root?  It may be necessary 
> > > to restrict this interface to root when randomization is used 
> > > (keep in mind nobody's going to force you to turn this on by 
> > > default, at least for the foreseeable future).
> > 
> > kexec-tools runs as root. And I see that /proc/iomem permissions 
> > are also for root only. So it probably is a non-issue.
> 
> it might be an issue to keep in mind for later projects that try to 
> lock down root itself from being able to patch the kernel (other than 
> rebooting the box), using signed modules, disabled direct-ioport 
> access, and other hardened facilities.

For such environments, Eric Paris had posted a patch to be able to 
disable loading of kexec/kdump kernel, similar to disabling module loading.

https://lkml.org/lkml/2011/1/19/412

I don't see that in Linus's tree. So looks like it never got committed.

Thanks
Vivek
