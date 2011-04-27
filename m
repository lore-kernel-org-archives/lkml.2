Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1D0WMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:12:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34259 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1D0WMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:12:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6329"; a="88216452"
Message-ID: <4DB894C3.2040300@codeaurora.org>
Date: Wed, 27 Apr 2011 15:12:19 -0700
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Cernekee <cernekee@gmail.com>, mingo@elte.hu,
        akpm@linux-foundation.org, simon.kagstrom@netinsight.net,
        David.Woodhouse@intel.com, lethal@linux-sh.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Conny Seidel <conny.seidel@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: console_cpu_notify can cause scheduling BUG during CPU hotplug
References: <4DB604C7.8090305@codeaurora.org> <BANLkTimPHaiiiVC_A6jtUtaa_pYJuhepYg@mail.gmail.com> <4DB65EEC.7060604@ti.com> <4DB733D4.3000002@codeaurora.org> <20110427073839.GA16718@liondog.tnic>
In-Reply-To: <20110427073839.GA16718@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/2011 12:38 AM, Borislav Petkov wrote:
> Great, whatever you guys come up with, we'd like to give it a run too.
> We (AMD) hit the same issue in one of our tests but in our case we end
> up in an endless loop of the state machine at stop_machine_cpu_stop()
> since the core being offlined cannot ack the state transition to
> STOPMACHINE_EXIT due to a similar reason.
>
> One possible fix is dropping CPU_DYING from console_cpu_notify()
> since it is called into by the offlining path in
> kernel/cpu.c::take_cpu_down().

This seems to be a different problem. Could you elaborate about why 
removing CPU_DYING from console_cpu_notify resolves your problem? What 
are other possible fixes?

In the failure case I witnessed, we're attempting to sleep in atomic 
mode, which is a clear violation caused by the addition of CPU_DYING. I 
haven't thoroughly investigated whether other actions in 
console_cpu_notify (eg. ONLINE, DEAD, DOWN_FAILED, UP_CANCELED) are in 
atomic mode violation as well.

Thanks,
Mike

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
