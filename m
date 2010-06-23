Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0FWInN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:43:13 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:40340 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab0FWInL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wJiWbyBa0aMNQbtoO0GW8B/6pDLi7Hsux8qwrBjURsI0LSfqjuVIzkfOAWPG6FnlHW
         rdtGon/L4UHdr25tbnzSdjy7jLDeqeB6ZTjzFEMiQIFj1CR4ZLi91jFDCkFQ8l3zZkQw
         dBtvxwdvRB/K5kl73FKuwErvd8dG4YuZekzXc=
MIME-Version: 1.0
In-Reply-To: <E1OQgpf-0001DJ-3w@pomaz-ex.szeredi.hu>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
	<1276627208-17242-18-git-send-email-vaurora@redhat.com>
	<AANLkTilNAGzn3ZC5eN2ZQMqNhcSWnT-mi_y2TkIkdeUU@mail.gmail.com>
	<20100617183912.GA14389@shell>
	<E1OQgpf-0001DJ-3w@pomaz-ex.szeredi.hu>
Date: Wed, 23 Jun 2010 10:43:10 +0200
Message-ID: <AANLkTikaxHChLzvbWPUZcPqxUURtjBSY9SXeU3nlKHIR@mail.gmail.com>
Subject: Re: [PATCH 17/38] union-mount: Union mounts documentation
From: Alex Riesen <raa.lkml@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Valerie Aurora <vaurora@redhat.com>, viro@zeniv.linux.org.uk,
       jblunck@suse.de, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 15:14, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, 17 Jun 2010, Valerie Aurora wrote:
>> On Thu, Jun 17, 2010 at 10:01:30AM +0200, Alex Riesen wrote:
>> > On Tue, Jun 15, 2010 at 20:39, Valerie Aurora <vaurora@redhat.com> wrote:
>> > > +git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git
>> > > +
>> > > +Currently, whiteout directory entries are not returned to userland.
>> > > +While the directory type for whiteouts, DT_WHT, has been defined for
>> > > +many years, very little userland code handles them. ??Userland will
>> > > +never see fallthru directory entries.
>> >
>> > This may be a dumb question (I must admit I did only very little research),
>> > but how does one cleanup the topmost layer of whiteouts and fallthroughs,
>> > so that the entries of lower layer(s) can be made visible again?
>>
>> I'm not sure how best to do this.  We don't want to add more system
>> calls.  One thought of mine has been to do this offline, when the file
>> system is unmounted.  For example, e2fsck could add a feature to
>> delete whiteouts and fallthrus.  Another option is to add a flag to an
>> existing system call.
>
> One more advantage of doing whiteouts, etc. with hard links and
> extended attributes instead of as special filesystem objects.  That
> way they are visible (unless part of a union) and can be treated as
> normal filesystem objects.

But then you have to break union to cleanup the topmost filesystem.
That'll surely take the mount filesystem (in its working configuration, at
least) offline. Not much better than using fsck.
