Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab1BDLGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 06:06:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60095 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750734Ab1BDLGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 06:06:23 -0500
Date: Fri, 4 Feb 2011 11:08:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gergely Nagy <algernon@balabit.hu>
Cc: Marc Koschewski <marc@osknowledge.org>, david@lang.hm,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
Message-ID: <20110204110842.33da9ac2@lxorguk.ukuu.org.uk>
In-Reply-To: <1296808804.24742.6.camel@moria>
References: <1296733177.14846.26.camel@moria>
	<20110203153252.GA24153@mail.hallyn.com>
	<1296748401.14846.39.camel@moria>
	<20110203165132.GA28172@mail.hallyn.com>
	<alpine.DEB.2.00.1102031647150.30983@asgard.lang.hm>
	<20110204080302.GA24941@marc.osknowledge.org>
	<1296808804.24742.6.camel@moria>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Having both CAP_SYS_ADMIN and CAP_SYSLOG at the same time, for the sole
> purpose of reading kernel log messages would kind of defeat the purpose
> of CAP_SYSLOG. Therefore, a solution that allows both at the same time
> doesn't look all that good to me.

If you do it right you don't need both, you need either, so old code will
use CAP_SYS_ADMIN and work, newer code will use CAP_SYSLOG and work but
hold less rights. In a couple of years you can then drop the
CAP_SYS_ADMIN ability to read log files, providing it is in the list of
API deprecations soon...

> However, having it toggle-able does, and solves all my worries at least:
> defaulting to CAP_SYS_ADMIN maintains backwards compatibility, upgraded
> systems can switch to CAP_SYSLOG if and when the system is ready for
> that. All's well!

Still a mess, we don't break ABIs at random so this patch needs reverting
or fixing ASAP, otherwise Linus will just revert it anyway..

Alan
