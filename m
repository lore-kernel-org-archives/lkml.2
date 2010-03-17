Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0CQRFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:05:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab0CQRFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:05:38 -0400
Message-ID: <4BA10B66.1020705@redhat.com>
Date: Wed, 17 Mar 2010 19:03:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Chris Webb <chris@arachsys.com>, balbir@linux.vnet.ibm.com,
       KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
References: <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com> <4B9F4CBD.3020805@redhat.com> <20100317152452.GZ31148@arachsys.com> <4BA101C5.9040406@redhat.com> <4BA105FE.2000607@redhat.com> <20100317164752.GA31884@arachsys.com> <4BA1090E.9090502@redhat.com> <20100317165854.GC29548@lst.de>
In-Reply-To: <20100317165854.GC29548@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 06:58 PM, Christoph Hellwig wrote:
> On Wed, Mar 17, 2010 at 06:53:34PM +0200, Avi Kivity wrote:
>    
>> Meanwhile I looked at the code, and it looks bad.  There is an
>> IO_CMD_FDSYNC, but it isn't tagged, so we have to drain the queue before
>> issuing it.  In any case, qemu doesn't use it as far as I could tell,
>> and even if it did, device-matter doesn't implement the needed
>> ->aio_fsync() operation.
>>      
> No one implements it, and all surrounding code is dead wood.  It would
> require us to do asynchronous pagecache operations, which involve
> major surgery of the VM code.  Patches to do this were rejected multiple
> times.
>    

Pity.  What about the O_DIRECT aio case?  It's ridiculous that you can 
submit async write requests but have to wait synchronously for them to 
actually hit the disk if you have a write cache.

-- 
error compiling committee.c: too many arguments to function

