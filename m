Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2EWQ4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:56:13 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:54099 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760207Ab2EWQ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:56:10 -0400
Date: Wed, 23 May 2012 18:56:09 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: Watchdog settimeout causes an error condition
Message-ID: <20120523165609.GM3074@spo001.leaseweb.com>
References: <1335168639.11826.7.camel@dhruva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335168639.11826.7.camel@dhruva>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

> The new watchdog framework of settimeout causes an error condition for
> the DA9052/53 PMIC since watchdog ping gets called upon applying the new
> watchdog window and in the DA9052/53 PMIC we have a minimum time for the
> watchdog window called TWDMIN. A write to the watchdog before this
> elapsed time - TWDMIN - cause an error.
> 
> Can this be get fixed in the new framework?

Imho this should not be fixed in the framework but in your driver.
Even if we would change the framework, it will always be possible that
userspace will do a set-timeout and ping directly after each other.

What I would do is make sure that your driver makes sure that you can't write
before this TWDMIN window has passed.

Kind regards,
Wim.

