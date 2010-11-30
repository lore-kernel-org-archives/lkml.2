Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0K3JJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:09:44 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56749 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab0K3JJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:09:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hv/CsEQVUv8KNjmcQpoTFd0gBBUb6qGbM6EMP+Gk8pPD+CpQeWG0Til9tK0Ct5gP6n
         /+3M35QWHcGPgynr36yfFGyX15HRvAOTxqezHiDWsGFuChLyd/qe+269w8ukFhrrVLZU
         7qr63hnMLS3lnRwFfQKzjWZDqTZNpirOt4wFg=
Date: Tue, 30 Nov 2010 01:09:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] input: mt: Add pressure to pointer emulation code
Message-ID: <20101130090934.GC3952@core.coreip.homeip.net>
References: <1291014802-17061-1-git-send-email-rydberg@euromail.se>
 <1291014802-17061-5-git-send-email-rydberg@euromail.se>
 <20101129094715.GA9303@core.coreip.homeip.net>
 <4CF38C67.20509@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF38C67.20509@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 12:20:07PM +0100, Henrik Rydberg wrote:
> >> @@ -124,9 +125,13 @@ void input_mt_report_pointer_emulation(struct input_dev
> *dev)
> 
> >>  	if (oldest) {
> >>  		int x = input_mt_get_value(oldest, ABS_MT_POSITION_X);
> >>  		int y = input_mt_get_value(oldest, ABS_MT_POSITION_Y);
> >> +		int p = input_mt_get_value(oldest, ABS_MT_PRESSURE);
> > 
> > What if device does not report ABS_MT_PRESSURE/ABS_PRESSURE? Do we rely
> > on input core to suppress unsupported events? A comment would be nice...
> 
> 
> Yes, the setup values are the only ones producing output here. How about this
> addition to the function text: "The input core ensures only the KEY and ABS axes
> already setup for this device will produce output."?

Yep, that works.

> 
> > Also, is there a gelper to set up pointer emulation capabilities for MT
> > device?
> 
> 
> This is certainly the plan with time, but currently it seemed best to leave the
> rest of the event setup code untouched.
> 

OK, just throwing ideas around ;)

-- 
Dmitry
