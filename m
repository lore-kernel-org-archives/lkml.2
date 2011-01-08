Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1AHCyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 21:54:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41467 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab1AHCyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 21:54:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LDCrVQOO19AQu/v0OAX4FvSPferf0krcWQ47LjySGVEpTkXByvwI9XXqk1zDP/2iwZ
         RvIf4HCsnCsA3MTkn4N1OgNVMIXdPB94ejBKx/gnL+K5WV8uuNBtnVb18TwOciMILhF+
         zd54pcXvYg+S++0hxEeZZyLvogVIdW6QnQs2U=
MIME-Version: 1.0
Date: Sat, 8 Jan 2011 13:54:47 +1100
Message-ID: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
Subject: Important for fs devs: rcu-walk merged upstream
From: Nick Piggin <npiggin@gmail.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfs-scale branch is now upstream. If you haven't
looked yet, your filesystem is likely to have been
touched, so check it out.

Also look at Documentation/filesystems/porting and
path-lookup.txt.

The dcache_lock stuff should have been all done for you
(for in-tree filesystems, I can help out of tree fses with
conversions there if you ping me offline).

The rcu-walk stuff can be more tricky for your filesystem
to take advantage of.

If you supply a .d_revalidate, .permission, or .check_acl,
then path walking is going to be slow and unscalable for
you.

Out of tree filesystems: you _have_ to at least add a line
of code to the above functions in order to specify that
you don't want to participate in rcu-walk.

Otherwise, you don't have to care about rcu-walk if you
have a legacy or special filesystem like configfs then I'd
advise against anything fancy. But if you have a
userbase and you expect them to actually do any path
lookups into your filesystem, please take a look.

This is a big and complex change by any measure, so
please don't be afraid to ask for help or clarification. I'd
also really like to be able to update documentation
based on questions from fs maintainers (in and out of
tree) who are trying to follow it and bring their code up to
speed.

Thanks,
Nick
