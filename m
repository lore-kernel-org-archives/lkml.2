Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0JMJr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:47:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:43348 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0JMJr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 05:47:27 -0400
Message-ID: <4CB58020.6050707@kernel.org>
Date: Wed, 13 Oct 2010 11:47:12 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] firewire: core: use non-reentrant workqueue with
 rescuer
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de> <tkrat.5d99b60dc100a6d0@s5r6.in-berlin.de>
In-Reply-To: <tkrat.5d99b60dc100a6d0@s5r6.in-berlin.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Oct 2010 09:47:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/12/2010 11:29 PM, Stefan Richter wrote:
...
> fw_card.br_work instances should not, and instances of the others must
> not, be executed in parallel by multiple CPUs -- but were not protected
> against that.  Hence allocated a non-reentrant workqueue for them.
> 
> fw_device.work may be used in the memory reclaim path in case of SBP-2
> device updates.  Hence we need a workqueue with rescuer and cannot use
> system_nrt_wq.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Looks good to me.

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
