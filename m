Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1DTPKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:10:21 -0400
Received: from mail1.nippynetworks.com ([91.220.24.129]:54419 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1DTPKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:10:20 -0400
Message-ID: <4DAEF75A.3080406@wildgooses.com>
Date: Wed, 20 Apr 2011 16:10:18 +0100
From: Ed W <lists@wildgooses.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Improved TSC calculation
References: <4DA6D85A.8000800@wildgooses.com> <1302805253.2673.17.camel@work-vm>
In-Reply-To: <1302805253.2673.17.camel@work-vm>
X-TagToolbar-Keys: D20110420161018193
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/2011 19:20, john stultz wrote:
> On Thu, 2011-04-14 at 12:19 +0100, Ed W wrote:

>> Before I try and hack probably an (inadequate) solution myself, do you
>> have any thoughts on the best solution to extend your commit to non
>> PM/HEPT machine?  My initial thought was to repeatedly call
>> pit_calibrate_tsc() with an extended latch, looking for a stable
>> solution (ie refactor native_calibrate_tsc() ).  Is this workable?
>> Better ideas?
> 
> Oof. So with the PIT you can maybe utilize the second channel/counter,
> using a largish long countdown to try to get a similar functionality.
> The only big concern is that the timer interrupt hardware is always
> problematic (every time we chanage our usage, some random chunk of
> laptops seem to stop working). So whatever solution that works for you
> might not be able to be generically deployed. But I think it could be
> interesting and might be worth you giving it a shot.
> 
> I'd probably look at reworking tsc_refine_calibration_work, extending
> the tsc_read_refs() code to also get PIT count values and then start the
> long PIT countdown on the second channel before we
> schedule_delayed_work.

OK, I have digested that and come to the conclusion that this might be a
little beyond what I can easily code up...  Any chance of some hints to
get started from those that know what they are doing here?

Cheers

Ed W
