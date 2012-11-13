Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2KMQdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:33:33 -0500
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:59148 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab2KMQdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:33:31 -0500
Message-ID: <50A2766D.6040008@calxeda.com>
Date: Tue, 13 Nov 2012 10:33:49 -0600
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
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1352313166-28980-1-git-send-email-mark.langsdorf@calxeda.com> <1352313166-28980-4-git-send-email-mark.langsdorf@calxeda.com> <20121111163821.GA21635@x1.osrc.amd.com> <50A12565.4070701@calxeda.com> <20121113162449.GE9327@x1.osrc.amd.com>
In-Reply-To: <20121113162449.GE9327@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 10:24 AM, Borislav Petkov wrote:
> On Mon, Nov 12, 2012 at 10:35:49AM -0600, Mark Langsdorf wrote:
>> The function is buried pretty deep in the cpufreq_stat code. It didn't
>> seem appropriate to make it a function pointer as part of struct
>> cpufreq_driver.
> 
> Right, what's cpufreq-speak for
> 
> 	if (Calxeda)
> 		shift by 10
> 
> ?
> 
> Better yet, add a flag or a bitfield called "minimize_jitter" or similar
> and set it only on your hardware...

Doing it in two passes has a similar effect: systems that have exact
frequencies will get caught in the first pass when the values match. But
adding a flag makes sense.

--Mark Langsdorf
Calxeda, Inc.

