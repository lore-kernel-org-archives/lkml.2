Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2LMSBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:01:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52321 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab2LMSBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:01:34 -0500
Message-ID: <50CA17FB.9060606@wwwdotorg.org>
Date: Thu, 13 Dec 2012 11:01:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: debug clock tree
References: <1355370586-6600-1-git-send-email-pgaikwad@nvidia.com> <CAPtuhThBigSQMkNDf16Fo1tddTKo=rPEydHmzep0DqtgLrB+HA@mail.gmail.com>
In-Reply-To: <CAPtuhThBigSQMkNDf16Fo1tddTKo=rPEydHmzep0DqtgLrB+HA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 09:27 AM, Mike Turquette wrote:
> On Wed, Dec 12, 2012 at 7:49 PM, Prashant Gaikwad <pgaikwad@nvidia.com> wrote:
>> Adds debug file "clock_tree" in /sys/kernel/debug/clk dir.
>> It helps to view all the clock registered in tree format.
>>
> 
> Prashant,
> 
> Thanks for submitting this.  We've been talking about having a single
> file for representing the tree for some time.
> 
> Regarding the output format had you considered using a well known
> format which can be parsed using well known parsing libs?  This avoids
> needing a custom parser just for this one file.  JSON springs to mind
> as something lightweight and well-understood.

One advantage of the format below is that it's very easily
human-readable, and it's not too hard to parse (although I guess you'd
have to parse the indent level to get parent/child relation, which would
suck a bit). Is there room to provide both? Otherwise, I guess the
kernel could include a script to convert from JSON/whatever into the
format below.

>> For example:
>>    clock                        enable_cnt  prepare_cnt  rate
>> ---------------------------------------------------------------------
>>  i2s0_sync                      0           0            24000000
>>  spdif_in_sync                  0           0            24000000
>>     spdif_mux                   0           0            24000000
>>        spdif                    0           0            24000000
>>           spdif_doubler         0           0            48000000
>>              spdif_div          0           0            48000000
>>                 spdif_2x        0           0            48000000


