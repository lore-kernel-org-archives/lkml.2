Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab1DBVAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 17:00:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33381 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756212Ab1DBU77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 16:59:59 -0400
Date: Sat, 2 Apr 2011 22:00:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 16/18] 2.6.40: x86 idle APM: remove deprecated
 apm_cpu_idle()
Message-ID: <20110402220021.74ecdb5b@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.02.1104021529580.18682@x980>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
	<1301725380-10579-1-git-send-email-lenb@kernel.org>
	<5d9716021b20302ece48fd486bbad9bcb2502353.1301724243.git.len.brown@intel.com>
	<20110402124054.49c3a3f4@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.02.1104021529580.18682@x980>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch series was posted in reply to a table of contents
> 
> https://lkml.org/lkml/2011/4/2/8
> 
> "By the end of this series, pm_idle is removed as a public
>  x86 idle-loop registration mechanism.  A few other things are
>  cleaned up in the process."

Ok so lets rewind a bit - why do we want to remove pm_idle rather than
just fix up the way registration occurs. It's just a symbol, one trivial
interface that is exported and perhaps wants the export method tidying up.

> Trinabh also replied to you, pointing one of the previous
> LKML discussions about the mis-use of pm_idle.

And there are misuses of just about every kernel symbol - kmalloc for
example causes some people a lot of trouble !

> We'll create a new APM cpuidle driver in Linux (Trinabh prototyped one),
> and at the same time, schedule it for removal in a year.  Personally,
> I think it is make-work, and in real-life it is more likely to do
> more harm than removing apm_idle, but I don't want to stand in the
> way of process.

So you could just leave it alone - that's less work, less disruption and
doesn't do any harm at all.

As I read this the plan at the moment otherwise is

	- churn up all the code
	- remove PM idle hook
	- rewrite the APM code
	- replace the APM code

whereas you could just leave the symbol exported or even just a hook to
make people to do it right using:

	int register_pm_idle(function);

Simples yes ?

and then wait a year

For that matter instead of writing a new driver you could just stuff APM
into same hooks we have for virtualisation !

This whole patch series appears to be a giant piece of pointless makework.

Alan
