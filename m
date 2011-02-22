Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1BVJHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:07:24 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40932 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1BVJHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:07:22 -0500
Date: Tue, 22 Feb 2011 09:07:16 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG ?] checkpatch.pl rejects as error something I think it
 ought to be allow
Message-ID: <20110222090716.GH2809@shadowen.org>
References: <4D62F502.9040506@linux.vnet.ibm.com>
 <20110221234015.GG2809@shadowen.org>
 <4D62FA0D.2070102@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D62FA0D.2070102@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 03:49:33PM -0800, Corey Ashford wrote:
> On 02/21/2011 03:40 PM, Andy Whitcroft wrote:
> >On Mon, Feb 21, 2011 at 03:28:02PM -0800, Corey Ashford wrote:
> >>Hi,
> >>
> >>I have a piece of code where I have two constants defined as follows:
> >>
> >>	static const unsigned long polling_interval_sec = 1;
> >>	static const unsigned long polling_interval_ns = 0;
> >>
> >>Now, it's clear to me that I want these two values to have the
> >>keywords const and static.  I could use a #define here, but const
> >>static seemed cleaner to me.
> >>
> >>When I run checkpatch.pl across this code, I get this error:
> >>
> >>ERROR: do not initialise statics to 0 or NULL.
> >>
> >>I think the problem here is that another case is needed for "static
> >>const" that does allow 0.
> >>
> >>What do you think?
> >>
> >>Thanks for your consideration,
> >
> >The warning is intended to tell you that the = 0 is unnecessary.  Any
> >static is 0 by default I believe.  At some point the addition of the 0
> >would move the value from the bss to the data segment bloating the code.
> >This may no longer be true.
> 
> OK, but that means I'd have to have a declaration like this, which
> looks quite odd to me:
> 
> 	static const poll_interval_ns; /* = 0 */
> 
> I don't think that is preferable to this:
> 
> 	static const poll_interval_ns = 0;

Well I'd not bother with the comment as that is defined behaviour.  But I
suspect that gcc has gained the smarts to not break these and perhaps the
check is long in the tooth.  As for this patch, as checkpatch is intended
to be an advisory helper you are free to ignore its recommendations,
just expect to be asked about it by any human reviewers.

-apw
