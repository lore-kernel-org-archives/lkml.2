Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab1CaJsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 05:48:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49121 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752289Ab1CaJsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 05:48:30 -0400
Date: Thu, 31 Mar 2011 10:45:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/9] x86 idle cruft removal - v2
Message-ID: <20110331104549.3065ab29@lxorguk.ukuu.org.uk>
In-Reply-To: <1301551404-8263-1-git-send-email-lenb@kernel.org>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
	<1301551404-8263-1-git-send-email-lenb@kernel.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [PATCH 6/9] x86 idle APM: delete apm_cpu_idle(), and its use of pm_idle
> [PATCH 7/9] x86 idle: do not EXPORT_SYMBOL pm_idle and default_idle

I thought someone had agreed to look after APM ?

I'm also curious why you write

"There is some doubt whether the APM idle feature
to call into the BIOS from the idle loop is reliable.
Certainly it was known to fail on some machines,
but more importantly, APM machines have not shipped
for a decade and so finding machines to test the code
is problematic."

We don't care if it doesn't work on a few machines (in fact we have
a table to avoid that), we care that it *DOES* work on lots.

Removing it probably isn't a bad thing long term, but it's not appeared in
the deprecated list and has not been there for several releases so it is
not eligible for removal at this point.

People spent years getting Linux to support all this hardware and
throwing bits out left right and centre to tidy up your current project
is not the way it should be done.

So can we do this properly please. We have a process for good reason.

Deprecate it properly

Add a printk/WARN_ON() indicating to the user it is deprecated but we
will continue, and then give it a couple of releaes. Kerneloops.org will
help answer whether that WARN_ON was hit.

And in the meantime just progress the rest of the work with it present.
If you break APM support by accident doing that then either

a) someone will jump up and down and yell regression - and debug it for
you

or

b) there will be silence because nobody noticed it broke


Alan
