Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0CVSSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:18:10 -0400
Received: from xenotime.net ([72.52.64.118]:40393 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751420Ab0CVSSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:18:08 -0400
Message-ID: <4BA7B45D.2050102@xenotime.net>
Date: Mon, 22 Mar 2010 11:18:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: William Cohen <wcohen@redhat.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Add DocBook documentation for the block tracepoints.
References: <1267811199-29812-1-git-send-email-wcohen@redhat.com> <4B932672.3010309@xenotime.net> <4B952AC1.1030601@redhat.com> <4B95A1CD.2050401@xenotime.net> <4BA7B352.90301@redhat.com>
In-Reply-To: <4BA7B352.90301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/10 11:13, William Cohen wrote:
> On 03/08/2010 08:18 PM, Randy Dunlap wrote:
>> On 03/08/10 08:50, William Cohen wrote:
>>> On 03/06/2010 11:07 PM, Randy Dunlap wrote:
>>>> William Cohen wrote:
>>>>> This patch adds a simple description of the various block tracepoints
>>>>> available in the kernel.
>>>>>
>>>>> Signed-off-by: William Cohen <wcohen@redhat.com>
>>>>
>>>> Thanks.  I have just a few nits below then it will be ready IMO.
>>>
>>> I have gone through the patch and made the changes. Below is the updated patch
>>>
>>> -Will
>>>
>>>
>>> Signed-off-by: William Cohen <wcohen@redhat.com>
>>
>> Thanks, looks good.  I'll merge it or get Jens to merge it.
> 
> Hi Randy,
> 
> Which git repository is this going into? I didn't see it in any of the git repositories I looked at.

Hi Will,

Jens told me that he would merge it.  Jens??


> -Will
> 
>>
>>> ---
>>>  Documentation/DocBook/tracepoint.tmpl |   13 +++
>>>  include/trace/events/block.h          |  164 +++++++++++++++++++++++++++++++++
>>>  2 files changed, 177 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/Documentation/DocBook/tracepoint.tmpl b/Documentation/DocBook/tracepoint.tmpl
>>> index 8bca1d5..e8473ea 100644
>>> --- a/Documentation/DocBook/tracepoint.tmpl
>>> +++ b/Documentation/DocBook/tracepoint.tmpl
>>> @@ -16,6 +16,15 @@
>>>       </address>
>>>      </affiliation>
>>>     </author>
>>> +   <author>
>>> +    <firstname>William</firstname>
>>> +    <surname>Cohen</surname>
>>> +    <affiliation>
>>> +     <address>
>>> +      <email>wcohen@redhat.com</email>
>>> +     </address>
>>> +    </affiliation>
>>> +   </author>
>>>    </authorgroup>
>>>  
>>>    <legalnotice>
>>> @@ -91,4 +100,8 @@
>>>  !Iinclude/trace/events/signal.h
>>>    </chapter>
>>>  
>>> +  <chapter id="block">
>>> +   <title>Block IO</title>
>>> +!Iinclude/trace/events/block.h
>>> +  </chapter>
>>>  </book>
>>> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
>>> index 5fb7273..6bb1181 100644
>>> --- a/include/trace/events/block.h
>>> +++ b/include/trace/events/block.h
>>> @@ -40,6 +40,16 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
>>>  		  __entry->nr_sector, __entry->errors)
>>>  );
>>>  
>>> +/**
>>> + * block_rq_abort - abort block operation request
>>> + * @q: queue containing the block operation request
>>> + * @rq: block IO operation request
>>> + *
>>> + * Called immediately after pending block IO operation request @rq in
>>> + * queue @q is aborted. The fields in the operation request @rq
>>> + * can be examined to determine which device and sectors the pending
>>> + * operation would access.
>>> + */
>>>  DEFINE_EVENT(block_rq_with_error, block_rq_abort,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct request *rq),
>>> @@ -47,6 +57,15 @@ DEFINE_EVENT(block_rq_with_error, block_rq_abort,
>>>  	TP_ARGS(q, rq)
>>>  );
>>>  
>>> +/**
>>> + * block_rq_requeue - place block IO request back on a queue
>>> + * @q: queue holding operation
>>> + * @rq: block IO operation request
>>> + *
>>> + * The block operation request @rq is being placed back into queue
>>> + * @q.  For some reason the request was not completed and needs to be
>>> + * put back in the queue.
>>> + */
>>>  DEFINE_EVENT(block_rq_with_error, block_rq_requeue,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct request *rq),
>>> @@ -54,6 +73,17 @@ DEFINE_EVENT(block_rq_with_error, block_rq_requeue,
>>>  	TP_ARGS(q, rq)
>>>  );
>>>  
>>> +/**
>>> + * block_rq_complete - block IO operation completed by device driver
>>> + * @q: queue containing the block operation request
>>> + * @rq: block operations request
>>> + *
>>> + * The block_rq_complete tracepoint event indicates that some portion
>>> + * of operation request has been completed by the device driver.  If
>>> + * the @rq->bio is %NULL, then there is absolutely no additional work to
>>> + * do for the request. If @rq->bio is non-NULL then there is
>>> + * additional work required to complete the request.
>>> + */
>>>  DEFINE_EVENT(block_rq_with_error, block_rq_complete,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct request *rq),
>>> @@ -95,6 +125,16 @@ DECLARE_EVENT_CLASS(block_rq,
>>>  		  __entry->nr_sector, __entry->comm)
>>>  );
>>>  
>>> +/**
>>> + * block_rq_insert - insert block operation request into queue
>>> + * @q: target queue
>>> + * @rq: block IO operation request
>>> + *
>>> + * Called immediately before block operation request @rq is inserted
>>> + * into queue @q.  The fields in the operation request @rq struct can
>>> + * be examined to determine which device and sectors the pending
>>> + * operation would access.
>>> + */
>>>  DEFINE_EVENT(block_rq, block_rq_insert,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct request *rq),
>>> @@ -102,6 +142,14 @@ DEFINE_EVENT(block_rq, block_rq_insert,
>>>  	TP_ARGS(q, rq)
>>>  );
>>>  
>>> +/**
>>> + * block_rq_issue - issue pending block IO request operation to device driver
>>> + * @q: queue holding operation
>>> + * @rq: block IO operation operation request
>>> + *
>>> + * Called when block operation request @rq from queue @q is sent to a
>>> + * device driver for processing.
>>> + */
>>>  DEFINE_EVENT(block_rq, block_rq_issue,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct request *rq),
>>> @@ -109,6 +157,17 @@ DEFINE_EVENT(block_rq, block_rq_issue,
>>>  	TP_ARGS(q, rq)
>>>  );
>>>  
>>> +/**
>>> + * block_bio_bounce - used bounce buffer when processing block operation
>>> + * @q: queue holding the block operation
>>> + * @bio: block operation
>>> + *
>>> + * A bounce buffer was used to handle the block operation @bio in @q.
>>> + * This occurs when hardware limitations prevent a direct transfer of
>>> + * data between the @bio data memory area and the IO device.  Use of a
>>> + * bounce buffer requires extra copying of data and decreases
>>> + * performance.
>>> + */
>>>  TRACE_EVENT(block_bio_bounce,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct bio *bio),
>>> @@ -138,6 +197,14 @@ TRACE_EVENT(block_bio_bounce,
>>>  		  __entry->nr_sector, __entry->comm)
>>>  );
>>>  
>>> +/**
>>> + * block_bio_complete - completed all work on the block operation
>>> + * @q: queue holding the block operation
>>> + * @bio: block operation completed
>>> + *
>>> + * This tracepoint indicates there is no further work to do on this
>>> + * block IO operation @bio.
>>> + */
>>>  TRACE_EVENT(block_bio_complete,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct bio *bio),
>>> @@ -193,6 +260,14 @@ DECLARE_EVENT_CLASS(block_bio,
>>>  		  __entry->nr_sector, __entry->comm)
>>>  );
>>>  
>>> +/**
>>> + * block_bio_backmerge - merging block operation to the end of an existing operation
>>> + * @q: queue holding operation
>>> + * @bio: new block operation to merge
>>> + *
>>> + * Merging block request @bio to the end of an existing block request
>>> + * in queue @q.
>>> + */
>>>  DEFINE_EVENT(block_bio, block_bio_backmerge,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct bio *bio),
>>> @@ -200,6 +275,14 @@ DEFINE_EVENT(block_bio, block_bio_backmerge,
>>>  	TP_ARGS(q, bio)
>>>  );
>>>  
>>> +/**
>>> + * block_bio_frontmerge - merging block operation to the beginning of an existing operation
>>> + * @q: queue holding operation
>>> + * @bio: new block operation to merge
>>> + *
>>> + * Merging block IO operation @bio to the beginning of an existing block
>>> + * operation in queue @q.
>>> + */
>>>  DEFINE_EVENT(block_bio, block_bio_frontmerge,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct bio *bio),
>>> @@ -207,6 +290,13 @@ DEFINE_EVENT(block_bio, block_bio_frontmerge,
>>>  	TP_ARGS(q, bio)
>>>  );
>>>  
>>> +/**
>>> + * block_bio_queue - putting new block IO operation in queue
>>> + * @q: queue holding operation
>>> + * @bio: new block operation
>>> + *
>>> + * About to place the block IO operation @bio into queue @q.
>>> + */
>>>  DEFINE_EVENT(block_bio, block_bio_queue,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct bio *bio),
>>> @@ -243,6 +333,15 @@ DECLARE_EVENT_CLASS(block_get_rq,
>>>  		  __entry->nr_sector, __entry->comm)
>>>  );
>>>  
>>> +/**
>>> + * block_getrq - get a free request entry in queue for block IO operations
>>> + * @q: queue for operations
>>> + * @bio: pending block IO operation
>>> + * @rw: low bit indicates a read (%0) or a write (%1)
>>> + *
>>> + * A request struct for queue @q has been allocated to handle the
>>> + * block IO operation @bio.
>>> + */
>>>  DEFINE_EVENT(block_get_rq, block_getrq,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
>>> @@ -250,6 +349,17 @@ DEFINE_EVENT(block_get_rq, block_getrq,
>>>  	TP_ARGS(q, bio, rw)
>>>  );
>>>  
>>> +/**
>>> + * block_sleeprq - waiting to get a free request entry in queue for block IO operation
>>> + * @q: queue for operation
>>> + * @bio: pending block IO operation
>>> + * @rw: low bit indicates a read (%0) or a write (%1)
>>> + *
>>> + * In the case where a request struct cannot be provided for queue @q
>>> + * the process needs to wait for an request struct to become
>>> + * available.  This tracepoint event is generated each time the
>>> + * process goes to sleep waiting for request struct become available.
>>> + */
>>>  DEFINE_EVENT(block_get_rq, block_sleeprq,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
>>> @@ -257,6 +367,14 @@ DEFINE_EVENT(block_get_rq, block_sleeprq,
>>>  	TP_ARGS(q, bio, rw)
>>>  );
>>>  
>>> +/**
>>> + * block_plug - keep operations requests in request queue
>>> + * @q: request queue to plug
>>> + *
>>> + * Plug the request queue @q.  Do not allow block operation requests
>>> + * to be sent to the device driver. Instead, accumulate requests in
>>> + * the queue to improve throughput performance of the block device.
>>> + */
>>>  TRACE_EVENT(block_plug,
>>>  
>>>  	TP_PROTO(struct request_queue *q),
>>> @@ -293,6 +411,13 @@ DECLARE_EVENT_CLASS(block_unplug,
>>>  	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
>>>  );
>>>  
>>> +/**
>>> + * block_unplug_timer - timed release of operations requests in queue to device driver
>>> + * @q: request queue to unplug
>>> + *
>>> + * Unplug the request queue @q because a timer expired and allow block
>>> + * operation requests to be sent to the device driver.
>>> + */
>>>  DEFINE_EVENT(block_unplug, block_unplug_timer,
>>>  
>>>  	TP_PROTO(struct request_queue *q),
>>> @@ -300,6 +425,13 @@ DEFINE_EVENT(block_unplug, block_unplug_timer,
>>>  	TP_ARGS(q)
>>>  );
>>>  
>>> +/**
>>> + * block_unplug_io - release of operations requests in request queue
>>> + * @q: request queue to unplug
>>> + *
>>> + * Unplug request queue @q because device driver is scheduled to work
>>> + * on elements in the request queue.
>>> + */
>>>  DEFINE_EVENT(block_unplug, block_unplug_io,
>>>  
>>>  	TP_PROTO(struct request_queue *q),
>>> @@ -307,6 +439,17 @@ DEFINE_EVENT(block_unplug, block_unplug_io,
>>>  	TP_ARGS(q)
>>>  );
>>>  
>>> +/**
>>> + * block_split - split a single bio struct into two bio structs
>>> + * @q: queue containing the bio
>>> + * @bio: block operation being split
>>> + * @new_sector: The starting sector for the new bio
>>> + *
>>> + * The bio request @bio in request queue @q needs to be split into two
>>> + * bio requests. The newly created @bio request starts at
>>> + * @new_sector. This split may be required due to hardware limitation
>>> + * such as operation crossing device boundaries in a RAID system.
>>> + */
>>>  TRACE_EVENT(block_split,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct bio *bio,
>>> @@ -337,6 +480,16 @@ TRACE_EVENT(block_split,
>>>  		  __entry->comm)
>>>  );
>>>  
>>> +/**
>>> + * block_remap - map request for a partition to the raw device
>>> + * @q: queue holding the operation
>>> + * @bio: revised operation
>>> + * @dev: device for the operation
>>> + * @from: original sector for the operation
>>> + *
>>> + * An operation for a partition on a block device has been mapped to the
>>> + * raw block device.
>>> + */
>>>  TRACE_EVENT(block_remap,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
>>> @@ -370,6 +523,17 @@ TRACE_EVENT(block_remap,
>>>  		  (unsigned long long)__entry->old_sector)
>>>  );
>>>  
>>> +/**
>>> + * block_rq_remap - map request for a block operation request
>>> + * @q: queue holding the operation
>>> + * @rq: block IO operation request
>>> + * @dev: device for the operation
>>> + * @from: original sector for the operation
>>> + *
>>> + * The block operation request @rq in @q has been remapped.  The block
>>> + * operation request @rq holds the current information and @from hold
>>> + * the original sector.
>>> + */
>>>  TRACE_EVENT(block_rq_remap,
>>>  
>>>  	TP_PROTO(struct request_queue *q, struct request *rq, dev_t dev,


-- 
~Randy
