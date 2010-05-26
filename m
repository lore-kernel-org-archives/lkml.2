Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0EZPd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:33:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab0EZPdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:33:24 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       jens.axboe@oracle.com, vgoyal@redhat.com
Subject: Re: [PATCH 0/4 v4] ext3/4: enhance fsync performance when using CFQ
References: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
	<20100519105706.8821.A69D9226@jp.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 26 May 2010 11:33:17 -0400
In-Reply-To: <20100519105706.8821.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's
	message of "Wed, 19 May 2010 11:05:20 +0900 (JST)")
Message-ID: <x49sk5ebruq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

> Hi Jeff,
>
>> This patch series addresses a performance problem experienced when running
>> io_zone with small file sizes (from 4KB up to 8MB) and including fsync in
>> the timings.  A good example of this would be the following command line:
>>   iozone -s 64 -e -f /mnt/test/iozone.0 -i 0
>> As the file sizes get larger, the performance improves.  By the time the
>> file size is 16MB, there is no difference in performance between runs
>> using CFQ and runs using deadline.  The storage in my testing was a NetApp
>> array connected via a single fibre channel link.  When testing against a
>> single SATA disk, the performance difference is not apparent.
>
> offtopic:
>
> Can this patch help to reduce a pain of following much small files issue?
>
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=578635

Perhaps.  I don't have a debian system handy to test that, though.

Cheers,
Jeff
