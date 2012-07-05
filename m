Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab2GEO3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab2GEO3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:29:41 -0400
Message-ID: <4FF5A4CC.3050302@redhat.com>
Date: Thu, 05 Jul 2012 10:29:32 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux@openhuawei.org
Subject: Re: [PATCH 2/3] [RFC] time: Fix leapsecond triggered hrtimer/futex
 load spike issue
References: <1341382890-42324-1-git-send-email-johnstul@us.ibm.com> <1341382890-42324-3-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1341382890-42324-3-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/04/2012 02:21 AM, John Stultz wrote:
> As widely reported on the internet, some Linux systems after
> the leapsecond was inserted are experiencing futex related load
> spikes (usually connected to MySQL, Firefox, Thunderbird, Java, etc).
> 
> An apparent for this issue workaround is running:
> $ date -s "`date`"
> 
> Credit: http://www.sheeri.com/content/mysql-and-leap-second-high-cpu-and-fix
> 
> I this issue is due to the leapsecond being added without
> calling clock_was_set() to notify the hrtimer subsystem of the
> change.
> 
> The workaround functions as it forces a clock_was_set()
> call from settimeofday().
> 
> This fix adds the required clock_was_set() calls to where
> we adjust for leapseconds.
> 
> NOTE: This fix *depends* on the previous fix, which allows
> clock_was_set to be called from atomic context. Do not try
> to apply just this patch.
> 
> CC: Prarit Bhargava <prarit@redhat.com>
> CC: stable@vger.kernel.org
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: linux@openhuawei.org
> Reported-by: Jan Engelhardt <jengelh@inai.de>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>


Acked-by: Prarit Bhargava <prarit@redhat.com>

P.
