Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1BHTde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:33:34 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54530 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab1BHTdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:33:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JaV8Tl9/X5AvPkj+tnGUv50GxyIl5dpVahtmN4VdEBi/nBzQ6I8S4S1QAtSjheHlaS
         mr3UVH1f5J0onmGpuFV78xCsTfZ0rH2gfgWTUjfj5TcmotdD/7X2y+LQ9hlogoHo/RO2
         6khiWy18tH1S0SKzeboVjXImcVauJHkhTr4jw=
Date: Tue, 8 Feb 2011 11:33:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Message-ID: <20110208193321.GA16527@core.coreip.homeip.net>
References: <1297121021-3522-1-git-send-email-iws@ovro.caltech.edu>
 <1297121021-3522-2-git-send-email-iws@ovro.caltech.edu>
 <20110208073309.GB906@core.coreip.homeip.net>
 <20110208172046.GB10125@ovro.caltech.edu>
 <20110208175028.GD4476@core.coreip.homeip.net>
 <20110208191143.GC10125@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208191143.GC10125@ovro.caltech.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 11:11:44AM -0800, Ira W. Snyder wrote:
> On Tue, Feb 08, 2011 at 09:50:29AM -0800, Dmitry Torokhov wrote:
> > On Tue, Feb 08, 2011 at 09:20:46AM -0800, Ira W. Snyder wrote:
> > 
> > > Go back and re-think my loop. This is a
> > > common idiom straight of out LDD3 pages 153-154.
> > > 
> > > You should note that it is only possible to exit the loop with the lock
> > > held AND !list_empty(used). The lock protects the used list, and
> > > therefore, there must be a buffer on the list.
> > 
> > No, because you are woken up while not holding the lock so another
> > reader is free to take it off the list.
> > 
> 
> Correct. But then I go around the loop and check list_empty() again
> before exiting the loop. The list MUST NOT be empty before the loop will
> terminate.

Yes, you are right, I competely missed the fact that we'd loop around
and check the condition again. I'll go grab another coffee now.

-- 
Dmitry
