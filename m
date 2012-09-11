Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2IKUzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 16:55:24 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37908 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab2IKUzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 16:55:22 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] issues with NFS filesystems as lower layer
References: <1346946994-21286-1-git-send-email-apw@canonical.com>
	<CAJfpegsCQKX==v-8NqO5tLDsEed7KhBFWpoeWLDjxT1vuMSokg@mail.gmail.com>
	<20120907193825.GA4633@fieldses.org>
Date: Tue, 11 Sep 2012 22:56:52 +0200
In-Reply-To: <20120907193825.GA4633@fieldses.org> (J. Bruce Fields's message
	of "Fri, 7 Sep 2012 15:38:26 -0400")
Message-ID: <87ipbkxoq3.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

>> > Secondly when using an NFSv3 R/O lower layer the filesystem permissions
>> > check refuses permission to write to the inode which prevents us from
>> > copying it up even though we have a writable upper layer.  (With an ext4
>> > lower layer the inode check will succeed if the inode  is writable even
>> > if the filesystem is not.)  It is not clear what the right solution is
>> > here.  One approach is to check the inode permissions only (avoiding the
>> > filesystem specific permissions op), but it is not clear we can rely on
>> > these for all underlying filesystems.  Perhaps this check should only be
>> > used for NFS.
>
> Then couldn't you for example end up circumventing ACLs on the
> underlying file to access data cached by reads from another user on the
> same system?

Ignoring ACL's should always give less access, isn't that right?

>
> Is it possible to arrange that the check for a readonly filesystem be
> done only by the vfs and not also by ->permission?

You'd need to modify NFS servers for that to work, no?  It's possible
but not practical.

Thanks,
Miklos



>
> --b.
>
>> > Perhaps it needs to be a mount option.  The second patch
>> > (for discussion) following this email implements this, using the inode
>> > permissions when the lowerlayer is read-only.  This seems to work as
>> > expected in my limited testing.
>> 
>> I fear that will create an inconsistency between the read-only and the
>> non-read-only case, even though both should behave the same.
>> 
>> I think the cleanest would be to create a mount option to always use
>> generic_permission (on both the lower and the upper fs).  That would
>> give us two, slightly different, operating modes but each would be
>> self consistent.
>> 
>> Thanks,
>> Miklos
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
