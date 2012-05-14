Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab2ENLGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:06:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51113 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab2ENLGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120514105318.GH5353@quack.suse.cz>
References: <4FAFBAC1.20603@gmail.com>
	<20120514094543.GC5353@quack.suse.cz>
	<CANGUGtA=XfraVL28YqAM0t3oMjfud0Fn1VtJNxwt8=reG10nGA@mail.gmail.com>
	<20120514105318.GH5353@quack.suse.cz>
Date: Mon, 14 May 2012 13:06:11 +0200
Message-ID: <CANGUGtCN3oJDv9Ja5KJ8bBz+HG5_ppeAMrmb34aUpmEH00E8nw@mail.gmail.com>
Subject: Re: [PATCH v2] Fix AFFS race condition.
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: =?ISO-8859-7?Q?Vladimir_=27=F6=2Dcoder=2Fphcoder=27_Serbinenko?= 
	<phcoder@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <josef@redhat.com>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/14 Jan Kara <jack@suse.cz>:
> On Mon 14-05-12 12:40:45, Marco Stornelli wrote:
>> 2012/5/14 Jan Kara <jack@suse.cz>:
>> > On Sun 13-05-12 15:44:33, Vladimir 'ö-coder/phcoder' Serbinenko wrote:
>> >> AFFS code preallocates several blocks as an optimisation. Unfortunately
>> >> it's not protected by lock so the same blocks may end up allocated twice.
>> >> Here is a fix.
>> >>
>> >> Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
>> >  The patch looks good to me now. Thanks! You can add:
>> > Reviewed-by: Jan Kara <jack@suse.cz>
>> >
>> >  Al, will you merge this patch through your tree? AFFS does not seem to
>> > have a maintainer so you are a default fallback...
>> >
>> >                                                                Honza
>> >
>>
>> I don't know the AFFS code, so only a question. Instead to use a spin
>> lock, I think we can use a simple mutex. Or is the spin lock
>> mandatory?
>  So what would be an advantage of a mutex? Spinlock *is* the simple locking
> variant...
>
>                                                                Honza
> --

None actually, only style, but if there are performance consideration
already done, ok it was only a question. :)

Marco
