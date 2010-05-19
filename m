Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0ESAAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 20:00:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45817 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab0ESAA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 20:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G42h76lB68GtZZ2YUKVSDt+lxigaZiOqCPCiIw1wPr6/HZstu+HMmAqGhEvstjOUji
         L6kaOZSse/MLBzx7OvTwFt/Mb84OZz5Lsps4KJYVNJZ/uJy0mnbDyop+KZRrj9S/yeiV
         4uWqTFFaa8IHplL9CD1wJTdJbLmqaUgo2dWJs=
Date: Tue, 18 May 2010 17:00:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
       Michael Roth <mroth@nessie.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] touchscreen: ads7846: please don't touch free'd memory
Message-ID: <20100519000019.GA17475@core.coreip.homeip.net>
References: <1274226413-8520-1-git-send-email-khilman@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274226413-8520-1-git-send-email-khilman@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 04:46:53PM -0700, Kevin Hilman wrote:
> If the _probe() method fails, the 'ts' struct is freed, yet it is
> still used as the drvdata passed to suspend/resume/remove methods.
> Even though the input device does not get registerd, the driver's
> suspend/resume methods still get called as it's a registered SPI
> device.  This patch adds sanity checks to these methods to ensure that
> drvdata is valid before using it.
> 

This is a load of crap. If probe() fails that means that driver does not
manage the device and thus ads7846_suspend() and ads7846_resume() should
not be called _at all_. If SPI core manages to call random methods from
the drivers that failed to bind to a device that should be fixed in SPI
core.

Thanks.

-- 
Dmitry
