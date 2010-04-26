Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab0DZHt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 03:49:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab0DZHtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 03:49:25 -0400
Message-ID: <4BD54573.3020801@redhat.com>
Date: Mon, 26 Apr 2010 09:49:07 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Miklos Szeredi <mszeredi@suse.cz>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vic Abell <abe@purdue.edu>
Subject: Re: [PATCH] procfs: fix tid fdinfo
References: <4BD1BF57.7070201@redhat.com>	 <20100423111620.100840fe.akpm@linux-foundation.org>	 <20100424192735.GA5157@x200> <1272053239.4456.4.camel@tucsk.pomaz.szeredi.hu>
In-Reply-To: <1272053239.4456.4.camel@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 10:07 PM, Miklos Szeredi wrote:
> On Sat, 2010-04-24 at 22:27 +0300, Alexey Dobriyan wrote:
>> On Fri, Apr 23, 2010 at 11:16:20AM -0700, Andrew Morton wrote:
>>> On Fri, 23 Apr 2010 17:40:07 +0200
>>>> -	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fd_operations),
>>>> +	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
>>
>>> hm, the code's been like that for over a year.  What are the
>>> user-visible effects of the bug, and of this change?
>>
>> /proc/*/task/*/fdinfo contains symlinks to opened files like /proc/*/fd/
>> which is cool bug :-)
> 
> Yeah, at least now we can see that someone has started using this
> interface ;)

AFAIK there is still nobody using it, but lsof should use it, and 
/proc/<pid>/task/<tid>/fd/ too. I haven't checked the code, but as it is
now, it doesn't spot files open by a thread which does share its father's
file descriptor table.

> 
> Jerome, thanks for spotting this!
> 
> Miklos
> 
> 

