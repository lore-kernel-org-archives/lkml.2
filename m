Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3AJOeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 09:34:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43351 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3AJOeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:34:20 -0500
Message-ID: <50EED160.9090102@oracle.com>
Date: Thu, 10 Jan 2013 08:34:08 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        cluster-devel@redhat.com
Subject: Re: [PATCH V5 26/30] gfs2: Convert aio_read/write ops to read/write_iter
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>  <1357761525-22718-27-git-send-email-dave.kleikamp@oracle.com> <1357812655.2760.9.camel@menhir>
In-Reply-To: <1357812655.2760.9.camel@menhir>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 04:10 AM, Steven Whitehouse wrote:
> Hi,
> 
> On Wed, 2013-01-09 at 13:58 -0600, Dave Kleikamp wrote:
>> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
>> Cc: Steven Whitehouse <swhiteho@redhat.com>
>> Cc: cluster-devel@redhat.com
>> ---
>>  fs/gfs2/file.c | 21 ++++++++++-----------
>>  1 file changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
>> index 991ab2d..63af1a6 100644
>> --- a/fs/gfs2/file.c
>> +++ b/fs/gfs2/file.c
>> @@ -655,10 +655,9 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
>>  }
>>  
>>  /**
>> - * gfs2_file_aio_write - Perform a write to a file
>> + * gfs2_file_write_iter - Perform a write to a file
>>   * @iocb: The io context
>> - * @iov: The data to write
>> - * @nr_segs: Number of @iov segments
>> + * @iter: The data to write
>>   * @pos: The file position
>>   *
>>   * We have to do a lock/unlock here to refresh the inode size for
>> @@ -668,11 +667,11 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
>>   *
>>   */
>>  
>> -static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>> -				   unsigned long nr_segs, loff_t pos)
>> +static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
>> +				    loff_t pos)
>>  {
>>  	struct file *file = iocb->ki_filp;
>> -	size_t writesize = iov_length(iov, nr_segs);
>> +	size_t writesize = iov_iter_count(iter);
> 
> Hmm, I had a vague memory that we'd agreed to call this iov_iter_length
> rather than iov_iter_count in order to keep the existing naming and to
> make it sound more like what it is (the length of the data) as opposed
> to the number of individual buffers to be written.

I had originally agreed, thinking it would be a better name, but then I
realized that iov_iter_count() has been defined that way since 2.6.24
and I didn't want to introduce any more change in this patchset than
necessary since it's already pretty extensive.

> Not that it is desperately important, but just to flag it up in case it
> got forgotten at some stage,
> 
> Steve.
> 
> 
