Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab0LCAVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:21:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60881 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab0LCAVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:21:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 3 Dec 2010 09:15:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Ondrej Zary <linux@rainbow-software.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM / Hibernate: Fix memory corruption related to swap
Message-Id: <20101203091508.9fabf04d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201012030040.37273.rjw@sisk.pl>
References: <201012030040.37273.rjw@sisk.pl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010 00:40:36 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> There is a problem that swap pages allocated before the creation of
> a hibernation image can be released and used for storing the contents
> of different memory pages while the image is being saved.  Since the
> kernel stored in the image doesn't know of that, it causes memory
> corruption to occur after resume from hibernation, especially on
> systems with relatively small RAM that need to swap often.
> 
> This issue can be addressed by keeping the GFP_IOFS bits clear
> in gfp_allowed_mask during the entire hibernation, including the
> saving of the image, until the system is finally turned off or
> the hibernation is aborted.  Unfortunately, for this purpose
> it's necessary to rework the way in which the hibernate and
> suspend code manipulates gfp_allowed_mask.
> 
> This change is based on an earlier patch from Hugh Dickins.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Ondrej Zary <linux@rainbow-software.org>
> Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks,
-Kame

