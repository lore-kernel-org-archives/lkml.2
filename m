Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab0ICVpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:45:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44879 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577Ab0ICVpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WvfxLiIwDUxGP6Zfq5M11uMbugC1rWjQEdVZYH6L7W2+Q8rlsu5QfyMsCMhCfMN5yM
         UFx+jEsBZzhkJlRVmCyLULCgk/s0BTnbk/kcDqPA3/ydrbp4qQ6dvtynbEBb2kO1+F+f
         Fa+MNz79wzLIIFMqw5t7IjBDDCrXza07wizU8=
Date: Fri, 3 Sep 2010 14:45:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Luotao Fu <l.fu@pengutronix.de>, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: stmpe-ts - return -ENOMEM if memory
 allocation fail
Message-ID: <20100903214540.GB6412@core.coreip.homeip.net>
References: <1283477451.5439.6.camel@mola>
 <1283477533.5439.8.camel@mola>
 <20100903213524.GA32515@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903213524.GA32515@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 11:35:24PM +0200, Wolfram Sang wrote:
> On Fri, Sep 03, 2010 at 09:32:13AM +0800, Axel Lin wrote:
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Basically correct. Should be simpler to just use
> 
> 	int ret = -ENOMEM;
> 
> though.
> 

No! I hate when people initialize error values like that, because it is
so easy to miss the case and end up with wrong value. If the original
version of the driver did not initialize it to 0 compiler would warn
the author and the error would not make it into the mainline to begin
with.

Please explicitly assign error codes in error handling path.

Thanks.


-- 
Dmitry
