Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1AZTiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:38:13 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:53206 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1AZTiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:38:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o4grVlTN9VSvCmRb6/lpuDgQaDizuJdfxkxYrEe4pjP3dk1wY+jbupbTgyJQF/+27z
         A58V1YbrATZTB/byrXI5fbPNklh+22G2UhMa+0+FA11+uaTvn7lNO8gDvGwphUFxC9IP
         IuC6Cwp10WtB6ifKNC5Y1Dr7JHca42iRGanxo=
Date: Wed, 26 Jan 2011 11:38:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110126193804.GD29268@core.coreip.homeip.net>
References: <20110125164803.GA19701@core.coreip.homeip.net>
 <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
 <20110125205453.GA19896@core.coreip.homeip.net>
 <4D3F4804.6070508@redhat.com>
 <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D403855.4050706@teksavvy.com>
 <20110126164359.GA29163@core.coreip.homeip.net>
 <4D4076A0.9090805@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4076A0.9090805@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 02:31:44PM -0500, Mark Lord wrote:
> On 11-01-26 11:44 AM, Dmitry Torokhov wrote:
> > On Wed, Jan 26, 2011 at 10:05:57AM -0500, Mark Lord wrote:
> ..
> >> Nope. Does not work here:
> >>
> >> $ lsinput
> >> protocol version mismatch (expected 65536, got 65537)
> >>
> > 
> > It would be much more helpful if you tried to test what has been fixed
> > (hint: version change wasn't it).
> 
> It would be much more helpful if you would revert that which was broken
> in 2.6.36.  (hint: version was part of it).
> 

No, version change will not be reverted as we do not have a way to
validate whether new ioctls are supported. The older kernels are
returning -EINVAL for unknown evdev ioctls so userspace can't know
if ioctl failed because it is unsupported or because arguments are
wrong/not applicable for the underlying device.

> The other part does indeed appear to work with the old binary for input-kbd,
> but the binary for lsinput still fails as above.
> 

Great, then I'' include the fix for RC keytables in my next pull
request. I guess it should go to stable as well.

Thanks.

-- 
Dmitry
