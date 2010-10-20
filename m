Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab0JTSFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:05:11 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46198 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0JTSFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:05:08 -0400
Date: Wed, 20 Oct 2010 14:04:54 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jon Maloy <jon.maloy@ericsson.com>
Cc: Leandro Lucarella <luca@llucax.com.ar>, David Miller <davem@davemloft.net>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
	<tipc-discussion@lists.sourceforge.net>
Subject: Re: Linux 2.6.35/TIPC 2.0 ABI breaking changes
Message-ID: <20101020180454.GC14407@hmsreliant.think-freely.org>
References: <4CBCD429.8090306@windriver.com>
 <20101018234547.GA5703@hmsreliant.think-freely.org>
 <20101019021657.GZ8781@llucax.com.ar>
 <20101019.011649.71113115.davem@davemloft.net>
 <20101019110452.GA14410@hmsreliant.think-freely.org>
 <20101019131936.GB8781@llucax.com.ar>
 <20101019201841.GC14410@hmsreliant.think-freely.org>
 <20101020172018.GN8781@llucax.com.ar>
 <0434463FDA60A94FA978ACA44617682DEE84668199@EUSAACMS0702.eamcs.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0434463FDA60A94FA978ACA44617682DEE84668199@EUSAACMS0702.eamcs.ericsson.se>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 01:57:06PM -0400, Jon Maloy wrote:
> <...>
> > subscr struct because 0x0 is a valid filter in TIPC 2.0.
> > 
> 
> > 
> > Another option is to change the TIPC 2.0 specification to use 
> > the old format (use HBO in subscriptions and keep 
> > TIPC_SUB_SERVICE as a separate flag with value 2) and forget 
> > about all this. After all, I can't see what advantages gives 
> > having to change the BO for internal messages between the 
> > applications and the stack.
> 
> I agree with this. I have no problems with changing the draft 
> (which as Leandro already noted is "work-in-progress") to specify that 
> both HBO and NBO are permitted over the wire, and that it is the
> topology server's task to keep track of which one is used.
> 
> Remember, permitting both is a superset of the current one (NBO only)
> so it is fully backwards compatible. We break absolutly nothing by 
> permitting this. 
> 
Thats effectively reverting both our patches though, isn't it (not that I'm
disagreeing with it, just looking for clarification).  If we revert my patch and
reintroduce the htohl mechanism which tracks endianess, we might as well revert
the TIPC_SUB_SERVICE flag as well, yeah?

Neil

> 
> > 
> > [1] http://tipc.sourceforge.net/doc/draft-spec-tipc-06.html
> > [2] http://tipc.sourceforge.net/doc/draft-spec-tipc-06.html#anchor92
> > 
> > -- 
> > Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
> > ----------------------------------------------------------------------
> > GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
> > ----------------------------------------------------------------------
> > CARANCHO OBNUBILADO APARECE EN PARQUE CHACABUCO!
> > 	-- Crónica TV
> > --
> > To unsubscribe from this list: send the line "unsubscribe 
> > netdev" in the body of a message to majordomo@vger.kernel.org 
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
