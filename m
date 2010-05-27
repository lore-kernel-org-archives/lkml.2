Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab0E0RFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:05:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:39042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab0E0RFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:05:33 -0400
Message-ID: <4BFEA5CF.2070002@kernel.org>
Date: Thu, 27 May 2010 19:03:11 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: David Howells <dhowells@redhat.com>, davem@davemloft.net,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org, torvalds@osdl.org,
       viro@ZenIV.linux.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH] fs: run emergency remount on dedicated workqueue
References: <25328.1274886067@redhat.com> <4BFE4203.5010803@kernel.org> <20100527145807.GB3600@hack>
In-Reply-To: <20100527145807.GB3600@hack>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 May 2010 17:03:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 04:59 PM, Américo Wang wrote:
> On Thu, May 27, 2010 at 11:57:23AM +0200, Tejun Heo wrote:
>> Commit fa4b9074cd8428958c2adf9dc0c831f46e27c193 made s_umount depend
>> on keventd; however, emergency remount schedules works to keventd
>> which grabs s_umount creating a circular dependency.  Run emergency
>> remount on a separate workqueue to break it.
>>
> 
> I have a stupid question, why using workqueue instead of
> calling do_remount_sb() directly in emergency_remount()?
> Avoid blocking emergency_remount()?

Umm... because it's called from interrupt handler?  Right?

-- 
tejun
