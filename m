Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab0JLQqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:46:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:36772 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252Ab0JLQqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:46:36 -0400
Message-ID: <4CB490DA.8020107@kernel.org>
Date: Tue, 12 Oct 2010 18:46:18 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: sbp2: parallelize login/inquiry, reconnect,
 and shutdown
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de> <tkrat.1433473bc081daa9@s5r6.in-berlin.de> <4CB3148C.5040902@kernel.org> <tkrat.1386de42b88d7218@s5r6.in-berlin.de> <tkrat.dd9197843f6a0a54@s5r6.in-berlin.de> <4CB468C1.8000004@kernel.org> <4CB489B7.2080808@s5r6.in-berlin.de>
In-Reply-To: <4CB489B7.2080808@s5r6.in-berlin.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 16:46:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/12/2010 06:15 PM, Stefan Richter wrote:
> Tejun Hejo wrote:
>> It doesn't have to be swap.  Having a rw filesystem mounted is enough
>> to be in the memory reclaim path.
> 
> Oh, alright.
> 
> ...
>> Yes, it would definitely be better to put them in a workqueue with
>> WQ_RESCUER (or the new WQ_MEM_RECLAIM).
> 
> A pro pos WQ_MEM_RECLAIM, is wq.git#for-next stable history which I can pull
> into a topic branch at linux1394-2.6.git?  (Or I wait with this stuff until
> after .37-rc1.)

For now using WQ_RESCUER should do.  We can update it to
WQ_MEM_RECLAIM after the trees are merged (both flags have the same
meaning now so nothing would break).

Thanks.

-- 
tejun
