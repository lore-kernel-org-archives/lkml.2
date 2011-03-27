Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab1C0WZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 18:25:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58662 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1C0WZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 18:25:04 -0400
Message-ID: <4D8FB93A.6020508@linux.vnet.ibm.com>
Date: Sun, 27 Mar 2011 15:24:58 -0700
From: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
CC: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 3/5] 9p: revert tsyncfs related changes
References: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1301052651-21440-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4D8D0704.7080106@linux.vnet.ibm.com> <877hbl0xxq.fsf@linux.vnet.ibm.com>
In-Reply-To: <877hbl0xxq.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2011 01:28 AM, Aneesh Kumar K. V wrote:
> On Fri, 25 Mar 2011 14:20:04 -0700, Venkateswararao Jujjuri<jvrao@linux.vnet.ibm.com>  wrote:
>> On 03/25/2011 04:30 AM, Aneesh Kumar K.V wrote:
>>> Now that we use write_inode to flush server
>>> cache related to fid, we don't need tsyncfs.
>>> This help us to do a more efficient server flush
>>> for dotu protocol
>> Why are you singling out dotu only? won't it be applicable to dotl too?
>>
> With dotl we can have new operations and so we added tsyncfs. The
> primary goal is to add an operation that can flush server cache. We
> hooked that to sync(2) on the client. With dotu we cannot add new
> operations so we always forced the write on the server in case of dotu
> to O_SYNC. That is much slower than doing an fsync on write_inode. But
> whether doing an fsync on write inode is better than doing tsyncfs on
> sync(2) on client is something i haven't yet measured. Stefan Hajnoczi wants to
> see some numbers before we push tsyncfs in the server(qemu). We also don't
> want a kernel release with 9p operation which we may remove later. So
> the plan now is to get write_inode changes upstream in this merge window
> and later get numbers against tsyncfs/write_inode ->  fsync and add tsyncfs only
> if we see a benefit. BTW NFS use the write_inode approach.

Nice explanation. I looked at NFS and realized that they also follow 
write_inode approach.
So I think you should make it explict that this will be helpful to dotl 
also and may and TFSYNCFS
in the future if needed. With that I ack this.

Reviewed-by : Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>

> -aneesh

