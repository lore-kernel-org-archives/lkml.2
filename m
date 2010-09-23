Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0IWMxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:53:35 -0400
Received: from vgersoft.com ([24.97.191.94]:55659 "EHLO vgersoft.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab0IWMxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:53:34 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Sep 2010 08:53:34 EDT
Date: Thu, 23 Sep 2010 08:46:30 -0400 (EDT)
From: Steve Thompson <smt@vgersoft.com>
To: Alex Adriaanse <alex@innovacomputing.com>
cc: linux-kernel@vger.kernel.org, drbd-user@lists.linbit.com
Subject: Re: [DRBD-user] Hanging kernel
In-Reply-To: <4C9AA4EB.70407@innovacomputing.com>
Message-ID: <alpine.LRH.0.9999.1009230842330.5001@helios.vgersoft.com>
References: <4C9AA4EB.70407@innovacomputing.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010, Alex Adriaanse wrote:

> I'm administering a server that has frozen three times over the past two 
> days.  During these times, it seemed that most processes would all of a 
> sudden start hanging, and I couldn't SSH into the server or even log into the 
> console.  I would start seeing messages like "INFO: task kswapd0:28 blocked 
> for more than 120 seconds" on the console shortly after the processes hung. 
> The only way I could get the server to respond again was by resetting it.

This may not apply in your situation, but the only times I have ever seen 
this (and I've seen it several times), it was due to VM parameters that 
were inappropriate for the work load. Usually, if you wait long enough 
(sometimes as much as 20 minutes), the system will recover and continue. 
What are your values of:

 	sysctl vm.dirty_ratio
 	sysctl vm.dirty_background_ratio

I have had success in these situations by setting the former to 50, and 
the latter to 5, but the optimum values are sensitive to your peak load.
I don't believe that it has any direct connection with drbd.

Steve
----------------------------------------------------------------------------
Steve Thompson                 E-mail:      smt AT vgersoft DOT com
Voyager Software LLC           Web:         http://www DOT vgersoft DOT com
39 Smugglers Path              VSW Support: support AT vgersoft DOT com
Ithaca, NY 14850
   "186,300 miles per second: it's not just a good idea, it's the law"
----------------------------------------------------------------------------
