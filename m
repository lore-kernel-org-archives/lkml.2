Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2FFOEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:04:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab2FFOEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:04:48 -0400
Date: Wed, 6 Jun 2012 10:03:57 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: x86@kernel.org, zhong@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
Message-ID: <20120606140357.GB32472@redhat.com>
References: <1338839763-11140-1-git-send-email-dzickus@redhat.com>
 <4FCDDB7D0200007800088390@nat28.tlf.novell.com>
 <20120605144734.GU32472@redhat.com>
 <4FCE44FC0200007800088524@nat28.tlf.novell.com>
 <20120605183539.GA32472@redhat.com>
 <4FCF57B902000078000887EA@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCF57B902000078000887EA@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 12:14:33PM +0100, Jan Beulich wrote:
> > I didn't think it would be compiler dependent as I do not know what
> > compiler the reporter was using.  I used a RHEL-6 4.4.4 compiler (which
> > you probably don't have :^) ).
> 
> Indeed, somehow I failed to see the obvious - it's commit
> 72b3fb24713755cf9740b403e95aa67ceedf3509 that causes
> these problems. Instantiating static data like this just doesn't
> play with any of the pointers passed being into .init.*.
> 
> I'd suggest either open coding register_nmi_handler() (with
> the static data put into __initdata), or further abstracting it
> by allowing an optional fifth argument (specifying the section
> annotation if needed).

Ah.  Thanks for figuring that out!!  I will post a patch opencoding it.

Thanks,
Don
