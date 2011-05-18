Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab1ERMD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 08:03:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42126 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964Ab1ERMD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 08:03:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SaOaS31xrYdAr/D4haraxmoppBHLmud9bP2oYOykUW3kk3ysP9tbfrpMuUPmSVasVH
         oFavyr2IEB+hsQWbHvI4QajdTIBx5iHdOCwg1aTgZodgwSmuTE9XQ7pPq/NxOgjc0tZe
         vymzhlnDwIyDxDhMp5+uxAeWiSr3jkzPIxANM=
Date: Wed, 18 May 2011 14:03:20 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: powerpc: mpc85xx regression since 2.6.39-rc2, one cpu core lame
Message-ID: <20110518120320.GA3025@riccoc20.at.omicron.at>
References: <20110517162827.GA16918@riccoc20.at.omicron.at>
 <1305668416.2781.23.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305668416.2781.23.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 07:40:16AM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2011-05-17 at 18:28 +0200, Richard Cochran wrote:
> > Ben,
> > 
> > Recent 2.6.39-rc kernels behave strangely on the Freescale dual core
> > mpc8572 and p2020. There is a long pause (like 2 seconds) in the boot
> > sequence after "mpic: requesting IPIs..."
> > 
> > When the system comes up, only one core shows in /proc/cpuinfo. Later
> > on, lots of messages appear like the following:
> > 
> >    INFO: task ksoftirqd/1:9 blocked for more than 120 seconds.
> > 
> > I bisected [1] the problem to:
> > 
> >    commit c56e58537d504706954a06570b4034c04e5b7500
> >    Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >    Date:   Tue Mar 8 14:40:04 2011 +1100
> > 
> >        powerpc/smp: Create idle threads on demand and properly reset them
> > 
> > I don't see from that commit what had gone wrong. Perhaps you can
> > help resolve this?
> 
> Hrm, odd. Kumar, care to have a look ? That's what happens when you
> don't get me HW to test with :-)

(I get the feeling that I am the only one testing recent kernels with
the mpc85xx.)

Anyhow, I see that this commit was one of a series. For my own use,
can I simply revert this one commit independently?

Thanks,
Richard
