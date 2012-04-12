Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784Ab2DLB1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:27:37 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62965 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab2DLB1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <tip-fa4da365bc7772c2cd6d5405bdf151612455f957@git.kernel.org>
References: <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
	<tip-fa4da365bc7772c2cd6d5405bdf151612455f957@git.kernel.org>
Date: Thu, 12 Apr 2012 09:27:35 +0800
Message-ID: <CAGjg+kFqZ2g4GV8r-NLujMVP7p9W2vUNZszxEFVs6eohSFv_PA@mail.gmail.com>
Subject: Re: [tip:timers/urgent] clockevents: tTack broadcast device mode
 change in tick_broadcast_switch_to_oneshot()
From: Alex Shi <lkml.alex@gmail.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, santosh.shilimkar@ti.com,
        tglx@linutronix.de, Alex Shi <alex.shi@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 5:49 PM, tip-bot for Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> Commit-ID:  fa4da365bc7772c2cd6d5405bdf151612455f957
> Gitweb:     http://git.kernel.org/tip/fa4da365bc7772c2cd6d5405bdf151612455f957
> Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> AuthorDate: Mon, 9 Apr 2012 15:41:44 -0700
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 10 Apr 2012 11:42:07 +0200
>
> clockevents: tTack broadcast device mode change in tick_broadcast_switch_to_oneshot()
>
> In the commit 77b0d60c5adf39c74039e2142a1d3cd1e4d53799,
> "clockevents: Leave the broadcast device in shutdown mode when not needed",
> we were bailing out too quickly in tick_broadcast_switch_to_oneshot(),
> with out tracking the broadcast device mode change to 'TICKDEV_MODE_ONESHOT'.
>
> This breaks the platforms which need broadcast device oneshot services during
> deep idle states. tick_broadcast_oneshot_control() thinks that it is
> in periodic mode and fails to take proper decisions based on the
> CLOCK_EVT_NOTIFY_BROADCAST_[ENTER, EXIT] notifications during deep
> idle entry/exit.
>
> Fix this by tracking the broadcast device mode as 'TICKDEV_MODE_ONESHOT',
> before leaving the broadcast HW device in shutdown mode if there are no active
> requests for the moment.
>

This patch recovered the loopback netperf testing on NHM machine, but
on SNB machine, It isn't need a broadcost timer at all.

Do you think it is better to remove oneshot broadcast on WSM/SNB machine?
