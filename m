Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab1DZASj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:18:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45329 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab1DZASh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=axZrFVBWiZCics86SKIhNRa9RvL2kz+y0oWKNGcNZbOYSviW9ZDopXBGmCkCk0Xc6F
         SkuToaD08KOaeR4OwevNsHNhj9KpPxgFj2/aAGZeChzAuzMKd0ODyIj875GdQxb2zF4S
         dvHSL5Wu0rVoe6Zhr+rEB4izZM+O0qHbSdaB4=
MIME-Version: 1.0
In-Reply-To: <4DB604C7.8090305@codeaurora.org>
References: <4DB604C7.8090305@codeaurora.org>
Date: Mon, 25 Apr 2011 17:18:37 -0700
Message-ID: <BANLkTimPHaiiiVC_A6jtUtaa_pYJuhepYg@mail.gmail.com>
Subject: Re: console_cpu_notify can cause scheduling BUG during CPU hotplug
From: Kevin Cernekee <cernekee@gmail.com>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, simon.kagstrom@netinsight.net,
        David.Woodhouse@intel.com, lethal@linux-sh.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 4:33 PM, Michael Bohan <mbohan@codeaurora.org> wrote:
> I was curious if this scenario was accounted for in the design of the
> console CPU notifier. One workaround for this problem is to remove CPU_DEAD
> from the possible actions in console_cpu_notify(). In fact, v1-v4 of the
> patch above did not have CPU_DEAD, CPU_DYING or CPU_DOWN_FAILED in the list
> of actions. I wasn't able to track down why the other cases were added in
> the final patch.

Here is the background information on the CPU_{DEAD,DYING,DOWN_FAILED} cases:

http://lkml.org/lkml/2010/6/29/65
