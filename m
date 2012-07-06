Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab2GFSQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:16:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50363 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2GFSQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:16:06 -0400
MIME-Version: 1.0
In-Reply-To: <4FEDB64C.2040208@stericsson.com>
References: <4FEDB64C.2040208@stericsson.com>
Date: Fri, 6 Jul 2012 14:16:04 -0400
Message-ID: <CACLa4ps-YDABR5GZsFfXL0=_evU7LO5bmdmQu+zcSR8NXd-aQA@mail.gmail.com>
Subject: Re: inotify: notify IN_DELETE_SELF when file is deleted or inode
 deleted ?
From: Eric Paris <eparis@parisplace.org>
To: Pierre PEIFFER <pierre.peiffer@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is inode oriented.  Makes it a pain to work with, but that's how it
is.  Sorry!

On Fri, Jun 29, 2012 at 10:06 AM, Pierre PEIFFER
<pierre.peiffer@stericsson.com> wrote:
> Hi,
>
> By playing with inotify (on user side) to know whether the file I'm using is
> deleted by someone else,  I have noted that I do not receive the
> IN_DELETE_SELF event, exactly because I'm using it. By checking into kernel
> area, I see that at unlink(), an IN_ATTRIB event is sent, but IN_DELETE_SELF
> is, indeed, sent only when the inode is deleted.
>
> But such IN_ATTRIB event doesn't tell to the user what has changed among
> permissions, timestamps, link count, etc...
> So it doesn't much help. Of course, I have noted that I can monitor the
> parent directory for IN_DELETE and then check which file has been deleted;
> few more stuff to do but it works, no pb.
>
> But I'm still wondering after reading in the man.:
>            IN_DELETE_SELF    Watched file/directory was itself deleted.
> Is this really the expected behavior ? Shouldn't the kernel trig such event
> at unlink() ? Or is inotify clearly inode oriented ?
>
> Thanks,
>
> Pierre
>
> PS: keep me in cc, I'm not subscribed to the list.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
