Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2CEMod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:44:33 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:41502 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab2CEMoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:44:32 -0500
Date: Mon, 5 Mar 2012 13:44:11 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 4/4] EDAC: Convert AMD EDAC pieces to use RAS printk
 buffer
Message-ID: <20120305124411.GD1070@aftab>
References: <1330698314-9863-1-git-send-email-bp@amd64.org>
 <1330698314-9863-5-git-send-email-bp@amd64.org>
 <4F50DECB.8030200@redhat.com>
 <20120305110441.GC1070@aftab>
 <4F54A6FF.50502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F54A6FF.50502@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 08:43:59AM -0300, Mauro Carvalho Chehab wrote:
> It is still adding an amd64-specific code inside the core, as no other driver will
> use the amd64 "ras_agent".

Whoopie, we have another example that you're not really reading
my emails: ras_agent is _NOT_ amd64-specific but it is defined in
<arch/x86/ras/ras.c>

[..]

> If nobody objects, I'll add my changes to linux-next, as it was tested
> on most systems. I'll remove the MCE-specific tracepoint from my code,
> keeping the trace there for the other stuff.

As already pointed out, I object to the tracepoints you've defined for every
single edac_mc_handle_* call:

TRACE_EVENT(mc_corrected_error,
TRACE_EVENT(mc_uncorrected_error,
TRACE_EVENT(mc_corrected_error_fbd,
TRACE_EVENT(mc_uncorrected_error_fbd,
TRACE_EVENT(mc_out_of_range,
TRACE_EVENT(mc_corrected_error_no_info,
TRACE_EVENT(mc_uncorrected_error_no_info,

The edac drivers which get their error info from MCA should use
trace_mce_record() and the others should either use a _single_ generic
tracepoint or define one which adheres to the underlying hardware
reporting scheme (be it PCI-AER, or whatever).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
