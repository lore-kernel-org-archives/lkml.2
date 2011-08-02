Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab1HBUVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:21:46 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:59562 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab1HBUVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:21:40 -0400
Date: Tue, 02 Aug 2011 16:21:16 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, borislav.petkov@amd.com, davej@redhat.com,
        mark.langsdorf@amd.com, cpufreq@vger.kernel.org
Subject: Re: [PATCH 2/5] acpi-cpufreq: Add support for disabling dynamic
 overclocking
In-reply-to: <1305651819-25660-2-git-send-email-mjg@redhat.com>
Message-id: <alpine.LFD.2.02.1108021618190.25237@x980>
References: <1305651819-25660-1-git-send-email-mjg@redhat.com>
 <1305651819-25660-2-git-send-email-mjg@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While this patch will work and is not invalid, I don't like it.

It advertises a user I/F that suggests that disabling turbo
is on a per logical processor basis -- but a write to
any of the attributes will write to every CPU in the system.

Either it should do per-cpu limiting (which, btw doesn't
work if you use the MISC_ENABLES MSR method in this patch,
and would instead need to use the PERF_CTL.32 method)
or there should be a per-system attribute
that reflects that this knob is per-system.

thanks,
Len Brown, Intel Open Source Technology Center

