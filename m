Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1CGQ7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:59:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58633 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab1CGQ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:59:22 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] a couple of i_nlink fixes in btrfs
In-reply-to: <20110304171353.GU22723@ZenIV.linux.org.uk>
References: <20110304171353.GU22723@ZenIV.linux.org.uk>
Date: Mon, 07 Mar 2011 11:58:13 -0500
Message-Id: <1299517070-sup-1687@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D750EE7.00D9,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Al Viro's message of 2011-03-04 12:13:53 -0500:
>     a) rename() plays with i_nlink of old_inode; bad, since it's not
> locked.  I'd add a variant of btrfs_unlink_inode() that would leave
> btrfs_drop_nlink()/btrfs_update_inode() to callers and use it instead.
>     b) btrfs_link() doesn't check for i_nlink overflows.  I don't
> know if there's anything preventing that many links to a file on btrfs,
> but if there is, it's at least worth a comment in there...
> 
>     Please, review; patches in followups or in #btrfs in vfs-2.6.git

Thanks, these both look good but I'll test here as well.  Are you
planning on pushing for .38?

-chris
