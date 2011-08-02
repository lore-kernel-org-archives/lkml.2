Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab1HBUuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:50:52 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57200 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab1HBUuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:50:46 -0400
Date: Tue, 2 Aug 2011 22:50:44 +0200
From: Borislav Petkov <bp@amd64.org>
To: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "Langsdorf, Mark" <mark.langsdorf@amd.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: Re: [PATCH 2/5] acpi-cpufreq: Add support for disabling dynamic
 overclocking
Message-ID: <20110802205044.GA21330@aftab>
References: <1305651819-25660-1-git-send-email-mjg@redhat.com>
 <1305651819-25660-2-git-send-email-mjg@redhat.com>
 <alpine.LFD.2.02.1108021618190.25237@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1108021618190.25237@x980>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 04:21:16PM -0400, Len Brown wrote:
> While this patch will work and is not invalid, I don't like it.
> 
> It advertises a user I/F that suggests that disabling turbo
> is on a per logical processor basis -- but a write to
> any of the attributes will write to every CPU in the system.
> 
> Either it should do per-cpu limiting (which, btw doesn't
> work if you use the MISC_ENABLES MSR method in this patch,
> and would instead need to use the PERF_CTL.32 method)
> or there should be a per-system attribute
> that reflects that this knob is per-system.

Agreed with the per-system thing. The reason to disable boosting on
all cores is very simple: nobody has come up with a usecase until now
which needs disabling only a subset of the cores. Also, this way the
implementation is the simplest.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
