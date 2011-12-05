Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab1LEFlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 00:41:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1LEFlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 00:41:18 -0500
Date: Sun, 4 Dec 2011 21:42:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Jenkins <alan.christopher.jenkins@googlemail.com>
Cc: Daniel Drake <dsd@laptop.org>, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com, tglx@linutronix.de, dilinger@queued.net,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH resend 2] x86, olpc-xo15-sci: Enable lid close wakeup
 control through sysfs
Message-Id: <20111204214248.d04c1bbc.akpm@linux-foundation.org>
In-Reply-To: <4EDB5E70.5000209@googlemail.com>
References: <20111129222447.E56959D401E@zog.reactivated.net>
	<20111130151551.97371bdb.akpm@linux-foundation.org>
	<4EDB5E70.5000209@googlemail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Dec 2011 11:50:08 +0000 Alan Jenkins <alan.christopher.jenkins@googlemail.com> wrote:

> On 01/-10/37 20:59, Andrew Morton wrote:
> > Let me fix that for you.
> >
> > --- a/arch/x86/platform/olpc/olpc-xo15-sci.c~x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix
> > +++ a/arch/x86/platform/olpc/olpc-xo15-sci.c
> > @@ -58,7 +58,8 @@ static ssize_t lid_wake_on_close_store(s
> >   				       const char *buf, size_t n)
> >   {
> >   	unsigned int val;
> > -	if (!sscanf(buf, "%u",&val) == 1)
> > +
> > +	if (sscanf(buf, "%u",&val) != 1)
> >   		return -EINVAL;
> >
> >   	set_lid_wake_behavior(!!val);
> >
> > It's kinda irritating that this will cheerfully accept bogus input of
> > the form "42foo".  This happens about eleven billion times in sysfs
> > write() handlers but afaik we've never implemented a nice
> > sysfs_int_from_buffer() thingy which handles all the possible errors.
> 
> I thought there was.
> 
> strict_strtoul() ?
> 

(that was replaced by kstrto*())

I was more thinking of the trailing \n problem.  But ksrtto*() appears
to treat "42\n" as "42" so yup, that's good.

(One could argue that a sysfs string handler should also strip leading
and trailing white space.  I'd disagree!)

