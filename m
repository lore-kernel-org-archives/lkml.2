Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab1CDVKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:10:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60322 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab1CDVKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:10:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HyEa8xCfpFdRO7vB2wc5S+l2SgSQp8enX2KK9m0RQ/8qIjuION6aZGBajhVrlJw01R
         BLDxZNzKUB2wTegsJRHc4D8UluQmJ7NIcTMoNDEfl2GUw6eCGqBtb5JYsCU3lGFMQJ8v
         HyF8puKOhJpM0724mfy5CIotIlXVRWGsQc74s=
Date: Sat, 5 Mar 2011 00:10:35 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] power: disable hibernation if module loading is
 disabled
Message-ID: <20110304211035.GA28842@albatros>
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
 <201103042142.09247.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103042142.09247.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 21:42 +0100, Rafael J. Wysocki wrote:
> That "everyone" is actually the "full root" (in the case of /sys/power/state)
> or someone having CAP_SYS_ADMIN in the /dev/snapshot case, right?

Yes, sorry for my bad english.  "Everyone" is indeed misleading :-D

> Second, there's _zero_ relationship between /proc/sys/kernel/modules_disabled
> and the hibernation interface, so please find a different way to solve the
> problem (if there is any).

If modules_disabled is set to 1, then nobody, even full root may not write
to the kernel, right?  So, if something permits to indirectly pass
modules_disabled restriction, this is a bug.  Otherwise,
modules_disabled is confusing as it gives false sense of security.

-OR-

modules_disabled's documentation should be changed to note that it
doesn't prevent rootkit uploading, but only forbids modprob'ing modules
via the "official" init_module(2) gate, disallowing e.g. module autoloading.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
