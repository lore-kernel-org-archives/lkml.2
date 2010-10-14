Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0JNVFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:05:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40541 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab0JNVFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:05:23 -0400
Message-ID: <4CB7700E.8080008@oracle.com>
Date: Thu, 14 Oct 2010 14:03:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com,
        lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [xfs-masters] [PATCH -next] xfs: eliminate kconfig dependency
 warning
References: <20101013210142.9d524535.randy.dunlap@oracle.com> <20101014092503.GA28446@lst.de> <4CB73B5B.30108@oracle.com> <20101014205502.GC4681@dastard>
In-Reply-To: <20101014205502.GC4681@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/10 13:55, Dave Chinner wrote:
> On Thu, Oct 14, 2010 at 10:18:19AM -0700, Randy Dunlap wrote:
>> On 10/14/10 02:25, Christoph Hellwig wrote:
>>> On Wed, Oct 13, 2010 at 09:01:42PM -0700, Randy Dunlap wrote:
>>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>>
>>>> Fix kconfig dependency warning to satisfy dependencies:
>>>>
>>>> warning: (XFS_FS && BLOCK || NFSD && NETWORK_FILESYSTEMS && INET && FILE_LOCKING && BKL) selects EXPORTFS which has unmet direct dependencies (NETWORK_FILESYSTEMS)
>>>
>>> I'm not entirely sure what this gibberish means, but I'm pretty sure it
>>> does not make sense.
>>>
>>> EXPORTFS is a small module that doesn't have any dependencie, and it's
>>> needed by XFS for the by-handle operation, and by nfsd for the same
>>> thing.  It has absolutely nothing to do with networking or network
>>> filesystems (as in network filesystem clients).
>>
>> The (kconfig) warning/problem is that exportfs is in the Networking Filesystems menu,
>> under the kconfig symbol NETWORK_FILESYSTEMS.
> 
> Thanks for the explanation, Randy.
> 
>> Dave Chinner wrote:
>> | EXPORTFS functionality actually has use for local filesystems - the
>> | open-by-handle interfaces in XFS are what uses it, and there are patches
>> | about that make this generic for most filesystems. Hence it seems to
>> | me that the correct thing to do is separate EXPORTFS from
>> | NETWORK_FILESYSTEMS, not make local filesystems depend on a user
>> | selecting network filesystem support....
>>
>> Agreed.  Is that Kconfig change also part of the "patches about"?
> 
> I can't remember exactly what it does with the kconfig symbols.
> Information about the patch series (including a link to the git repo
> storing the changes) is here:
> 
> http://marc.info/?l=linux-fsdevel&m=128627415827161&w=2

That patch series does not modify any Kconfig files.
That change can be done separately and at another time.

Thanks for the pointer.
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
