Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab1LPN7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 08:59:10 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:34910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1LPN7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 08:59:02 -0500
Subject: Re: unexpected taint message
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4EEB4D61.80602@lwfinger.net> (sfid-20111216_145414_221850_EED1E4DE)
References: <4EEB0EFC.5000302@broadcom.com>
	 (sfid-20111216_102800_182196_AFD2D6CF) <1324038636.3429.1.camel@jlt3.sipsolutions.net>
	 <4EEB4D61.80602@lwfinger.net> (sfid-20111216_145414_221850_EED1E4DE)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Dec 2011 14:58:59 +0100
Message-ID: <1324043939.3429.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 07:53 -0600, Larry Finger wrote:
> On 12/16/2011 06:30 AM, Johannes Berg wrote:
> > On Fri, 2011-12-16 at 10:27 +0100, Arend van Spriel wrote:
> >> To whoever may know,
> >>
> >> Upon loading our driver module I get the following message:
> >>
> >> kernel: [  344.805106] Disabling lock debugging due to kernel taint
> >>
> >> What exactly are the criteria for tainting? Our driver locking strategy
> >> is something we want to refactor and having lock debugging during that
> >> transition may be a life safer.
> >
> > cat /proc/sys/kernel/tainted
> 
> Please note that Documentation/sysctl/kernel.txt is missing the explanation for 
> two bits in the value printed:
> 
> 2048 - The system is working around a severe firmware bug.
> 4096 - An out-of-tree module has been loaded.
> 
> On my system, bit 4096 is set due to loading the VirtualBox module, which 
> disables lock debugging lock debugging. I suspect that loading VMware would 
> cause the same condition.

Hmm. I wish OOT didn't disable lockdep, we do a lot of development with
modules OOT because the turnaround is faster/easier (for not so
experienced developers). Worst case we can patch it out of the base
kernel I guess...

johannes

