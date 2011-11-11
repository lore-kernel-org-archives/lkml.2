Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab1KKEvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 23:51:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:42461 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab1KKEvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 23:51:50 -0500
Message-ID: <1320987054.21206.55.camel@pasglop>
Subject: Re: [RFC PATCH 02/17] powerpc: Split up PHYS_64BIT config option to
 fix "select" issues
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Timur Tabi <timur@freescale.com>
Cc: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mackerras <paulus@samba.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anatolij Gustschin <agust@denx.de>, Paul Bolle <pebolle@tiscali.nl>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Date: Fri, 11 Nov 2011 15:50:54 +1100
In-Reply-To: <4EBC00D2.2030208@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
	 <1320883635-17194-3-git-send-email-Kyle.D.Moffett@boeing.com>
	 <4EBBD9DF.6080100@freescale.com>
	 <501ACA94-491F-43A7-9DCF-485BEE824DD5@boeing.com>
	 <4EBC00D2.2030208@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 10:50 -0600, Timur Tabi wrote:

> I'm not sure that Kconfig rule is enforceable.  We use 'select' all the time to make sure that our boards enable the options that need to be enabled.  I'd rather see this:
> 
> config X
> 	select A
> 
> config Y
> 	select A
> 
> config Z
> 	select A
> 
> than this:
> 
> config A
> 	default y if X | Y | Z
> 
> The former is more maintainable and does not allow the option of disabling "A" if someone wants "X".

This is fine as long as config A is not a user selectable option.

We do the wrong thing in a few places (i2c comes to mind) and we should
most certainly consider fixing it. Some of the solution is to move some
select's to defconfigs, some is to do things the way Kyle proposed.

For PHYS_64BIT, I'm not 100% certain at this point what the best
approach it. It should clearly be fixed and hidden for real 64-bit. As
for the rest, should it be user selectable ? I tend to think it should
be fixed & selected by the board config and keep it that way, avoiding
the user question entirely... but you may have good reasons to want to
keep it around.

Cheers,
Ben.


