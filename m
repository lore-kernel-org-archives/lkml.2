Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab1BBS7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:59:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:11240 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab1BBS7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:59:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,415,1291622400"; 
   d="scan'208";a="883711849"
Message-ID: <4D49A9A8.6030600@linux.intel.com>
Date: Wed, 02 Feb 2011 10:59:52 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: Andres Salomon <dilinger@queued.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        sodaville@linutronix.de
Subject: Re: [sodaville] [PATCH v2 01/15] x86/e820: remove conditional early
 mapping in parse_e820_ext
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>	<1292600033-12271-2-git-send-email-bigeasy@linutronix.de>	<20101230083745.GC11721@angua.secretlab.ca>	<20110104130839.GA21359@www.tglx.de>	<20110114081446.GC21832@angua.secretlab.ca>	<20110114105709.GA7562@www.tglx.de>	<20110114134345.712e2e29@queued.net> <AANLkTimyrGkqtjo99+aV+N4KcrC2_3PprpRD2tRo_NtC@mail.gmail.com>
In-Reply-To: <AANLkTimyrGkqtjo99+aV+N4KcrC2_3PprpRD2tRo_NtC@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 11:54 AM, Daniel Drake wrote:
> 
> This patch will indeed cause problems for OLPC. Thanks for bringing it
> to our attention.
> 
> On OLPC, the device tree is not used as a source of devices like on
> other platforms, it is simply used to present information to the
> kernel and userspace (in read-only fashion).
> 
> If I understand it correctly, the above patch is saying: if we have a
> device tree, don't add the standard x86 RTC device.
> 
> However, what we need it to say is: if we have a device tree *and* the
> device tree is being used as a source of devices, don't add the
> standard x86 RTC device.
> 
> Therefore in the OLPC case, this particular bail-out condition will
> never be met, because the device tree is not being used as a source of
> devices.
> 
> Does that make sense?
> 

It makes sense in the abstract, but it sounds like OLPC is a total WTF
in this sense...

	-hpa
