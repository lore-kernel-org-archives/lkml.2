Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab0INHjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:39:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:40530 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab0INHjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:39:11 -0400
Message-ID: <4C8F2699.3020509@kernel.org>
Date: Tue, 14 Sep 2010 09:39:05 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
References: <1284284969.2928.18.camel@maxim-laptop> <1284427621.4127.7.camel@maxim-laptop>
In-Reply-To: <1284427621.4127.7.camel@maxim-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Sep 2010 07:39:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/14/2010 03:27 AM, Maxim Levitsky wrote:
>> However 2.6.36 doesn't detect that removal.
>> According to udevadm monitor --property no uevents are send on removal.
> Correction, this is regression between 2.6.34 and 2.6.35. This shows how
> much I use cd these days...
> 
> I bisected it down to this:
> 
> 6b4517a7913a09d3259bb1d21c9cb300f12294bd is the first bad commit
> commit 6b4517a7913a09d3259bb1d21c9cb300f12294bd
> Author: Tejun Heo <tj@kernel.org>
> Date:   Wed Apr 7 18:53:59 2010 +0900
> 
>     block: implement bd_claiming and claiming block

Hmmm... weird.  This commit does change the open behavior but
shouldn't change the end result.  Can someone please enlighten me how
udevadm is interacting with the device at system call level?

Thanks.

-- 
tejun
