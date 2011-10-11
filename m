Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1JKHdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:33:22 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47527 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1JKHdV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 11 Oct 2011 03:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <4E940B99020000780005AA12@victor.provo.novell.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
	<1318260494-27985-3-git-send-email-konrad.wilk@oracle.com>
	<4E940B99020000780005AA12@victor.provo.novell.com>
Date: Tue, 11 Oct 2011 15:33:11 +0800
Message-ID: <CAKH3R4-HJZBE-yWk=Dwkuwy13z1vdUrgEoJ9zFhTJgXgYfHHfA@mail.gmail.com>
Subject: Re: [PATCH 2/3] xen/blkback: Fix the inhibition to map pages when
 discarding sector ranges.
From: Li Dongyang <lidongyang@novell.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dong Yang Li <lidongyang@suse.com>, hch@infradead.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 3:25 PM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 10.10.11 at 17:28, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> The 'operation' parameters are the ones provided to the bio layer while
>> the req->operation are the ones passed in between the backend and
>> frontend. We used the wrong 'operation' value to squash the
>> call to map pages when processing the discard operation resulting
>> in mapping the pages unnecessarily.
>>
>> CC: Li Dongyang <lidongyang@novell.com>
>> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> ---
>>  drivers/block/xen-blkback/blkback.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/block/xen-blkback/blkback.c
>> b/drivers/block/xen-blkback/blkback.c
>> index 184b133..3da9a40 100644
>> --- a/drivers/block/xen-blkback/blkback.c
>> +++ b/drivers/block/xen-blkback/blkback.c
>> @@ -707,7 +707,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>>        * the hypercall to unmap the grants - that is all done in
>>        * xen_blkbk_unmap.
>>        */
>> -     if (operation != BLKIF_OP_DISCARD &&
>> +     if (operation != REQ_DISCARD &&
>
> Why is that check necessary in the first place? xen_blkbk_map() doesn't
> do any harm when req->nr_segments is zero (as could also be the case
> on WRITE_FLUSH ones).
>
Ah, you are right, we could remove this check then, Thanks
> Jan
>
>>                       xen_blkbk_map(req, pending_req, seg))
>>               goto fail_flush;
>>
>
>
>
>
