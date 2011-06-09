Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab1FIN6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:58:11 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:56079 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab1FIN6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=hk8tJO4TJ0mOBv94s6UjXbm38Zokat7T3vQVe7N2OTIQEmZx65L4qm3P2XneGKwxPb
         86GAsAhPwXCiUkS5Wah9D/tZ1mibLv0y6Fmq4rbPZMo83E2yE1W3IC6vEwwDPcr9Ajlx
         DX3jF7fooGNQz5kLTK6HmMwbaYcQ3ZugrZLjk=
MIME-Version: 1.0
In-Reply-To: <20110608205233.ebfedc4d.akpm@linux-foundation.org>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
 <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown>
 <20110608205233.ebfedc4d.akpm@linux-foundation.org>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Thu, 9 Jun 2011 15:57:48 +0200
X-Google-Sender-Auth: qda9rQuPw6B1mBu7LHzBMxherWg
Message-ID: <BANLkTikN_GST2ZXwrJFO0H32FM+EF-WE8w@mail.gmail.com>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 June 2011 05:52, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 9 Jun 2011 11:59:34 +1000 NeilBrown <neilb@suse.de> wrote:
>
>> On Wed, 8 Jun 2011 15:32:08 -0700 Andrew Morton <akpm@linux-foundation.org>
>> wrote:
>>
>> > On Wed,  1 Jun 2011 14:46:13 +0200
>> > Miklos Szeredi <miklos@szeredi.hu> wrote:
>> >
>> > > I'd like to ask for overlayfs to be merged into 3.1.
>> >
>> > Dumb questions:
>> >
>> > I've never really understood the need for fs overlaying.  Who wants it?
>> > What are the use-cases?
>>
>> https://lwn.net/Articles/324291/
>>
>> I think the strongest use case is that LIVE-DVD's want it to have a write-able
>> root filesystem which is stored on the DVD.
>
> Well, these things have been around for over 20 years.  What motivated
> the developers of other OS's to develop these things and how are their
> users using them?

FWIW there is an union solution in NetBSD. I am not sure it is used in
the LiveCD but you can definitely use it to build a piece of software
without actually touching the source directory.

>
>> >
>> > This sort of thing could be implemented in userspace and wired up via
>> > fuse, I assume.  Has that been attempted and why is it inadequate?
>>
>> I think that would be a valid question if the proposal was large and
>> complex.  But overlayfs is really quite small and self-contained.
>
> Not merging it would be even smaller and simpler.  If there is a
> userspace alternative then that option should be evaluated and compared
> in a rational manner.

The problem with the userspace alternative is that it does not work. I
tried to run my live CD on top of unionfs-fuse and the filesystem
would fail intermittently leading to random errors during boot.

>
>
>
> Another issue: there have been numerous attempts at Linux overlay
> filesystems from numerous parties.  Does (or will) this implementation
> satisfy all their requirements?

No implementation will satisfy all needs. There is always some
compromise between availability (userspace/in-tree/easy to patch in)
feature completeness (eg. AuFS is not so easy to forward-port to new
kernels but has numerous features) performance, reliability.

>
> Because if not, we're in a situation where the in-kernel code is
> unfixably inadequate so we end up merging another similar-looking
> thing, or the presence of this driver makes it harder for them to get
> other drivers merged and the other parties' requirements remain
> unsatisfied.

One of the major use cases is building live CDs.

That and other things can be done with overlayfs.

Thanks

Michal
