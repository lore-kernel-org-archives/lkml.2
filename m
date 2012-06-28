Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2F1IuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:50:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30666 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab2F1IuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:50:00 -0400
Message-ID: <4FEC1A43.7060309@oracle.com>
Date: Thu, 28 Jun 2012 16:48:03 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        joe.jin@oracle.com
Subject: Re: [V4]fix ocfs2 aio/dio writing process hang
References: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com> <20120628083454.GF18502@dhcp-172-17-9-228.mtv.corp.google.com>
In-Reply-To: <20120628083454.GF18502@dhcp-172-17-9-228.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 04:34 PM, Joel Becker wrote:
> Btw, do you want me to pull these through the ocfs2 tree, or are you
> sending them along yourself?
Please help pull these, great thanks.
>
> Joel
>
> On Wed, Jun 27, 2012 at 05:09:53PM +0800, Junxiao Bi wrote:
>> V4 changes:
>> add Acked-by: Joel Becker <jlbec@evilplan.org>
>>
>> V3 changes:
>> - add Cc: stable@vger.kernel.org in the patch header to align with stable rules
>> - add Acked-by: Jeff Moyer <jmoyer@redhat.com>
>>
>> V2 changes:
>> - update the patch header of the first patch to make it more clear.
>>
>>
>> This patch list fixes an issue about ocfs2 aio/dio write process hang.
>> The call trace is like this:
>> @  cat /proc/15913/stack
>> @ [<ffffffffa06e1085>] ocfs2_aiodio_wait+0x85/0xc0 [ocfs2]
>> @ [<ffffffffa06e3e39>] ocfs2_file_aio_write+0x99/0xa0 [ocfs2]
>> @ [<ffffffff811ace97>] aio_rw_vect_retry+0x87/0x150
>> @ [<ffffffff811aebd1>] aio_run_iocb+0x71/0x170
>> @ [<ffffffff811af59b>] io_submit_one+0x1ab/0x280
>> @ [<ffffffff811af77c>] do_io_submit+0x10c/0x1c0
>> @ [<ffffffff811af840>] sys_io_submit+0x10/0x20
>> @ [<ffffffff81509b42>] system_call_fastpath+0x16/0x1b
>> @ [<ffffffffffffffff>] 0xffffffffffffffff
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

