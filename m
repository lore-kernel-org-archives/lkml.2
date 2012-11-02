Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965843Ab2KBJ5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:57:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44786 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964939Ab2KBJ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:57:28 -0400
Message-ID: <5093977A.9010507@gmail.com>
Date: Fri, 02 Nov 2012 10:50:50 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: enabling psacct breaks fsfreeze
References: <20121023094351.GC27919@pcnci.linuxbox.cz> <20121031121517.GD18424@quack.suse.cz> <20121031124600.GM20752@pcnci.linuxbox.cz> <20121101093723.GC6584@quack.suse.cz> <20121101111957.GD6584@quack.suse.cz> <20121101142325.GD20752@pcnci.linuxbox.cz> <20121101225053.GB31937@quack.suse.cz>
In-Reply-To: <20121101225053.GB31937@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/11/2012 23:50, Jan Kara ha scritto:
> On Thu 01-11-12 15:23:25, Nikola Ciprich wrote:
>> Nov  1 14:23:25 vmnci22 [ 1075.178123] SysRq : Show Blocked State
>> Nov  1 14:23:25 vmnci22 [ 1075.180555]   task                        PC stack   pid father
>> Nov  1 14:23:25 vmnci22 [ 1075.180592] fsfreeze      D 0000000000000000     0  4215   4195 0x00000000
>> Nov  1 14:23:25 vmnci22 [ 1075.180599]  ffff8800090b9b28 0000000000000046 0000000000000000 ffffffff00000000
>> Nov  1 14:23:25 vmnci22 [ 1075.180606]  0000000000013780 ffff8800090b9fd8 ffff88000f716170 ffff88000f715e80
>> Nov  1 14:23:25 vmnci22 [ 1075.180612]  ffff88000f715dc0 ffffffff81566080 ffff88000f716170 000000010002f405
>> Nov  1 14:23:25 vmnci22 [ 1075.180619] Call Trace:
>> Nov  1 14:23:25 vmnci22 [ 1075.180693]  [<ffffffff810e2dbb>] __generic_file_aio_write+0xbb/0x420
>> Nov  1 14:23:25 vmnci22 [ 1075.180729]  [<ffffffff81079290>] ? autoremove_wake_function+0x0/0x40
>> Nov  1 14:23:25 vmnci22 [ 1075.180736]  [<ffffffff810e317f>] generic_file_aio_write+0x5f/0xc0
>    Thanks. So the system isn't really deadlocked. It's just that fsfreeze
> command hangs, isn't it? OK, I understand that it's kind of incovenient
> situation because every command will hang like this when the filesystem is
> frozen.
>
> Now I only have to come up with a way to improve this... It isn't quite
> simple - to properly protect against freezing be have to communicate down
> into generic_file_aio_write() that we want to bail out if filesystem is
> frozen instead of waiting.
>
> 								Honza
>

I saw this behavior (task-hang) when I tested the fsfreeze code. I was 
writing a little patch to replace fsfreeze's wait queue with a killable 
queue, in this way the user can do at least "kill -9", but since the 
behavior was the same before your patch I didn't send it. I don't know 
if we can break any previous behavior. The funny thing here is that it's 
like if fsfreeze freezes itself :)

Marco
