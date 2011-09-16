Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1IPQMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 12:12:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31311 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab1IPQMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 12:12:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=jtaovSi9b6AgqQwSKIyuDrwqX4jJ+PZp++2snAo7ga0gcJbpqt2Wjq4ovB+UmS+xY
	Epi5J0HCbdPhV8EIUQSbg==
MIME-Version: 1.0
In-Reply-To: <20110916133220.GA2642@hmsreliant.think-freely.org>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1316117318-22027-1-git-send-email-nhorman@tuxdriver.com> <20110916083646.GA30915@suse.de>
 <20110916105716.GA32672@hmsreliant.think-freely.org> <20110916132319.GC8973@suse.de>
 <20110916133220.GA2642@hmsreliant.think-freely.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 16 Sep 2011 10:12:11 -0600
Message-ID: <CAErSpo7RB5Fx-Epv2qUKiquOpXec7yjb0GT0ShUQWgkYYF7gMQ@mail.gmail.com>
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v2)
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci@vger.kernel.org]

On Fri, Sep 16, 2011 at 7:32 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Fri, Sep 16, 2011 at 03:23:19PM +0200, Greg KH wrote:
>> On Fri, Sep 16, 2011 at 06:57:16AM -0400, Neil Horman wrote:
>> > On Fri, Sep 16, 2011 at 10:36:46AM +0200, Greg KH wrote:
>> > > On Thu, Sep 15, 2011 at 04:08:38PM -0400, Neil Horman wrote:
>> > > > +static struct kobj_type msi_irq_ktype = {
>> > > > +       .sysfs_ops = &msi_irq_sysfs_ops,
>> > > > +       .default_attrs = msi_irq_default_attrs,
>> > > > +};
>> > >
>> > > You still haven't successfully removed the kobject associated with this
>> > > kobj_type.  Otherwise you would have seen the error messages in the
>> > > kernel log and fixed up what it told you to fix.
>> > >
>> > > Please do so.
>> > >
>> > Well, I'm not using kobject_del, you're right, I'm just using a kobject_put, and
>> > I swear I'm not getting any error messages about it:
>>
>> Then you really are not ever freeing that kobject, so there's a
>> reference counting bug in your code which you need to fix.
>>
>> You will notice the real problem once you try to finally release that
>> kobject, trust me :)
>>
> Ok, copy that, I'll continue to dig, thanks!
> Neil
>
>> greg k-h
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
