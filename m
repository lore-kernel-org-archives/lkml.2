Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1DBL1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 07:27:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43102 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752151Ab1DBL1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 07:27:48 -0400
Date: Sat, 2 Apr 2011 12:28:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, x86@kernel.org,
        Jiri Kosina <jkosina@suse.cz>, stable@kernel.org
Subject: Re: [PATCH 03/18] x86 idle APM: deprecate CONFIG_APM_CPU_IDLE
Message-ID: <20110402122810.1371afa8@lxorguk.ukuu.org.uk>
In-Reply-To: <392e1ffeeaefd448f69d45041fe4406fbd197852.1301724243.git.len.brown@intel.com>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
	<1301725380-10579-1-git-send-email-lenb@kernel.org>
	<392e1ffeeaefd448f69d45041fe4406fbd197852.1301724243.git.len.brown@intel.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We don't want to export the pm_idle function pointer to modules.
> Currently CONFIG_APM_CPU_IDLE w/ CONFIG_APM_MODULE forces us to.

So you could jsut compile it in ...

> CONFIG_APM_CPU_IDLE is of dubious value, it runs only on 32-bit
> uniprocessor laptops that are over 10 years old.  It calls into
> the BIOS during idle, and is known to cause a number of machines
> to fail.

It also works on lots of desktops from that era, more of which are still
around.

> 
> Removing CONFIG_APM_CPU_IDLE and will allow us to stop exporting
> pm_idle.  Any systems that were calling into the APM BIOS
> at run-time will simply use HLT instead.

(which is btw what quite a few later APM implementations seem to do ;))


> +What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
> +When:	2.6.40

One release isn't enough time - it won't propagate out - you keep
rushing, hurrying and pushing at this trying to do it fast.

Why - its a sigle symbol export of minor ugliness, it doesn't justify the
amount of hatred you are expending upon it.

Give it a year, it doesn't cause any complexities I can see.

