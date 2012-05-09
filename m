Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2EIKtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 06:49:42 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:39187 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab2EIKtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 06:49:41 -0400
Message-ID: <1336560579.2097.32.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        bp@alien8.de
Date: Wed, 09 May 2012 20:49:39 +1000
In-Reply-To: <4FAA2673.50007@linux.vnet.ibm.com>
References: <1336515735.2097.23.camel@shrek.rexursive.com>
	 <4FAA2673.50007@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 13:40 +0530, Srivatsa S. Bhat wrote:
> > +             error = suspend_devices_and_enter(PM_SUSPEND_MEM);
> 
> 
> I can imagine running into a host of problems here, since the suspend
> sequence is not carried out fully, from the beginning.
> 
> For example, this will skip sending out the PM_SUSPEND_PREPARE and the
> PM_POST_SUSPEND notifiers. Worse, we actually send out the
> PM_HIBERNATION_PREPARE
> and PM_POST_HIBERNATION notifiers and then do a suspend instead,
> underneath!
> 
> (Similar cases for the rest of the notifiers sent during suspend vs
> hibernation).
> 
> Don't we need to handle such things properly, in order to make
> suspend-to-both
> work reliably? 

Honest answer - I have absolutely no idea. I've seen the code of
suspend-utils (i.e. user mode stuff) and it seems to me that it does
exactly this. Could be wrong of course, just like many times before.

Rafael?

-- 
Bojan

