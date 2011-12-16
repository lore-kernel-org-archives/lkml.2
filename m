Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730Ab1LPOvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:51:37 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:34003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab1LPOva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:51:30 -0500
Subject: Re: unexpected taint message
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>
In-Reply-To: <4EEB5A60.3090101@lwfinger.net> (sfid-20111216_154940_152892_953155B5)
References: <4EEB0EFC.5000302@broadcom.com>
	 (sfid-20111216_102800_182196_AFD2D6CF) <1324038636.3429.1.camel@jlt3.sipsolutions.net>
	 <4EEB4D61.80602@lwfinger.net>
	 (sfid-20111216_145414_221850_EED1E4DE) <1324043939.3429.2.camel@jlt3.sipsolutions.net>
	 <4EEB521A.70602@lwfinger.net>
	 (sfid-20111216_151411_303937_12579E4F) <1324045233.3429.3.camel@jlt3.sipsolutions.net>
	 <4EEB5A60.3090101@lwfinger.net> (sfid-20111216_154940_152892_953155B5)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Dec 2011 15:51:25 +0100
Message-ID: <1324047085.3429.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 08:49 -0600, Larry Finger wrote:

> > +	switch (flag) {
> > +	case TAINT_CRAP:
> > +	case TAINT_WARN:
> > +	case TAINT_OOT_MODULE:
> > +		break;
> > +	default:
> > +		if (__debug_locks_off())
> > +			printk(KERN_WARNING
> > +			       "Disabling lock debugging due to kernel taint\n");
> > +	}
> >
> >   	set_bit(flag,&tainted_mask);
> >   }
> 
> Yes. I like this patch a lot. Unfortunately, VirtualBox was a part of the 
> decision to add the OOT taint. At least for that reason, this patch would not be 
> accepted upstream. It is too bad that the Oracle people fought so hard to keep 
> their module from setting TAINT_CRAP the way that GregKH wanted. That would have 
> had fewer side effects for me.

I'm not sure -- I mean, it's one thing to identify OOT modules and
refuse to support them (and ignore lockdep reports with OOT set), but
it's another to just disable lockdep? I think?

johannes

