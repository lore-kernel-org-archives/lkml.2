Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab2J1UsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:48:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54029 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab2J1UsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:48:14 -0400
Message-ID: <508D9A08.3030506@ti.com>
Date: Sun, 28 Oct 2012 13:48:08 -0700
From: Tom Rini <trini@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur> <d556fc0f-da5d-4531-b331-6dc086461f34@blur> <50833F30.4020802@ti.com> <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com> <20121021041858.GA14809@jshin-Toonie> <50843627.4020103@ti.com> <20121021210633.GA14311@jshin-Toonie> <508467EE.4040807@ti.com> <20121022144020.GA14425@jshin-Toonie>
In-Reply-To: <20121022144020.GA14425@jshin-Toonie>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/12 07:40, Jacob Shin wrote:
> On Sun, Oct 21, 2012 at 02:23:58PM -0700, Tom Rini wrote:
>> On 10/21/12 14:06, Jacob Shin wrote:
>>> Ah, sorry, this one should apply on top of 3.7-rc2:
>>>
>>> https://lkml.org/lkml/2012/8/24/469
>>>
>>> Could you try that? Just that single patch, not the whole patchset.
>>
>> That fixes it, replied with a note and Tested-by, thanks!
> 
> Thanks for testing!
> 
> hpa, so sorry, but it looks like we need one more patch [PATCH 2/5] x86:
> find_early_table_space based on memory ranges that are being mapped:
> 
>   https://lkml.org/lkml/2012/8/24/469
> 
> on top of this, because find_early_table_space calculation does not come out
> correctly for this particular E820 table that Tom has:
> 
>   http://pastebin.com/4eSPEAvB
> 
> The reason why we hit this now, and never hit it before is because before the
> start was hard coded to 1UL<<32.

As a final follow-up, v3.7-rc3 does not have the problem I reported
previously.

-- 
Tom

