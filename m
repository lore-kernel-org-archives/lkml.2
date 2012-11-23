Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2KWSAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 13:00:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35018 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2KWSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 13:00:20 -0500
Message-ID: <50AFB996.7040905@oracle.com>
Date: Fri, 23 Nov 2012 11:59:50 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Steven Whitehouse <swhiteho@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        cluster-devel@redhat.com
Subject: Re: [PATCH v4 27/31] gfs2: Convert aio_read/write ops to read/write_iter
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com> <1353537671-26284-28-git-send-email-dave.kleikamp@oracle.com> <1353577893.2757.14.camel@menhir> <20121122225926.GU2591@dastard>
In-Reply-To: <20121122225926.GU2591@dastard>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 04:59 PM, Dave Chinner wrote:
> On Thu, Nov 22, 2012 at 09:51:33AM +0000, Steven Whitehouse wrote:
>> Hi,
>>
>> On Wed, 2012-11-21 at 16:41 -0600, Dave Kleikamp wrote:
>>> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
>>> Cc: Steven Whitehouse <swhiteho@redhat.com>
>>> Cc: cluster-devel@redhat.com
>>> ---
>>>  fs/gfs2/file.c | 21 ++++++++++-----------
>>>  1 file changed, 10 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
>>> index e056b4c..bcea69e 100644
>>> --- a/fs/gfs2/file.c
>>> +++ b/fs/gfs2/file.c
>>> @@ -655,10 +655,9 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
>>>  }
>>>  
>>>  /**
>>> - * gfs2_file_aio_write - Perform a write to a file
>>> + * gfs2_file_write_iter - Perform a write to a file
>>>   * @iocb: The io context
>>> - * @iov: The data to write
>>> - * @nr_segs: Number of @iov segments
>>> + * @iter: The data to write
>>>   * @pos: The file position
>>>   *
>>>   * We have to do a lock/unlock here to refresh the inode size for
>>> @@ -668,11 +667,11 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
>>>   *
>>>   */
>>>  
>>> -static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>>> -				   unsigned long nr_segs, loff_t pos)
>>> +static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
>>> +				    loff_t pos)
>>>  {
>>>  	struct file *file = iocb->ki_filp;
>>> -	size_t writesize = iov_length(iov, nr_segs);
>>> +	size_t writesize = iov_iter_count(iter);
>> Hmm, I'm not sure that length isn't a better name than count for this
>> function. What we want is the total length of the i/o request and count
>> sounds to me as if it would refer to the number of segments. So could we
>> have a iov_iter_length() function instead perhaps?
> 
> I had exactly the same thought when looking at one of the XFS
> patches and was holding off commenting until I'd read the entire
> patch set. But, you've pointed out the same thing, so I figured I'd
> add my 2c here as well.

I agree with both of you. iov_iter_length() would be more consistent.

Shaggy
