Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab1FCEZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 00:25:25 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62654 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1FCEZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 00:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KpHjioaCZqv6sKPIk/9gXaYaev8z/a45W9T+MwuGCwkN8LeYNSiVdivmtt0BMZNJPq
         tI3r22TM5yXvadzzeH53Gd5ewILDbMbD1afjOgCRkZMgIa4c62CYhz2npi1Wm0op73d0
         q9NkSXp1D/tF9MkKykGlqrElsmiRCAH6Jeky0=
MIME-Version: 1.0
In-Reply-To: <20110603020615.GZ561@dastard>
References: <20101118142918.GA18510@infradead.org>
	<1290100750.3041.72.camel@mulgrave.site>
	<4CE59C9E.6050902@teksavvy.com>
	<1290177488-sup-6540@think>
	<4CE68F80.7000607@teksavvy.com>
	<20101119145748.GB27919@infradead.org>
	<4CE695FF.20601@teksavvy.com>
	<20101207092749.GA26100@infradead.org>
	<1291740643-sup-2494@think>
	<BANLkTimkn7ZVAUJw6NfWVMECfe+C+82i+g@mail.gmail.com>
	<20110603020615.GZ561@dastard>
Date: Fri, 3 Jun 2011 13:25:21 +0900
X-Google-Sender-Auth: RfZ4--OuZ8TnQcWwSz5ZbbWVtz4
Message-ID: <BANLkTin7afjph7=GO=K+QcBSaOUf7zJqSw@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
From: Kyungmin Park <kmpark@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>, Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Mark Lord <kernel@teksavvy.com>,
        James Bottomley <james.bottomley@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, Josef Bacik <josef@redhat.com>,
        tytso <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 11:06 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jun 02, 2011 at 01:52:12PM +0900, Kyungmin Park wrote:
>> On Wed, Dec 8, 2010 at 1:52 AM, Chris Mason <chris.mason@oracle.com> wrote:
>> > Excerpts from Christoph Hellwig's message of 2010-12-07 04:27:49 -0500:
>> >> On Fri, Nov 19, 2010 at 10:21:35AM -0500, Mark Lord wrote:
>> >> > >I really hate to rely on this third party hearsay (from all sides), and
>> >> > >have implement TRIM support in qemu now.  I'll soon install win7 and
>> >> > >will check out the TRIM patters myself.
>> >> >
>> >> > Excellent!
>> >>
>> >> I did a Windows 7 installation under qemu today, and the result is:
>> >
>> > Great, thanks for testing this.
>> >
>> >>
>> >>  - it TRIMs the whole device early during the installation
>> >>  - after that I see a constant stream of small trims during the
>> >>    installation.  It's using lots of non-contiguous ranges in a single
>> >>    TRIM command, with sizes down to 8 sectors (4k) for a single range.
>> >>  - after installation there's is some background-trimming going on
>> >>    even when doing no user interaction with the VM at all.
>>
>> Hi Lukas,
>>
>> Now FITRIM is based on user interaction. So how about to implement the
>> AUTO batched discard at kernel level?
>> Idea is same as windows, make a single thread and iterate the
>> superblocks and call the trim.
>
> Surely this the responsibility of a userspace daemon and a config
> file to decide and implement the background trim policy?

It seems to run as crond. BTW, what's config file? time based or behavior?
my rough idea to run at kernel level.

1. Block I/O aware notification.
2. Explicit filesystem call
3. user space request. (same as current)

Thank you,
Kyungmin Park
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
