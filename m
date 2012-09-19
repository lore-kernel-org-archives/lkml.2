Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2ISKuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 06:50:39 -0400
Received: from mga06.intel.com ([134.134.136.21]:64319 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751573Ab2ISKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 06:50:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120919044651.GY13973@ZenIV.linux.org.uk>
References: <CALLzPKZqw05_4V6NQeo-A6xOza2P4g6mqxDJnv7f-ktovj_HpQ@mail.gmail.com>
	<alpine.LRH.2.02.1209191419410.29525@tundra.namei.org>
	<20120919044651.GY13973@ZenIV.linux.org.uk>
Date: Wed, 19 Sep 2012 13:50:34 +0300
Message-ID: <CALLzPKZyS3x4=Qt26L8a2zVf3o7DkYEPPJr+Tzt=Tj7mDCtXFQ@mail.gmail.com>
Subject: Re: IMA policy search speedup
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 7:46 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Sep 19, 2012 at 02:21:56PM +1000, James Morris wrote:
>> On Tue, 18 Sep 2012, Kasatkin, Dmitry wrote:
>>
>> > I looked to <linux/fs.h> and found that there is a possibility to to
>> > add additional flag for sb->s_flags.
>> > For example
>> >
>> > #define MS_NOT_IMA              (1<<25) /* NOT_IMA */
>> > #define IS_I_NOT_IMA(inode)   __IS_FLG(inode, MS_NOT_IMA)
>> >
>> >
>> > Another way is to add additional dedicated integrity related member to
>> > the sb structure.
>> > struct super_block {
>> > ...
>> > #ifdef CONFIG_INTEGRITY
>> >       int s_integrity;
>> > #endif
>> > };
>> >
>> > Obviously there are only few super blocks in the system and few bytes
>> > will not harm.
>>
>> The flag seems better than adding a new struct member.  Why would you need
>> an int for this?
>
> Per-superblock bit would be a bit better, but I really hate the way we have
> them mixed up between superblock ->s_flags bits and mount(2) action weirdly
> encoded into flags thing.  If we are going to touch that thing, how about
> separate S_... bits, with MS_... crap left only for mount(2) decoding?  Mapped
> to S_... when needed.
>
> The really messy part is that right now we silently ignore all the unknown
> bits in mount(2) flags argument ;-/  It's *not* a widely used syscall, but
> still - changing that in a non-trivial way is potential userland breakage.

Indeed it is quite messy.
My understanding is that S_ flags are inode->i_flags. Would it be also
a bit confusing?
Do you suggest to add additional superblock flags attribute? What
could be moved there?

- Dmitry
