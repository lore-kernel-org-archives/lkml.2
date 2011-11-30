Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab1K3ORk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:17:40 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45964 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1K3ORj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:17:39 -0500
References: <2F9D884C-6B95-4F81-8445-8056676B28D8@sonatest.com> <20111129185746.GA23986@ericsson.com> <F9D1750C-7D71-46D1-BE90-6D44CA26CB4F@gmail.com> <1322607769.23607.18.camel@groeck-laptop>
In-Reply-To: <1322607769.23607.18.camel@groeck-laptop>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <2BC37EDA-108A-49AE-9404-E4375A6CBDB9@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: Re: MFD: core assumes that all children are platform devices
Date: Wed, 30 Nov 2011 09:21:29 -0500
To: guenter.roeck@ericsson.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 29, 2011, at 18:02, Guenter Roeck wrote:

> On Tue, 2011-11-29 at 16:40 -0500, Jean-François Dagenais wrote:
>> 
>> Sent from my iPod
>> 
>> On 2011-11-29, at 1:57 PM, Guenter Roeck <guenter.roeck@ericsson.com> wrote:
>> 
>>> On Mon, Nov 28, 2011 at 11:23:00AM -0500, Jean-François Dagenais wrote:
>>>> Hi,
>>>> ...
>>> Looking at your proposed patch, I personally prefer my solution.
>> I'd like to see your patch... You mean to say that you changed your driver, or the mfd core? If it's your driver's probe function, then the problem still exists out there and imposing an extra device alloc simply as a container is in my opinion both a hassle and a waste of resource. At the very least, this task should be done by the mfd core. It still seems pointless though, when you can filter out which children are the ones to remove, like what my patch does.
> 
> I did not touch the mfd core; I am in general not in favor of changing
> core code if I can avoid it.
I generally agree, only this time I felt it was a flaw in mfd_remove_devices.
> 
> You can clone my driver from git://github.com/groeck/diolan.git. The mfd
> core code is in diolan-u2c-core.c. Not in shape for submission, and the
> SPI part is completely untested, but the MFD code should be ok.
Thanks.
> 
>>> Of course it would be nice
>>> if it was documented that MFD parent devices MUST be dedicated (platform) devices and must not
>>> have any non-MFD child devices. This would be a simple documentation patch and avoid making
>>> assumptions on MFD child device removal.
>> Well the patch uses already present assumptions, it just checks
>> for them.
>> 
> The assumption I referred to was your assumption or expectation that
> mfd_remove_devices() only removes a subset of child devices, not all of
> them.
I think it's safe to say that the current non-documented assumption is that all children ARE cells. Which
I don't even believe is intentional.

When you think about it, in general the inverse of a API (i.e. add/remove, register/unregister)
should make all the efforts necessary to undo what IT knows it did, in this case, add_devices added
cells, but remove_devices removes ALL child devices. This is a mistake in terms of API sanity and it's
exactly what my patch addresses.
> 
>> What's good is that my patch doesn't prevent you from using a container platform device either.
>> 
>> We'll see what Samuel thinks...
> 
> Agreed. Either way, I think I'll stick with my approach - if nothing
> else for backward compatibility. I would not want to have a driver which
> depends on changed semantics of a kernel API function call.
Fair enough, I would do the same in your position.
> 
> Thanks,
> Guenter
> 
> 

