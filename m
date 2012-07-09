Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2GIH42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:56:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab2GIH41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:56:27 -0400
Subject: Re: [PATCH] CONFIG_CC_STACKPROTECTOR is no longer experimental
From: Jean Delvare <jdelvare@suse.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1341605949.22584.6.camel@x61.thuisdomein>
References: <1341583705.4655.18.camel@amber.site>
	 <4FF71F1C.4040608@xenotime.net> <1341597439.4655.23.camel@amber.site>
	 <4FF72733.8000007@linux.intel.com>
	 <1341605949.22584.6.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 09 Jul 2012 09:56:12 +0200
Message-ID: <1341820572.4605.35.camel@amber.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Le vendredi 06 juillet 2012 à 22:19 +0200, Paul Bolle a écrit :
> On Fri, 2012-07-06 at 10:58 -0700, Arjan van de Ven wrote:
> > I rather just retire the whole concept of "Experimental".
> > 
> > it's really utterly meaningless in practice anyway.
> 
> See Russell King's quick survey in https://lkml.org/lkml/2012/1/18/397 :
> almost all defconfigs had CONFIG_EXPERIMENTAL enabled. I didn't recheck
> since I'm sure little has changed. That macro and the related Kconfig
> symbol seem indeed meaningless.

I admit I have CONFIG_EXPERIMENTAL enabled on all my systems as well,
even the ones running an enterprise grade flavor of GNU/Linux.

This isn't necessarily surprising. Having to make decisions at build
time has always been an issue for distributions. The proper way for
distributions to deal with experimental drivers is to package them
separately and/or blacklist them by default. For experimental options,
best is to make them tunable at run time, for example using module
parameters.

As for options still depending on EXPERIMENTAL when they no longer
should, this can partly be explained when the EXPERIMENTAL dependency
doesn't show up in the short description. This is the case of
CONFIG_CC_STACKPROTECTOR. As everybody has CONFIG_EXPERIMENTAL enabled,
nobody notices the dependency.

The existence of CONFIG_EXPERIMENTAL may give developers the impression
that depending on it is sufficient and the right thing to do for
experimental drivers/features. That would be true if depending on
CONFIG_EXPERIMENTAL would automatically add "(EXPERIMENTAL)" to the
short description, as Randy and I were discussing previously, but this
was never implemented.

If we all agree that CONFIG_EXPERIMENTAL is no longer a good idea, then
I'm fine dropping it. I'm always happy to see kernel configuration
options go. Then options which used to depend on it and did not have
"(EXPERIMENTAL)" in their short description should have it appended.
These options should also default to N (but I think this is the default
default if none is specified?) Maybe a task for kernel janitors?

Back to my initial question, am I right to assume that
CONFIG_CC_STACKPROTECTOR is no longer experimental and can be enabled in
distribution kernels?

Thanks,
-- 
Jean Delvare
Suse L3

