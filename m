Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1CYHt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:49:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40824 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab1CYHtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ICpXPD3GHmvGgQ2Wo2PNapeRy4KH3RBlRqrPQtPRbOnZ+ehFPdyfW7kiTDnBVHmCBA
         yRzIz7CGimGkHEZFS/pqrppE+o7BgAF8Ga8x1kEKnfThPD2HUOAcC5iOfjDsipbSGczv
         s1WSC5SKrJ38ptyib8gTQuA9+TRoOIZVuPeH8=
Date: Fri, 25 Mar 2011 00:49:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jeff Brown <jeffbrown@android.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] input: evdev: only wake poll on EV_SYN
Message-ID: <20110325074920.GF2590@core.coreip.homeip.net>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
 <1300842244-42723-5-git-send-email-jeffbrown@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300842244-42723-5-git-send-email-jeffbrown@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 06:04:04PM -0700, Jeff Brown wrote:
> On SMP systems, it is possible for an evdev client blocked on poll()
> to wake up and read events from the evdev ring buffer at the same
> rate as they are enqueued.  This can result in high CPU usage,
> particularly for MT devices, because the client ends up reading
> events one at a time instead of reading complete packets.  This patch
> ensures that the client only wakes from poll() when a complete packet
> is ready to be read.

Doesn't this only help with very first packet after a pause in event
stream?

-- 
Dmitry
