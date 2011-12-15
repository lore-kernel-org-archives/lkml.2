Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793Ab1LOXaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:30:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47489 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab1LOXaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:30:05 -0500
MIME-Version: 1.0
In-Reply-To: <20111215192131.GE32002@google.com>
References: <1323954769-3918-1-git-send-email-ming.m.lin@intel.com>
 <1323954769-3918-5-git-send-email-ming.m.lin@intel.com> <20111215192131.GE32002@google.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 16 Dec 2011 00:29:44 +0100
Message-ID: <CAPXgP12mEC_p_7Xi-pzKwUCNV1=WTj7rW+upXK6gUbGwg3S2NA@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/4] ahci: support hot plug when port/controller is
 runtime suspended
To: Tejun Heo <tj@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, David Zeuthen <zeuthen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 20:21, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Dec 15, 2011 at 09:12:49PM +0800, Lin Ming wrote:
>> I use eSATA to test disk hot plug.
>> With previous 3 patches applied, disk hot plug does not wok
>> when ahci port/controller is runtime suspended.
>>
>> There are 2 cases we need to handle for hot plug:
>>
>> 1. port suspended, controller active
>>    Is IRQ need to be enabled for port to detect hot plug?
>>
>> 2. port suspended, controller suspended
>>    Will controller get a PME when hot plug happens?
>>
>> I'm still investigating hot plug support.
>>
>> Anyone has comment?
>
> SATA link detection requires hot wire and keeping wire hot takes
> power.

Oh, hardware in general just sucks. :)

> I think it's fair tradeoff to not support hotplug while
> powersaving is on.  We have warm plug mechanism (the SCSI rescan
> trigger via sysfs) after all.  It would be nice if things like that is
> somehow exported to userland in easy way tho (cc'ing Kay), but I
> frankly don't have much idea where that would fit.

Getting David in the loop. He might have an idea.

Kay
