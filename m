Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1AGKwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:52:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab1AGKwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:52:13 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 8/9] perf timechart: Map power:cpu_idle events to the corresponding cpuidle state
Date: Fri, 7 Jan 2011 11:52:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-18-desktop; KDE/4.5.3; x86_64; ; )
Cc: mingo@elte.hu, arjan@linux.intel.com, lenb@kernel.org, j-pihet@ti.com,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
References: <1294396190-23031-1-git-send-email-trenn@suse.de> <1294396190-23031-9-git-send-email-trenn@suse.de>
In-Reply-To: <1294396190-23031-9-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201101071152.11407.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh, forgot guilt refresh on this one.
The changelog could be a bit more detailed by adding:

On Friday 07 January 2011 11:29:49 Thomas Renninger wrote:
> Before, power:cpu_idle events were very specific X86 Intel mwait events.
> This got fixed with previous patches and cpu_idle events are now thrown by
> all cpuidle drivers and can be mapped to the corresponding cpuidle state
> in /sys.
> 
> This patch reads out the corresponding cpuidle name of a cpu_idle event
> and uses it in the title line of the chart (c-states Cx in x86, omap2
> - DDR self refresh states for various arm archs).
> 
> It also reads out the corresponding abbr(eviation) and uses the string
> to draw the cpu idle occurences. This needs a short (3 letter) string
> to keep the overview in the chart.

All features/fixes this patch includes:
  - Read up cpuidle events from sysfs if available
    and thus make them architecture independent
  - Use (free) green color to display idle events in the chart,
    red is also used by "Blocked IO" event(s)
  - Fix wrong class="rect.cX" to class="cX" idle box svg drawing
    definitions. This fixes up black idle drawings for eog (eye of gnome)
    and firefox (inkscape somehow could handle the broken case).

    Thomas
