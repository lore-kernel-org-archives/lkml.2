Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab1ESMtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:49:18 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:60902 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933135Ab1ESMtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:49:11 -0400
Subject: Re: [RFC/PATCH 00/13] wl12xx re-factor
From: Luciano Coelho <coelho@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1305321990-22041-1-git-send-email-balbi@ti.com>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 15:49:05 +0300
Message-ID: <1305809345.12586.1579.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-14 at 00:26 +0300, Felipe Balbi wrote:
> Hi Luca,

Hi Felipe,


> this is the re-factor I was talking to you
> about. Please have a look and give your
> comments.
> 
> It probably won't work as is, I compile
> tested only, but it shows the idea.

This looks very good! I think we should do something like this to avoid
the code that is duplicated in the bus modules.

But, as I already mentioned briefly on IRC, there is a problem with the
way you changed the platform data structure, because it will break
compat-wireless.  The actual memory and data that is used by the
platform data is in the board components and not part of the wireless
subsystem.  With compat-wireless, we need to make sure that new stuff
works with older kernels.  In your patches you modify the platform data
structure, so when we run an old kernel with new compat-wireless, things
will break.

We already found a similar bug due to a previous change in the platform
data structure, so I don't want this to happen again.  So for now, I'll
keep these patches aside, but as soon as we find a good solution, I'll
definitely use your ideas here (or ask you to rebase :P).

I'll probably apply some of the patches that are not related to the
platform data change.  I'll respond to those specific patches
separately.

-- 
Cheers,
Luca.

