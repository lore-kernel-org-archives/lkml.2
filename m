Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2AaXUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 18:20:32 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37516 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2AaXUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 18:20:31 -0500
MIME-Version: 1.0
In-Reply-To: <20120131185228.GA21481@kroah.com>
References: <1327118181-3542-1-git-send-email-arve@android.com>
	<1327118181-3542-2-git-send-email-arve@android.com>
	<20120121082208.GL3294@mwanda>
	<20120131185228.GA21481@kroah.com>
Date: Tue, 31 Jan 2012 15:20:30 -0800
Message-ID: <CAMP5XgedsSDtYa-bZCW--+Hj41sN94tDXQ8_d7c4=fT5bJ7mTQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Staging: android: binder: Add some error checks
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Greg KH <greg@kroah.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        Christopher Lais <chris+android@zenthought.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/31 Greg KH <greg@kroah.com>:
> On Sat, Jan 21, 2012 at 11:22:08AM +0300, Dan Carpenter wrote:
>> On Fri, Jan 20, 2012 at 07:56:20PM -0800, Arve Hjønnevåg wrote:
>> > - Add a mutex to protect against two processes mmapping the
>> >   same binder_proc.
>> > - After locking mmap_sem, check that the vma we want to access
>> >   (still) points to the same mm_struct.
>> > - Use proc->tsk instead of current to get the files struct since
>> >   this is where we get the rlimit from.
>>
>> This doesn't seem related to the locking change at all.  Probably
>> this patch should be split into three patches, one bugfix per
>> patch, unless they are very closely related.
>
> I agree.  Arve, is this all fixing one problem, or multiple ones?  If
> multiple ones, we need this split up into multiple patches.
>

That depend on your point of view. It fixes crashes if you use the
same binder file pointer from multiple processes. It seemed excessive
to have three patches for this.

-- 
Arve Hjønnevåg
