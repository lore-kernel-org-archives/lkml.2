Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab2C3HtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 03:49:13 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56719 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab2C3HtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 03:49:07 -0400
MIME-Version: 1.0
In-Reply-To: <4F754963.4080104@kernel.org>
References: <1333001380-6050-1-git-send-email-ming.m.lin@intel.com>
	<1333001380-6050-4-git-send-email-ming.m.lin@intel.com>
	<4F754963.4080104@kernel.org>
Date: Fri, 30 Mar 2012 15:49:06 +0800
Message-ID: <CAC=cRTMneWKgH_So+JO6h+w4S-SpgcX=pbY5QeWuFc6HXvCATQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] PM / Runtime: Add may_power_off flag to subsys data
From: huang ying <huang.ying.caritas@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 1:49 PM, Len Brown <lenb@kernel.org> wrote:
> Why?

1) To support something like pm-qos.  power off device may have more
exit.latency than normal low power state (such as D3Hot).  Some device
may disable may_power_off based on that.  It can be used to implement
the logic like,  only power off SSD, not HDD.

2) Whether to go to power off should be determined by leaf device
(such as SATA disk), but that may be done by its parent device (such
as SATA port).  It's a way for leaf device to tell its parent device
whether it want to go to power off.

Best Regards,
Huang Ying
