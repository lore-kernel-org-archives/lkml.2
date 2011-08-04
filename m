Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab1HDQb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:31:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54355 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1HDQbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:31:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110804052239.GA12523@kroah.com>
References: <CAECXXi5kZJk+86-2SJRWqMUCj31cL4tb1qTbaueMxeEg2VFcDw@mail.gmail.com>
	<20110803233426.GA18216@kroah.com>
	<CAECXXi5pkRAY_dVSwSUrj5RQzsJ2YVx6xXovzpuRDOEOq92s9g@mail.gmail.com>
	<20110804052239.GA12523@kroah.com>
Date: Thu, 4 Aug 2011 12:31:52 -0400
Message-ID: <CAECXXi4nya8pf-XWCBQcLU1YCM8VDi8Nruu_jUjdNjDm9+8EVQ@mail.gmail.com>
Subject: Re: [PATCH] nbd: nbd sysfs framework
From: Paul Clements <paul.clements@us.sios.com>
To: Greg KH <greg@kroah.com>
Cc: andrew morton <akpm@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        nbd-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 1:22 AM, Greg KH <greg@kroah.com> wrote:
> On Wed, Aug 03, 2011 at 10:17:04PM -0400, Paul Clements wrote:
>> On Wed, Aug 3, 2011 at 7:34 PM, Greg KH <greg@kroah.com> wrote:
>> > On Wed, Aug 03, 2011 at 07:15:51PM -0400, Paul Clements wrote:
>> >> Description: The patch creates a new sysfs entry framework for nbd.
>> >
>> > Why?  What does this buy us except an increase in code size for no added
>> > benifit?  You seem to be stripping out the driver layer here and using
>> > "raw" kobjects, why?
>>
>> Not sure what I was thinking...just in a hurry, I think.
>>
>> Is the following a little better?
>
> I don't know, I still fail to understand _why_ this patch is needed.
>
> Why are you doing this?  What is the goal?  What is wrong with the
> existing code that it doesn't work for you?

So, first, the point of the framework, as I'm calling it, is (and
several other drivers do similar things...) to avoid the whole kobj to
device to gendisk to driver-specific struct walking in every single
sysfs handler routine. So I've created the meta-structure
nbd_sysfs_entry to allow me to have two routines that do the walking
(and any other common tasks) and then hand off (via function pointer)
to the actual handler for the particular sysfs entry. Consequently,
most of the sysfs entry handlers are just one line long.

The second goal is to avoid adding more ioctls to nbd, as it's already
got enough. Eventually, we may even reduce the number of ioctls in
nbd. Yeah, sysfs is not a panacea, but it tends to be easier to
describe and work with and avoids some of the cross-platform headaches
of ioctls.

Thirdly, support for FUA and FLUSH (and other features) can be added
once we've exposed the nbd device flags via sysfs. This is being
requested by nbd users and has been discussed on nbd-general.

Thanks again for your feedback. I'll add the documentation and other
bits that you asked about.

--
Paul
