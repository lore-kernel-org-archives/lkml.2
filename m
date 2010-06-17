Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab0FQUc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:32:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61441 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab0FQUcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=akDawxnrbjVoS9tAKRJ0p/CbJ2QnunIwXdA+/Q3mkBk2uaN7XN2fv2tdUmyXw3RFsz
         /A7dLMFkkNSOM8jUKBcaTVY91u8y630018Cyv936WXqtz6x5bVB7WCZu+hLx/PRQFBcq
         Ou+AlM3vTWrcOZWD6dUNGgh5F2iM39pamLNkE=
MIME-Version: 1.0
In-Reply-To: <20100617183912.GA14389@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
	<1276627208-17242-18-git-send-email-vaurora@redhat.com>
	<AANLkTilNAGzn3ZC5eN2ZQMqNhcSWnT-mi_y2TkIkdeUU@mail.gmail.com>
	<20100617183912.GA14389@shell>
Date: Thu, 17 Jun 2010 22:32:09 +0200
Message-ID: <AANLkTilUbzQjEBiZ9LHEvugLXbsaZoEyt9S-v3KQgUQB@mail.gmail.com>
Subject: Re: [PATCH 17/38] union-mount: Union mounts documentation
From: Alex Riesen <raa.lkml@gmail.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 20:39, Valerie Aurora <vaurora@redhat.com> wrote:
> On Thu, Jun 17, 2010 at 10:01:30AM +0200, Alex Riesen wrote:
>> On Tue, Jun 15, 2010 at 20:39, Valerie Aurora <vaurora@redhat.com> wrote:
>> > +git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git
>> > +
>> > +Currently, whiteout directory entries are not returned to userland.
>> > +While the directory type for whiteouts, DT_WHT, has been defined for
>> > +many years, very little userland code handles them. ??Userland will
>> > +never see fallthru directory entries.
>>
>> This may be a dumb question (I must admit I did only very little research),
>> but how does one cleanup the topmost layer of whiteouts and fallthroughs,
>> so that the entries of lower layer(s) can be made visible again?
>
> I'm not sure how best to do this.  We don't want to add more system
> calls.  One thought of mine has been to do this offline, when the file
> system is unmounted.

But that means that if the topmost filesystem is getting full of whiteouts
and fallthroughs there will be no way to free up the space without taking
the volume offline! That makes operation of union mount on always-on
systems difficult. Many personal electronics are always-on today, it
will be annoying to have to shutdown them on reconfigurations or just
to free up some space.

> ... For example, e2fsck could add a feature to
> delete whiteouts and fallthrus. ...

That makes me think that the cleanup operation will be topmost
filesystem specific. Maybe this even means that one have to
have the filesystem specific tools installed on every system
which happens to use union mounts.

> Another option is to add a flag to an existing system call.

Or calls, if the whiteouts (or even fallthroughs) are to be read
through directory file handles. unlinkat(2) ? It already has
dirfd and flags arguments.
