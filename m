Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab1FXM0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:26:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:57748 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab1FXM0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:26:17 -0400
Message-ID: <4E04825A.2000805@windriver.com>
Date: Fri, 24 Jun 2011 08:26:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: <stable@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable-review@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [34-longterm 029/247] iwlagn: enable only rfkill interrupt when
 device is down
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com> <1308849690-14530-30-git-send-email-paul.gortmaker@windriver.com> <20110624081649.GA2190@redhat.com>
In-Reply-To: <20110624081649.GA2190@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-24 04:16 AM, Stanislaw Gruszka wrote:
> On Thu, Jun 23, 2011 at 01:17:52PM -0400, Paul Gortmaker wrote:
>> From: Stanislaw Gruszka <sgruszka@redhat.com>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit 554d1d027b19265c4aa3f718b3126d2b86e09a08 upstream.
>>
>> Since commit 6cd0b1cb872b3bf9fc5de4536404206ab74bafdd "iwlagn: fix
>> hw-rfkill while the interface is down", we enable interrupts when
>> device is not ready to receive them. However hardware, when it is in
>> some inconsistent state, can generate other than rfkill interrupts
>> and crash the system. I can reproduce crash with "kernel BUG at
>> drivers/net/wireless/iwlwifi/iwl-agn.c:1010!" message, when forcing
>> firmware restarts.
>>
>> To fix only enable rfkill interrupt when down device and after probe.
>> I checked patch on laptop with 5100 device, rfkill change is still
>> passed to user space when device is down.
> 
> This needs follow up:
> 
> commit 3dd823e6b86407aed1a025041d8f1df77e43a9c8
> Author: Don Fry <donald.h.fry@intel.com>
> Date:   Sun Feb 6 09:29:45 2011 -0800
> 
>     iwlagn: Re-enable RF_KILL interrupt when down
> 
> I'm not sure if that commit is included in the patch series.
> 
> Stanislaw

Thanks for the review; the 3dd823e commit was already in the
series (sent as 049/247) fortunately.

Paul.
