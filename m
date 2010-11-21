Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab0KUF7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 00:59:44 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63746 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab0KUF7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 00:59:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NY1Q9tv/HHyFdIqI9D+Zr8gJSNUKAtoU7KFLxTxDl6oYCcTaiEdlhEJeJFloWuXPa+
         ucCyEVnIRHq4XoW9dawpFMWpy1Sxu8iyh4Nbph9ODpO2DXLCm37Pf2urv9fBwrc0hGBx
         TBpHaQQcuYpRQtbpVwaqyMuMd/6C1kqCr7dos=
Date: Sun, 21 Nov 2010 14:02:51 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch] x86: avoid unnecessary smp alternatives switch during
	suspend/resume
Message-ID: <20101121060251.GD9099@hack>
References: <1290211764.2637.8.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290211764.2637.8.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 04:09:24PM -0800, Suresh Siddha wrote:
>During suspend, we disable all the non boot cpus. And during resume we bring
>them all back again. So no need to do alternatives_smp_switch() in between.
>
>This speeds up both suspend and resume paths.
>
>Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

This is a cool idea!

The patch looks good for me, just note that kexec
also calls disable_nonboot_cpus(), so the name 'pm_sleep_smp'
is a bit confused. ;)

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

-- 
Live like a child, think like the god.
 
