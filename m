Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0KAOlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 10:41:53 -0400
Received: from mail.perches.com ([173.55.12.10]:3911 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab0KAOlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 10:41:52 -0400
Subject: Re: [PATCH 04/39] arch/powerpc: Update WARN uses
From: Joe Perches <joe@perches.com>
To: michael@ellerman.id.au
Cc: Jiri Kosina <trivial@kernel.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288609334.10671.4.camel@concordia>
References: <cover.1288471897.git.joe@perches.com>
	 <c6c46b5924e1cc9720d3ad76e6c11e982bd661e5.1288471898.git.joe@perches.com>
	 <1288609334.10671.4.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 07:41:49 -0700
Message-ID: <1288622509.366.237.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-01 at 22:02 +1100, Michael Ellerman wrote:
> On Sat, 2010-10-30 at 14:08 -0700, Joe Perches wrote:
> > Coalesce long formats.
> > Align arguments.
> > Add missing newlines.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  arch/powerpc/kernel/hw_breakpoint.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
> > index 5ecd040..d7343a7 100644
> > --- a/arch/powerpc/kernel/hw_breakpoint.c
> > +++ b/arch/powerpc/kernel/hw_breakpoint.c
> > @@ -270,8 +270,8 @@ int __kprobes hw_breakpoint_handler(struct die_args *args)
> >  	 * message to let the user know about it.
> >  	 */
> >  	if (!stepped) {
> > -		WARN(1, "Unable to handle hardware breakpoint. Breakpoint at "
> > -			"0x%lx will be disabled.", info->address);
> > +		WARN(1, "Unable to handle hardware breakpoint. Breakpoint at 0x%lx will be disabled.\n",
> > +		     info->address);
> 
> That appears to have done nothing other than turn a short line into one
> that is now > 80 columns.

Added '\n'.

The series was done for a few reasons:

o to add missing newlines at the end of messages as was done here
o to convert a couple of misuses of WARN(msg) to WARN(1, msg)
o to remove KERN_ prefixes from WARN(test, KERN_<level> msg)

>  Is that the latest fad?

Pretty much.  Format coalescing is generally preferred for grep.
Some consider it churn.

cheers, Joe

