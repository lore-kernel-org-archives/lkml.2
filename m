Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0HYO10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 10:27:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:45817 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab0HYO1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 10:27:23 -0400
Message-ID: <4C752704.1030806@kernel.org>
Date: Wed, 25 Aug 2010 16:21:56 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: fix cwq->nr_active underflow
References: <4C74D9E4.5070403@kernel.org>	 <1282727501.3685.7.camel@jlt3.sipsolutions.net>	 <4C74DE62.6040208@kernel.org> <1282746326.3667.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1282746326.3667.8.camel@jlt3.sipsolutions.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 14:27:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 04:25 PM, Johannes Berg wrote:
> On Wed, 2010-08-25 at 11:12 +0200, Tejun Heo wrote:
> 
>> Yeap, without the fix patch applied, that should confirm that we're
>> seeing the same failure, and with the patch applied, you can add a
>> printk in the else part of !delayed check in cwq_dec_nr_in_flight().
>> If the printk triggers and later rmmod dosen't trigger BUG_ON(), we
>> can be fairly sure the problem is fixed.
> 
> Unfortunately, I haven't been able to trigger either code path today.
> I'll happily believe that this was the problem though, and will just let
> you know if I run into it again, I'm keeping the debug patch for now.
> It's certainly a valid fix regardless of whether I can reproduce the
> problem or not.

Thanks.  I'll push it to Linus tomorrow.

-- 
tejun
