Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1EDWbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 18:31:07 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35210 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1EDWbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 18:31:05 -0400
Subject: Re: [PATCH 0/3] repair RTC subsys (for i.MX)
From: john stultz <johnstul@us.ibm.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
In-Reply-To: <1304523088-17039-1-git-send-email-w.sang@pengutronix.de>
References: <1304523088-17039-1-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 15:30:59 -0700
Message-ID: <1304548259.2943.5.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 17:31 +0200, Wolfram Sang wrote:
> The recent updates to the RTC subsystem (removing UIE interrupts and use
> alarms instead) introduced two problems for i.MX (and the subsys in
> general, I'd think):
> 
> a) because registering the rtc now calls get_alarm(), the requirement
> has been added for a lot of drivers that drvdata is properly set up
> _before_ registering. rtc-mxc did not do that (probably bad; but as said
> like a lot of other rtc-drivers currently) and oopsed.
> 
> b) the callbacks to the rtc-core for update_irqs have been removed, but
> irq-handlers are still there, now being unused cruft. In case of
> rtc-mxc, this is only one if-block, but for rtc-mc13xxx.c this is a
> seperate handler.
> 
> From a glimpse, most platform drivers seem to have at least one of these
> problems now :( John, am I correct or am I missing something?

I've tried to go through and clean up most of the b) issues, although
some have apparently slipped by. Please let me know of any others you
ran across.

And indeed we've hit a few of issue a) already, so I should probably run
through and do a full audit.

Your patches look fine to me. Do you intend to push them or should I
queue them up?

thanks
-john

