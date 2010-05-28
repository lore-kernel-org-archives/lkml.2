Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0E1GnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:43:14 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:53240 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab0E1GnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:43:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=SVwD+M/gYrBceg2dc8NKh3giaRRisNke4RcULU9Jdk61ODu3azlDa3rVD/YXhdLmqC
         0rP+H2igTr4wvbq7syCt87Po3Cg0m1J2epbjzyXjLBHsqeQrC5flK4opjKVfOoiCbmOt
         F1Un2C3a3W7kA8P4R1ObU6oALo81lQR0fTaE0=
Date: Fri, 28 May 2010 14:46:59 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       David Howells <dhowells@redhat.com>, davem@davemloft.net,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org, torvalds@osdl.org,
       viro@ZenIV.linux.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH] fs: run emergency remount on dedicated workqueue
Message-ID: <20100528064659.GI5257@cr0.nay.redhat.com>
References: <25328.1274886067@redhat.com>
 <4BFE4203.5010803@kernel.org>
 <20100527145807.GB3600@hack>
 <4BFEA5CF.2070002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BFEA5CF.2070002@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:03:11PM +0200, Tejun Heo wrote:
>On 05/27/2010 04:59 PM, Américo Wang wrote:
>> On Thu, May 27, 2010 at 11:57:23AM +0200, Tejun Heo wrote:
>>> Commit fa4b9074cd8428958c2adf9dc0c831f46e27c193 made s_umount depend
>>> on keventd; however, emergency remount schedules works to keventd
>>> which grabs s_umount creating a circular dependency.  Run emergency
>>> remount on a separate workqueue to break it.
>>>
>> 
>> I have a stupid question, why using workqueue instead of
>> calling do_remount_sb() directly in emergency_remount()?
>> Avoid blocking emergency_remount()?
>
>Umm... because it's called from interrupt handler?  Right?

Ah, this is true, sysrq can be both triggered by keyboard and
/proc/sysrq-trigger.

Thanks!
