Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1BCPLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:11:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46628 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755268Ab1BCPLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:11:39 -0500
Date: Thu, 3 Feb 2011 15:13:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gergely Nagy <algernon@balabit.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
Message-ID: <20110203151353.25f69343@lxorguk.ukuu.org.uk>
In-Reply-To: <1296733177.14846.26.camel@moria>
References: <1296733177.14846.26.camel@moria>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Feb 2011 12:39:37 +0100
Gergely Nagy <algernon@balabit.hu> wrote:

> Hi!
> 
> Back in november, a patch was merged into the kernel (in  commit
> ce6ada35bdf710d16582cc4869c26722547e6f11), that splits CAP_SYSLOG out of
> CAP_SYS_ADMIN.
> 
> Sadly, this has an unwelcomed consequence, that any userspace syslogd
> that formerly used CAP_SYS_ADMIN will stop working, unless upgraded, or
> otherwise adapted to the change.

Then the patch should probably be reverted as it's breaking an existing
userspace API (or the kernel should accept either SYSLOG || ADMIN in
those cases that check is made so that the old right covers it as well as
the split out one)

Alan


