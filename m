Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab1ANF25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 00:28:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54085 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab1ANF2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 00:28:54 -0500
Message-ID: <4D2FDF3E.5030309@cn.fujitsu.com>
Date: Fri, 14 Jan 2011 13:29:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Nick Piggin <npiggin@gmail.com>, Paul Menage <menage@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel BUG at fs/dcache.c:1363 (from cgroup)
References: <4D2FD771.9040301@cn.fujitsu.com> <20110114051453.GY19804@ZenIV.linux.org.uk>
In-Reply-To: <20110114051453.GY19804@ZenIV.linux.org.uk>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-14 13:28:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-14 13:28:25,
	Serialize complete at 2011-01-14 13:28:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Fri, Jan 14, 2011 at 12:56:17PM +0800, Li Zefan wrote:
>> Just mount the cgroupfs:
>>
>> # mount -t cgroup -o cpuset xxx /mnt
>> (oops!!)
>>
>> The bug is caused by:
>>
>> =========
>> commit 0df6a63f8735a7c8a877878bc215d4312e41ef81
>> Author: Al Viro <viro@zeniv.linux.org.uk>
>> Date:   Tue Dec 21 13:29:29 2010 -0500
>>
>>     switch cgroup
>>     
>>     switching it to s_d_op allows to kill the cgroup_lookup() kludge.
>>     
>>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>> =========
>>
>> This line:
>>
>> +       sb->s_d_op = &cgroup_dops;
> 
> Oh, crap...  Right, it's using simple_lookup().  Let me check if anything
> else might be stepping on that.
> 
> Umm...  There's a very strange codepath in btrfs that also might.
> Interesting.  Fix for cgroup, AFAICS, should be this:
> 

patch tested. thanks!
