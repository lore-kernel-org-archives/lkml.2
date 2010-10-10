Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab0JJU7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 16:59:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36937 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab0JJU7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 16:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OpBserDq8dFOqB4iK85X8lHfviQzhGeggoiykVBVKeYuhSimiGcq9iTHDUrPRw5D8s
         6stPZ0ADW3s3XDdcFQexaza7a5F3x5FW9mYrUXohZMU7pfYMGYgA1S+5ogQCn4PVorqS
         CXzv0j66yp3oS0TI7plW9u/vIsXaDrC1zIWWI=
Date: Sun, 10 Oct 2010 13:59:32 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Takashi Iwai <tiwai@suse.de>, Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Input: synaptics - multitouch and multifinger support
Message-ID: <20101010205932.GB18455@core.coreip.homeip.net>
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>
 <s5hfwwg4p4t.wl%tiwai@suse.de>
 <4CB17019.7070002@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB17019.7070002@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 09:49:45AM +0200, Henrik Rydberg wrote:
> Takashi, Chase,
> 
> talk about Heinz effect. :-)
> 
> Rather than taking any of the patches, I was wondering if we could get a single
> patch including all the later findings and considerations on what devices should
> have the multitouch mode. Also, unless there is a really really good reason for
> it, without kernel parameters. After all, these patches should only add new
> functionality without regressions.

Yes, I think we should limit number of module options (and even more so
Kconfig options). I believe that either MT support is ready for prime-time
and then it should be enabled unconditionally, or it is not ready and
should be kept as patches. his also means that we should not introduce
regressions in ST (even when emulated in MT mode).

> 
> Regarding the clickpad functionality, it is similar to the macbook pads with
> integrated buttons, which has been implemented in userspace.

Right now we map the "click" to BTN_LEFT leaving it to the synaptics X
driver to work our the "click zone" support.

> 
> Regarding the tracking aspect of pointer emulation, Chase is completely right,
> and this is a generic problem for several drivers. Tracking a single point by
> picking the closest contact is a linear problem and could easily be performed in
> interrupt context. I suggest we add it directly to the synaptics driver and then
> revisit the question of adding generic tracking support to the kernel. Dmitry,
> how does that sound to you?

Sounds good to me. Hopefully it could be made it a library[ish] function
that several MT drivers could use to produce ST-compliant events.

-- 
Dmitry
