Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab2CHTfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:35:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41928 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2CHTfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:35:08 -0500
MIME-Version: 1.0
In-Reply-To: <20120308155211.GF4334@twin.jikos.cz>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
	<20120308155211.GF4334@twin.jikos.cz>
Date: Thu, 8 Mar 2012 20:35:06 +0100
Message-ID: <CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
From: Jacek Luczak <difrost.kernel@gmail.com>
To: dave@jikos.cz, Jacek Luczak <difrost.kernel@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/8 David Sterba <dave@jikos.cz>:
> On Thu, Mar 08, 2012 at 01:10:45PM +0100, Jacek Luczak wrote:
>> kernel BUG at fs/btrfs/delayed-inode.c:1466!
>
> 1461         ret = btrfs_delayed_item_reserve_metadata(trans, root, item);
> 1462         /*
> 1463          * we have reserved enough space when we start a new transaction,
> 1464          * so reserving metadata failure is impossible.
> 1465          */
> 1466         BUG_ON(ret);
>
>> RAX: 00000000ffffffe4
>
> ENOSPC
>
>>  [<ffffffffa03210e5>] ? __btrfs_unlink_inode+0x172/0x25e [btrfs]
>>  [<ffffffffa032158c>] ? btrfs_rename+0x38b/0x55b [btrfs]
>
> rename reserves 20 blocks, but seems that's not enough.  I've never seen
> a crash report in rename, and according to the stacktrace there's
> nothing suspicious (like selinux related).

There were quite many things happening in the system at that time.
Can't really tell what could trigger this.

Complete logs: http://91.234.146.107/~difrost/logs/tampere_log.gz

-Jacek
