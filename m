Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083Ab2JaAt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:49:58 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55952 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab2JaAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:49:57 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@parisplace.org>
Subject: Re: NULL pointer dereference at fat_detach
References: <20121030134449.GA5435@redhat.com>
	<1351632646.1339.72.camel@x61.thuisdomein>
Date: Wed, 31 Oct 2012 09:49:47 +0900
In-Reply-To: <1351632646.1339.72.camel@x61.thuisdomein> (Paul Bolle's message
	of "Tue, 30 Oct 2012 22:30:46 +0100")
Message-ID: <87y5in8nys.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> writes:

>> BUG: unable to handle kernel NULL pointer dereference at 0000009c
>> IP: [<c046d983>] do_raw_spin_lock+0xd/0x1e
>> 
>> [<c07fcc94>] _raw_spin_lock+0xd/0xf
>> [<f8fe03de>] fat_detach+0x20/0x59 [fat]
>> [<f8fe0874>] fat_evict_inode+0x5b/0x5e [fat]
>> [<c05058ad>] evict+0x57/0xe9
>> [<c0505a67>] iput+0xf8/0xfd
>> [<c051ce0f>] fsnotify_destroy_mark+0xdf/0xf8
>> [<c051e488>] sys_inotify_rm_watch+0x59/0x79
>> [<c07fcfbc>] syscall_call+0x7/0xb
>> 
>> what most likely indicate that fat_evict is called with
>> inode with i_sb->s_fs_info == NULL.

This bug is known as the inotify bug. I recall I talked about this,
maybe years ago.

Eric?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
