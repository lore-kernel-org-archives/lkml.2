Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab1KBRCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:02:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34456 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755120Ab1KBRCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:02:51 -0400
Date: Wed, 2 Nov 2011 17:02:30 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 11/16] ARM: LPAE: Add fault handling support
Message-ID: <20111102170230.GJ29782@arm.com>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
 <1312988619-16804-12-git-send-email-catalin.marinas@arm.com>
 <20111023115756.GB17912@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023115756.GB17912@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 12:57:56PM +0100, Russell King - ARM Linux wrote:
> On Wed, Aug 10, 2011 at 04:03:34PM +0100, Catalin Marinas wrote:
> > @@ -494,6 +508,72 @@ static struct fsr_info {
> >  	int	code;
> >  	const char *name;
> >  } fsr_info[] = {
> > +#ifdef CONFIG_ARM_LPAE
...
> > +#else	/* !CONFIG_ARM_LPAE */
> >  	/*
> >  	 * The following are the standard ARMv3 and ARMv4 aborts.  ARMv5
> >  	 * defines these to be "precise" aborts.
> > @@ -535,6 +615,7 @@ static struct fsr_info {
> >  	{ do_bad,		SIGBUS,  0,		"unknown 29"			   },
> >  	{ do_bad,		SIGBUS,  0,		"unknown 30"			   },
> >  	{ do_bad,		SIGBUS,  0,		"unknown 31"			   }
> > +#endif	/* CONFIG_ARM_LPAE */
> 
> Can't we do better than this?

The first thought was defining the fsr_info array in a different file
but that would mean exposing functions from the fault.c which are
currently defined as static.

The other variant is including a C file directly in fault.c. It's not
very nice but at least we remove the big #ifdef.

-- 
Catalin
