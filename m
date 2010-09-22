Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0IVAIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 20:08:30 -0400
Received: from kroah.org ([198.145.64.141]:55539 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab0IVAI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 20:08:29 -0400
Date: Tue, 21 Sep 2010 17:01:01 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karsten Mehrhoff <kawime@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, stable@kernel.org
Subject: Re: [stable] regression in 2.6.35.4 'load is to heavy (video
 subsystem?)'
Message-ID: <20100922000101.GA5077@kroah.com>
References: <op.vh8rams6gp7xae@127.0.0.1>
 <20100921165007.6200846f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921165007.6200846f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 04:50:07PM -0700, Andrew Morton wrote:
> On Mon, 30 Aug 2010 10:02:36 +0200
> Karsten Mehrhoff <kawime@gmx.de> wrote:
> 
> > Using the same .config from 2.6.35.3 to compile 2.5.36.4 results in a  
> > heavy load with 2.6.35.4.
> 
> A regression within -stable is rather bad.

Agreed.

> > Example:
> > 
> > Difference between 2.6.35.1/2/3 and 2.6.35.4 while watching some videos:
> > 2.6.35.4 switches the cpu for flash videos in the browser (opera or  
> > iceweasel) or other video outputs to 2200/2400/2600 MHz meanwhile 2.6.35.3  
> > (or older) stays at 1000 Mhz. That results in a higher cpu temperature,  
> > more power consumption and so one.
> > 
> > Using other GUI program results in nearly the same problems with 2.6.35.4,  
> > so this kernel is unusable for me.
> > 
> > Results to see the difference for the same action
> > 2.6.35.4
> > Core0 Temp:  +45.0__C
> > Core1 Temp:  +43.0__C
> > cpu MHz:	2200.000 or higher
> > 
> > 2.6.35.3
> > Core0 Temp:  +32.0__C
> > Core1 Temp:  +31.0__C
> > cpu MHz:	1000.000 (max. 1800, but falling back to 1000)

Can you run 'git bisect' between 2.6.35.3 and 2.6.35.4 to try to find
out the offending patch that caused this issue?

thanks,

greg k-h
