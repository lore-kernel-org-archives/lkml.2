Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab0DIAIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 20:08:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:48356 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759208Ab0DIAIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 20:08:06 -0400
Message-ID: <4BBE6F0C.6020207@suse.com>
Date: Thu, 08 Apr 2010 20:04:28 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-2.3 Thunderbird/3.0.3
MIME-Version: 1.0
To: Matt McCutchen <matt@mattmccutchen.net>
Cc: ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH #3] reiserfs: Fix permissions on .reiserfs_priv
References: <4BBE42A9.2010506@suse.com>  <4BBE4CE2.8030805@gmail.com> <1270766367.3441.4.camel@mattlaptop2.local>
In-Reply-To: <1270766367.3441.4.camel@mattlaptop2.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 06:39 PM, Matt McCutchen wrote:
> On Thu, 2010-04-08 at 23:38 +0200, Edward Shishkin wrote:
>> Jeff Mahoney wrote:
>>>  [...] This patch resolves the issue by properly hiding .reiserfs_priv. This
>>>  was the intent of the xattr poisoning code, but it appears to have
>>>  never worked as expected. This is fixed by using d_revalidate instead
>>>  of d_compare. [...]
> 
> The patch seems to rely on the fact that the priv_root dentry is stuck
> in the dcache for as long as the filesystem is mounted, so that attempts
> to follow ".reiserfs_priv" are guaranteed to match that dentry in the
> cache and be refused by xattr_hide_revalidate.  Is my understanding
> correct?
> 

Yes. The other half of it is that the priv_root dentry being stuck in
the dcache for as long as the flie system is mounted is a guaranteed
since REISERFS_SB(sb) holds a reference to it until reiserfs_kill_sb is
called.

-Jeff

-- 
Jeff Mahoney
SuSE Labs
