Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0CXQFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:05:01 -0400
Received: from daytona.panasas.com ([67.152.220.89]:34978 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753761Ab0CXQFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:05:00 -0400
Message-ID: <4BAA3828.2070506@panasas.com>
Date: Wed, 24 Mar 2010 18:04:56 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Benny Halevy <bhalevy@panasas.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT case
 to use of do_last()
References: <4BAA3493.1030802@panasas.com> <20100324160037.GP30031@ZenIV.linux.org.uk>
In-Reply-To: <20100324160037.GP30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2010 16:04:59.0327 (UTC) FILETIME=[C0FDACF0:01CACB6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 06:00 PM, Al Viro wrote:
> On Wed, Mar 24, 2010 at 05:49:39PM +0200, Boaz Harrosh wrote:
>> - I have an exofs filesystem mounted on /mnt/exofs
>> - []$ cd /mnt/exofs/some_linux_git; git status;
>>   All is fine
>> - []$ mount -t nfs4 -o minorversion=0 localhost:/ /mnt/nfs
>>   (Where etc/exports will export /mnt/exofs via nfs4.1)
>> - []$ cd /mnt/nfs/some_linux_git; git status;
>>   This will fail and will corrupt the .git/index file. Sometimes the file would be
>>   too short, and sometimes the file will become a directory (Yes really)
> 
> Bloody impressive...  Does that happen to underlying fs or to what you
> are seeing via NFS?

Only via NFS. All local access is fine.

After the corruption above I can cd to the local mount cp a fresh copy
of .git/index file and play around just fine.
Once I return to the NFS mounted directory, a git status will do it.
It does not matter if caches are cold (Takes a long time) or hot it happens
every time.

Weird I know, I'm playing some more with it as we speak

Thanks
Boaz
 
