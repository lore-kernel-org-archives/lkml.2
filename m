Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2LDAkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 19:40:37 -0500
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:38928 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab2LDAkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 19:40:36 -0500
Message-ID: <50BD4680.7090103@akamai.com>
Date: Mon, 03 Dec 2012 18:40:32 -0600
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Restore /proc/partitions to not display non-partitionable
 removable devices
References: <1353380209-23799-1-git-send-email-johunt@akamai.com> <20121203160647.11ad34d8.akpm@linux-foundation.org>
In-Reply-To: <20121203160647.11ad34d8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 06:06 PM, Andrew Morton wrote:
> On Mon, 19 Nov 2012 18:56:49 -0800
> Josh Hunt <johunt@akamai.com> wrote:
>
>> We found with newer kernels we started seeing the cdrom device showing
>> up in /proc/partitions, but it was not there before. Looking into this I found
>> that commit d27769ec... block: add GENHD_FL_NO_PART_SCAN introduces this change
>> in behavior. It's not clear to me from the commit's changelog if this change was
>> intentional or not. This comment still remains:
>> /* Don't show non-partitionable removeable devices or empty devices */
>> so I've decided to send a patch to restore the behavior of not printing
>> unpartitionable removable devices.
>
> d27769ec was merged in August 2011, so I after all this time, your fix
> could be viewed as "changing existing behaviour".
>
> So perhaps it would be best to leave things alone.  Is there any
> particular problem with the post-Aug, 2011 behaviour?
>

We caught this by a script that parses /proc/partitions and made some 
assumptions about the contents therein. It had worked fine up until when 
this behavior changed. We were able to modify our script to get what we 
needed.

The patch was meant to do two things: 1) understand if this was an 
unintended change and 2) if so, propose a solution to resolve it. Since 
the comment was left in the source I believe either a) my patch should 
be applied or b) a new patch with the comment removed should be put in 
since it's no longer correct. I did not think this type of change to 
kernel abi was generally acceptable.

While the commit is over a year old, it changes behavior which had been 
in tact for a while (years?) from what I can tell. We were running 3.0 
with stable updates until we upgraded to 3.2 and hit this. Neither of 
these are what I would consider "old" kernels.

Thanks for looking at this.

Josh
