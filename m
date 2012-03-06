Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab2CFHwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:52:33 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51463 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758189Ab2CFHwc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:52:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.182.44.68 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
In-Reply-To: <20120306052849.GC19454@kroah.com>
References: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
 <20120305214747.GA9425@kroah.com> <CACxGe6samH6-o9Ye7h7Wpj8GztxvFpWDgcEvtx2ey+YRGYm_9g@mail.gmail.com>
 <20120305221528.GA11935@kroah.com> <CACxGe6vB3cHSNtLrLdrWmD3dZk-+eQY4p=X46qqxp0C2a8V6vg@mail.gmail.com>
 <20120306052849.GC19454@kroah.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 6 Mar 2012 00:52:12 -0700
X-Google-Sender-Auth: 9ZqvqFmqdT1JUFbrwPqT-gjE61s
Message-ID: <CACxGe6uQCUGyj4ib7da0iTSWRcGGRftO1WzpUOKkbgfL84Ojjw@mail.gmail.com>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 10:28 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Mar 05, 2012 at 05:08:30PM -0700, Grant Likely wrote:
>> On Mon, Mar 5, 2012 at 3:15 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Mon, Mar 05, 2012 at 03:09:27PM -0700, Grant Likely wrote:
>> >> On Mon, Mar 5, 2012 at 2:47 PM, Greg Kroah-Hartman
>> >> <gregkh@linuxfoundation.org> wrote:
>> >> > On Mon, Mar 05, 2012 at 08:47:41AM -0700, Grant Likely wrote:
>> >> >> --- a/include/linux/device.h
>> >> >> +++ b/include/linux/device.h
>> >> >> @@ -587,6 +587,10 @@ struct device_dma_parameters {
>> >> >>   * @mutex:   Mutex to synchronize calls to its driver.
>> >> >>   * @bus:     Type of bus device is on.
>> >> >>   * @driver:  Which driver has allocated this
>> >> >> + * @deferred_probe: entry in deferred_probe_list which is used to retry the
>> >> >> + *           binding of drivers which were unable to get all the resources
>> >> >> + *           needed by the device; typically because it depends on another
>> >> >> + *           driver getting probed first.
>> >> >>   * @platform_data: Platform data specific to the device.
>> >> >>   *           Example: For devices on custom boards, as typical of embedded
>> >> >>   *           and SOC based hardware, Linux often uses platform_data to point
>> >> >> @@ -646,6 +650,7 @@ struct device {
>> >> >>       struct bus_type *bus;           /* type of bus device is on */
>> >> >>       struct device_driver *driver;   /* which driver has allocated this
>> >> >>                                          device */
>> >> >> +     struct list_head        deferred_probe;
>> >> >>       void            *platform_data; /* Platform specific data, device
>> >> >>                                          core doesn't touch it */
>> >> >>       struct dev_pm_info      power;
>> >> >
>> >> > This can go into the "struct device_private" structure instead, right?
>> >> > That would be better to ensure that no non-driver-core code ever touches
>> >> > this thing.
>> >>
>> >> I don't see any reason why not.  I'll make the change and repost.
>> >
>> > If you are going to repost, care to fix up your multi-line comment
>> > blocks to follow the "standard" way of doing it?
>> >
>> > That saves me doing the follow-on patch to do it myself :)
>>
>> Yeah, I can do that.
>>
>> Actually, if you're okay with this version other than the private data
>> change, could you pick up this version (it's actually received
>> testing) and I'll provide follow up patches to fix up the issues
>> pointed out by you and Arnd.
>
> Yes, I can, and I might as well fix up the private thing myself and the
> comments when I do that, I'll cc: you on that.  I have a flight tomorrow
> so I might get the chance to do it then.

Alright; that works for me.  :-)

g.
