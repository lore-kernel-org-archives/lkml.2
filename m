Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab0H3Q3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:29:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62678 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab0H3Q3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QPAi6ip1OM71NX05I1qLlUd+N9GxgHNuZpLaRR1pHbCYSiy1r8J/tPd/YfWddVXkt5
         HekiIwWC4dGygBYwFp399WKUHM1tIG0d74ODo7HYhxTiz4jttDsjwJvXjtISRGpZx35A
         Px/jpXr5z9Rz6l1K+nHdSvEpfgxSU2CKzl97w=
Date: Mon, 30 Aug 2010 09:28:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Hemanth V <hemanthv@ti.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        igor.stoppa@nokia.com, kai.svahn@nokia.com, matthias.nyman@nokia.com
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
Message-ID: <20100830162855.GA17325@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
 <20100829184904.GC26209@core.coreip.homeip.net>
 <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Mon, Aug 30, 2010 at 11:04:39AM -0500, Felipe Balbi wrote:
> Hi Dmitry,
> 
> When we tried to push N900's accelerometer driver as an
> input device you commented you didn't want sensors such
> as accelerometers, magnetometers, proximity, etc on the
> input layer because "they are not user input", although
> I didn't fully agree with you, we had to modify the drivers
> and, I believe, one of them is sitting in staging under
> the industrial i/o subsystem.
> 
> Are you now accepting sensor drivers on the input layer ?
> that will make our life a lot easier but we need some
> definition to avoid having to re-work drivers when we
> want to push them to mainline.
> 

I got persuaded that 3-axis accelerometers are most often indended to be
used as input devices so I decided I should take these in (adxl134x is
there). I still think that sensor devices in general are better suited
to IIO subsystem and I hope it will get out of staging soon.

Once it is out of staging we may think about creating a IIO-to-input
bridge (copuld be either in kernel or a userspace solution based on
uinput) to route sensors that are indeed used as HIDs.

Hope this makes sense.

-- 
Dmitry
