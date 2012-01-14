Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab2ANU6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:58:51 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15005 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab2ANU6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:58:50 -0500
Date: Sat, 14 Jan 2012 21:58:49 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: dri-devel@lists.freedesktop.org,
        Octavian Purdila <octavian.purdila@intel.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, David Airlie <airlied@linux.ie>,
        Eric Anholt <eric@anholt.net>, Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: [PATCH] intel, gma500, lvds: Fix use after free on
 psb_intel_lvds_init()
In-Reply-To: <alpine.LNX.2.00.1201142056190.11547@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1201142156220.11547@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201142056190.11547@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jan 2012, Jesper Juhl wrote:

> In psb_intel_lvds_init(), if we fail to allocate memory for
> 'psb_intel_connector' we free the memory we previously allocated for
> 'psb_intel_encoder', but we then proceed to use that free'd pointer
> when we do 'psb_intel_encoder->dev_priv = lvds_priv;'.
> 
> I believe the proper way to handle this is to simply return after the
> allocation for 'psb_intel_connector' has failed. That is what this
> patch does.
> 

Ok, so I just noticed that we may also leak 'psb_intel_encoder' if we 
'goto failed_connector;'. Might as well fix that as well in the same 
patch.

So please just ignore this one. I'll submit a new one in a little 
while that handles both leaks.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

