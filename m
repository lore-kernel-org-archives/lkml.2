Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1EDQup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:50:45 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60093 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab1EDQum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:50:42 -0400
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
From: Max Asbock <masbock@linux.vnet.ibm.com>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain
Date: Wed, 04 May 2011 09:51:00 -0700
Message-Id: <1304527860.21305.5.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 20:11 -0700, John Stultz wrote:
> From: John Stultz <johnstul@us.ibm.com>
> 
> So get_seconds() has always been lock free, with the assumption
> that accessing a long will be atomic.
> 

get_seconds() is used in the x86 machine check handler and there is a
comment saying:
/* We hope get_seconds stays lockless */

This needs to be carefully looked at if locking is introduced to
get_seconds().

- Max

