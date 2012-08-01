Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2HAUHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:07:44 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34041 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab2HAUHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:07:42 -0400
Message-ID: <50198C83.4000500@oracle.com>
Date: Wed, 01 Aug 2012 15:07:31 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Tino Reichardt <list-linux-fsdevel@mcmilk.de>
CC: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [Jfs-discussion] [PATCH] fs/jfs: TRIM support for JFS Filesystem
References: <20120726213219.GA28330@mcmilk.de> <20120728110805.GA690@mcmilk.de> <50185916.7010705@oracle.com> <20120801192934.GB19139@mcmilk.de>
In-Reply-To: <20120801192934.GB19139@mcmilk.de>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/01/2012 02:29 PM, Tino Reichardt wrote:
> * Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
>> On 07/28/2012 06:08 AM, Tino Reichardt wrote:

>>> +	tt->nblocks = 0; /* mark the current end */
>>> +	for (tt = totrim; tt->nblocks != 0; tt++) {
>>> +		if (!(JFS_SBI(sb)->flag & JFS_DISCARD)) {
>>> +			/* not needed, when online discard is used */
>>
>> Why enter the function at all if JFS_DISCARD is set? But is this really
>> true? Removing files or file fragments that are smaller than
>> minblks_trim will fail to discard them dynamically.
> 
> The other FS can also trim via fstrim(8) when mounted with discard
> option :) It is important, that a user can discard all free blocks, even
> when mounting with discard option. The FS could also be mounted several
> times without discard option, and then there are some ranges, where the
> device isn't informed about these ranges. So the batched discard ioctl()
> is then the only way to change that.
> 
> 
> The comment there was also a bit updated, here is it:
> 
> /* when mounted with online discard, dbFree() will
>  * call jfs_issue_discard() itself */

Ah. This comments makes it clear. I was forgetting that dbFree will
handle this.

Thanks,
Dave
