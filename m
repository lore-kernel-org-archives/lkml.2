Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab2FLClR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:41:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52884 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2FLClP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:41:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120612014239.GA32087@kroah.com>
References: <201206071508.15674.hartleys@visionengravers.com>
	<20120611235657.GA26721@kroah.com>
	<ADE657CA350FB648AAC2C43247A983F0020698DBC4A9@AUSP01VMBX24.collaborationhost.net>
	<20120612004421.GA30997@kroah.com>
	<ADE657CA350FB648AAC2C43247A983F0020698DBC4B9@AUSP01VMBX24.collaborationhost.net>
	<20120612014239.GA32087@kroah.com>
Date: Mon, 11 Jun 2012 22:41:14 -0400
Message-ID: <CACqU3MXmYCcpzOYaJKa-x=Vn-iFDmXbAPxbFwN0nvt+x3h7UvQ@mail.gmail.com>
Subject: Re: [PATCH] staging: comedi: cleanup alloc_subdevices
From: Arnaud Lacombe <lacombar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 11, 2012 at 9:42 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jun 11, 2012 at 07:49:46PM -0500, H Hartley Sweeten wrote:
>> On Monday, June 11, 2012 5:44 PM, Greg KH wrote:
>> > On Mon, Jun 11, 2012 at 07:07:41PM -0500, H Hartley Sweeten wrote:
>> >> 2, 3, and 4 probably go together. They all deal with the 'num_subdevices'
>> >>
>> >> 1 can be a separate patch as long as I don't do the rename.
>> >>
>> >> 5, 6, and 7 could all go together with the final rename of the function.
>> >>
>> >> Does that sound ok?
>> >
>> > No, why not just break it up into 7 different patches?  You are doing
>> > different things, which would you rather review for correctness, 7
>> > simple, tiny patches, or some that do multiple things at the same time
>> > that are bigger?
>>
>> Ok. I just posted the first one. It's still pretty big since it hits every
>> comedi driver file.
>>
>> Please ignore the first post. I fat-fingered the prototype in the header.
>> v2 is correct.
>>
>> Also, I have never done local commits to my Linux-next tree so I'm not
>> sure how to proceed with the incremental patches. If it's ok with you
>> I'll just wait for each patch to go into staging.
>
> Create a brach from the one you are working on:
>        git branch -b my_branch
> make a change and commit it
> commit another one
> and so on.
actually, there is a simple way to do that. Simply start from the big
commit, then

# git reset --soft HEAD^
# git reset

Then do 7 iterations of:

# git add -p

Adding or not relevant hunks for the current change to be committed,
eventually manually editing them if two or more change end up being
mangled together.

my 0.2c,
 - Arnaud

> then create the patches:
>        git format-patch original_branch_name..my_branch
> and use git send-email to send them off in order.
>
> Otherwise we are going to take 7 weeks when I apply one of your patches
> a week :)
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
