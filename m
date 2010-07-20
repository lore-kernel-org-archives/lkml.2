Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0GTHrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:47:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60173 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0GTHrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:47:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LFEd54I19zEKZRa1xpcdreuriWx1x1dusae5PeiYcVdm/f76D6/SVwk0n72xA3b1Ng
         2xwF5JIISrs+uxEYlnYpOFHIjqMLulQH/E7GxR6IVahjyHb3/70r4u7+h3GuPZy6NvGB
         O5w0e20cQN0uUHzNONHvLitdmqvksjt/zPfFY=
Date: Tue, 20 Jul 2010 11:46:59 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Yulia Vilensky <vilensky@compulab.co.il>,
        Geert Stappers <stappers@stappers.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ds2782_battery: Rename get_current and get_voltage
 operations
Message-ID: <20100720074659.GA32073@oksana.dev.rtsoft.ru>
References: <1279584175.4883.226.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1279584175.4883.226.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 01:02:55AM +0100, Ben Hutchings wrote:
> commit 9b9ade6b612e562c4a5bd02ef38cc32e10f3f9ba "ds2782_battery: Add
> support for ds2786 battery gas gauge" introduced an operation named
> get_current.  Since get_current() is defined as a macro on some
> architectures this driver no longer compiles on those architectures.
> 
> Rename get_current to get_current_now to avoid the macro.
> Rename get_voltage to get_voltage_now for consistency.
> 
> Reported-by: Geert Stappers <stappers@stappers.nl>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---

Thanks for the patch, but I have a similar fix in the
battery-2.6.git tree (for -next):

commit eb9650d6d989f24f21232a055d8fd45f1a9dcf99
Author: Peter Huewe <peterhuewe@gmx.de>
Date:   Thu May 13 01:54:57 2010 +0200

    ds2782_battery: Rename get_current to fix build failure / name conflict

    This patch changes the name of get_current function pointer to
    get_battery_current to resolve a name conflict with the get_current
    macro defined in current.h.

    This conflict resulted in a build-failure[1] for the sh4 arch
    allyesconfig:

      drivers/power/ds2782_battery.c:216:48: error: macro "get_current"
      passed 2 arguments, but takes just

    This patch fixes the issue. To be consistent the other function pointers
    (_voltage,_capacity) were renamed too.

    Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
    Acked-by: Ryan Mallon <ryan@bluewatersys.com>
    Acked-by: Mike Rapoport <mike@compulab.co.il>
    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

I'm not pushing this into 2.6.35 as this is not a 2.6.35 regression,
it's there since 2.6.33, and nobody seemed to care for two releases.
So, I'm not considering this as urgent.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
