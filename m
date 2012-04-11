Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2DKKLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:11:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:57890 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2DKKLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:11:04 -0400
Date: Wed, 11 Apr 2012 12:10:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: suresh.b.siddha@intel.com, santosh.shilimkar@ti.com,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: [PATCH] clockevents: Leave broadcast device shtudown only if
 the current device is always running.
In-Reply-To: <20120411063452.GA25399@feng-i7>
Message-ID: <alpine.LFD.2.02.1204111208070.2542@ionos>
References: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com> <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com> <CA++bM2th5XW1gxrHbcHwDK=qBBaNc3ut0ydbNNStfNa-Xa-9tA@mail.gmail.com> <20120411063452.GA25399@feng-i7>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012, Feng Tang wrote:
> > Problem you encountered is not related to leaving the broadcast device
> > in shutdown mode. Problem is that we didn't track the mode change to
> > oneshot and later during idle entry/exit, when we request the broadcast
> > device services using CLOCK_EVT_NOTIFY_BROADCAST_ENTER etc,
> > tick_broadcast_oneshot_control() returns with out doing much as it
> > thinks broadcast device is in periodic mode.
> 
> Just curious, IIUC, the tick_broadcast_switch_to_oneshot() is only called
> during CPU init process in boot time or bring a offlined cpu back on. Why
> is it related to the deep idle?

Because a deep idle state might require the broadcast device and w/o
Suresh's patch it can't use it because it's in the wrong state.

Thanks,

	tglx
