Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0DBSzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:55:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57149 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab0DBSzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:55:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=fQKqlYw1l6q6LVcfotHPUxP8M99asdyGyOI0TW7X0fLBAXnZU5nUnt1eFtoI829mh
	b3vN+yhDMeiqZ+fiy3X3w==
MIME-Version: 1.0
In-Reply-To: <20100402181754.GC3516@redhat.com>
References: <20100401215541.2843.79107.stgit@austin.mtv.corp.google.com> 
	<20100401220109.2843.36040.stgit@austin.mtv.corp.google.com> 
	<20100402181754.GC3516@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Fri, 2 Apr 2010 11:54:50 -0700
Message-ID: <w2naf41c7c41004021154qeb061645u9a0a0b074f90252b@mail.gmail.com>
Subject: Re: [PATCH 2/3] blkio: Add io controller stats like
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 2, 2010 at 11:17 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Apr 01, 2010 at 03:01:24PM -0700, Divyesh Shah wrote:
>
> [..]
>> +#define GET_STAT(__VAR, __CONV)                                              \
>> +uint64_t get_##__VAR##_stat(struct blkio_group *blkg, int dummy)     \
>> +{                                                                    \
>> +     uint64_t data = blkg->stats.__VAR;                              \
>> +     if (__CONV)                                                     \
>> +             data = (uint64_t)jiffies_to_msecs(data) * NSEC_PER_MSEC;\
>> +     return data;                                                    \
>> +}
>> +
>
> Hi Divyesh,
>
> I think now you are exporting blkio.time in ns instead of ms?

This is an error.. I should be exporting this in ms. Will send out a
patchset with the change once I also address you other comments in a
bit. Thanks for the review!

> - First of all your are breaking ABI.
> - Secondly, how does that help. You are capturing all your slice used
>  stats in ms. You already lost any ns granularity. What's the point
>  in converting these to ns now?
> - Does user space software really need that fine grained accounting. If
>  this information is used for charging purposes, isn't ms good enough.
>
> Thanks
> Vivek
>
