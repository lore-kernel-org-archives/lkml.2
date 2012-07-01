Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2GAR2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 13:28:54 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40275 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab2GAR2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 13:28:53 -0400
Message-ID: <4FF088B9.1000308@us.ibm.com>
Date: Sun, 01 Jul 2012 10:28:25 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] Potential fix for leapsecond caused futex related
 load spikes
References: <4FF06CAB.9020800@redhat.com> <4FF08154.3050407@redhat.com>
In-Reply-To: <4FF08154.3050407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12070117-7282-0000-0000-00000A7A8681
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 09:56 AM, Prarit Bhargava wrote:
>
> John, the issue is that clock_was_set calls on_each_cpu() -- which cannot be
> called from interrupt context as it calls smp_call_function_many().
>
> I don't think you can call call_was_set() from update_wall_time() as
> update_wall_time() is called in interrupt context.
>

Thanks for pointing this out.  Ben Blum also mentioned this last night, 
but I missed the atomic bit instead of the xtime_lock issue.

Reworking the patch now.

thanks again
-john

