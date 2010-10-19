Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab0JSKCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:02:20 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54033 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138Ab0JSKCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:02:18 -0400
Message-ID: <4CBD6CAA.1060708@kernel.dk>
Date: Tue, 19 Oct 2010 12:02:18 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] blk: fix a wrong accounting of hd_struct->in_flight
References: <4CB40281.1020403@jp.fujitsu.com> <4CB41A27.5080001@kernel.dk> <4CB6FC1C.3050801@jp.fujitsu.com> <4CB6FDB7.5010501@kernel.dk> <4CB8135E.1030100@jp.fujitsu.com> <4CB82720.8040708@kernel.dk> <4CBC0524.7060804@jp.fujitsu.com> <4CBC06B2.7070107@kernel.dk> <4CBC3B3A.9040300@jp.fujitsu.com> <4CBC3BE2.2020802@kernel.dk> <4CBD00F7.3070503@jp.fujitsu.com>
In-Reply-To: <4CBD00F7.3070503@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-19 04:22, Yasuaki Ishimatsu wrote:
> Hi Jens,
> 
>> This version looks good, thanks for following through on this. What kind
>> of testing did you do?
> 
> I did three kinds of test.
> 
> 1. run a reproducer.
>    I confirmed the problem was fixed using attached the reproducer.
> 
> 2. remove and make a partition which is running I/O.
>    I confirmed the kernel panic or hungup did not occur using following steps.
> 
>      # dd if=/dev/sda of=null &
>      # while true
>      > do
>      > /sbin/parted /dev/sda rm 3 > /dev/null
>      > /sbin/parted /dev/sda mkpart primary ext2 42.5GB 52.5GB > /dev/null
>      > sleep 2
>      > done
> 
> 3. reload a partition which is running I/O.
>    I confirmed the kernel panic or hungup did not occur using following steps.
> 
>      # dd if=/dev/sda of=null &
>      # while true
>      > do
>      > /sbin/hdparm -z /dev/sda
>      > sleep 2
>      > done

Thanks, sounds good! I have queued it up for 2.6.37 and marked as a
stable backport candidate.

-- 
Jens Axboe

