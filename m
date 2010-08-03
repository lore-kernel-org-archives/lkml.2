Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab0HCS5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:57:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40963 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab0HCS5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:57:37 -0400
Date: Tue, 3 Aug 2010 11:55:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mark Knecht <markknecht@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Paul Check <paul@thechecks.ca>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
Message-Id: <20100803115553.e4c51104.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTi=bKn3t8eD=n8tDeZrn-mXsEzFHGj46-Z5U9EGA@mail.gmail.com>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
	<4C317C04.20500@kernel.org>
	<AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>
	<4C32CE50.6010501@kernel.org>
	<AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>
	<4C341598.6040004@kernel.org>
	<AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>
	<4C34A1D5.1090202@kernel.org>
	<AANLkTilgQSu3qi7qoTtjnV22r-8Sh1hbDAB_nlPImWNt@mail.gmail.com>
	<4C34B8BE.5080504@kernel.org>
	<AANLkTilDbrA6lLPSOAtA8_4mLNkUZibHweTliqU5jd03@mail.gmail.com>
	<4C44BD42.3030904@kernel.org>
	<7141c88bc8c27f26c2187252c0594318.squirrel@thechecks.ca>
	<4C45AF40.7030800@kernel.org>
	<AANLkTinxDjPCk46eItZrXziTbf6efqvNNNTbkZDXIbns@mail.gmail.com>
	<4C483BF4.3090006@kernel.org>
	<AANLkTinwJLE=jjwG5zL8UBO91tzDpX36_W9GORKag8RK@mail.gmail.com>
	<20100803114105.7f199878.randy.dunlap@oracle.com>
	<AANLkTi=bKn3t8eD=n8tDeZrn-mXsEzFHGj46-Z5U9EGA@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C586699.008A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 11:47:25 -0700 Mark Knecht wrote:

> On Tue, Aug 3, 2010 at 11:41 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Mon, 2 Aug 2010 15:07:11 -0700 Mark Knecht wrote:
> >
> >> On Thu, Jul 22, 2010 at 5:39 AM, Tejun Heo <tj@kernel.org> wrote:
> >>
> >> Hi Tejun,
> >>    I'm finally home and trying to get back to this. I'm really a bad
> >> programmer so I don't know what I've done wrong but it seems patch
> >> isn't happy with me.
> >>
> >> c2stable linux # patch --dry-run -p1 <../ata_piix-sidpr-lock.patch
> >> patching file drivers/ata/ata_piix.c
> >> patch: **** malformed patch at line 13:
> >
> > Whenever the patch file was saved on this system, line 13 of it was
> > split (probably by an email client).  Whenever I see this, I just
> > join (merge) that line and the next one and try again... sometimes
> > several lines are malformed and have to be fixed like this.
> >
> 
> Randy,
>    Could very well be what happened. I added line 13 (the printk) by hand
> 
> <SNIP - ORIGINAL PATCH FILE>
> struct piix_host_priv {
>        const int *map;
>        u32 saved_iocfg;
> +       spinlock_t sidpr_lock;  /* FIXME: remove once locking in EH is fixed */
>         void __iomem *sidpr;
> };
> 
> <SNIP - MY CHANGE BY HAND>
> struct piix_host_priv {
>        const int *map;
>        u32 saved_iocfg;
> +       spinlock_t sidpr_lock;  /* FIXME: remove once locking in EH is fixed */
> +       printk("MWK - ata_sidpr patch applied!\n");
>        void __iomem *sidpr;
> };
> 
> Maybe I should have just put it on the same line as the previous
> spinlock command?
> 
> I'll play with it and see if I can get it working.


Ah, so you added a line to a patch file.  That means that the patch
block header must be changed from something like this:

@@ -964,12 +968,15 @@

to like this:

@@ -964,12 +968,16 @@

Any text following the second "@@" is just a comment so it does not matter.

The ,12  ,15   ,16   are all line counts. The ",12" is the number of lines
in the before version of the patch.  The ",15" or ",16" is the number of lines
in the after version of the patch, so you would need to increase it by 1 if
you added one line.   Or you can just put the printk on the same line as another
part of the patch and it won't matter.  :)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
