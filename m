Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2KLQfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:35:36 -0500
Received: from smtp129.dfw.emailsrvr.com ([67.192.241.129]:34107 "EHLO
	smtp129.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab2KLQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:35:34 -0500
Message-ID: <50A12565.4070701@calxeda.com>
Date: Mon, 12 Nov 2012 10:35:49 -0600
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [PATCH 3/6 v4] cpufreq: tolerate inexact values when collecting
 stats
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1352313166-28980-1-git-send-email-mark.langsdorf@calxeda.com> <1352313166-28980-4-git-send-email-mark.langsdorf@calxeda.com> <20121111163821.GA21635@x1.osrc.amd.com>
In-Reply-To: <20121111163821.GA21635@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 10:38 AM, Borislav Petkov wrote:
> On Wed, Nov 07, 2012 at 12:32:43PM -0600, Mark Langsdorf wrote:
>> When collecting stats, if a frequency doesn't match the table, go through
>> the table again with both the search frequency and table values shifted
>> left by 10 bits.
> 
> Why would that second pass succeed?

It's effectively a divide by 1024 and minimizes any jitter in the
measured frequency value.

> And why is this in generic code (I'm assuming this is a Calxeda-specific
> case)?

The function is buried pretty deep in the cpufreq_stat code. It didn't
seem appropriate to make it a function pointer as part of struct
cpufreq_driver.

--Mark Langsdorf
Calxeda, Inc.
