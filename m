Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab2BFKSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:18:35 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58990 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2BFKSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:18:34 -0500
MIME-Version: 1.0
X-Originating-IP: [87.66.62.139]
In-Reply-To: <201202051204.38717.rjw@sisk.pl>
References: <1328227065-22045-1-git-send-email-venki@google.com>
	<CAN5iSWo-n7OER4i1tPoeGBhY_RY-nX=7n4B3mFv1f0JK074bhQ@mail.gmail.com>
	<20120205035057.GA4948@gs62>
	<201202051204.38717.rjw@sisk.pl>
Date: Mon, 6 Feb 2012 11:18:33 +0100
Message-ID: <CAORVsuVCYp+Fmfaje-UDnv1=x0PqApML6Jb-Z6EG0425SuREMg@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH] CPU C-state breakage with PM Qos change
From: Jean Pihet <jean.pihet@newoldbits.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, markgross@thegnar.org
Cc: Kevin Hilman <khilman@ti.com>, Venkatesh Pallipadi <venki@google.com>,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael, Mark,

On Sun, Feb 5, 2012 at 12:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, February 05, 2012, mark gross wrote:
>> On Fri, Feb 03, 2012 at 03:04:43PM +0100, Pihet-XID, Jean wrote:
>> > Looping in linux-pm
>> >
>> > On Fri, Feb 3, 2012 at 1:14 AM, Venkatesh Pallipadi <venki@google.com> wrote:
>> > > Looks like change "PM QoS: Move and rename the implementation files"
>> > > made pm_qos depend on CONFIG_PM which depends on
>> > > PM_SLEEP || PM_RUNTIME
>> > >
>> > > That breaks CPU C-states with kernels not having these CONFIGs, causing CPUs
>> > > to spend time in Polling loop idle instead of going into deep C-states,
>> > > consuming way way more power. This is with either acpi idle or intel idle
>> > > enabled.
>> > >
>> > > Either CONFIG_PM should be enabled with any pm_qos users or
>> > > the !CONFIG_PM pm_qos_request() should return sane defaults not to break
>> > > the existing users. Here's is the patch for the latter option.
>> > I think the real question is whether PM QoS should be functional in
>> > all cases (as is ACPI) or whether only if certain options are set
>> > (CONFIG_PM).
>> > In the current code if CONFIG_PM is not enabled, a dummy PM QoS API is
>> > provided as function stubs in order for the build to succeed.
>> >
>> > Rafael, Mark,
>> > What do you think? Should PM QoS be enabled in all cases? Are there
>> > any known dependencies with CONFIG_PM?
>>
>> Yes I do think pm_qos interfaces should be enabled all the time and be
>> independent of CONFIG_PM.  Also, I still am not a fan of the renaming
>> patch but, as the argument for and against renaming cannot be based on
>> quantifiable things I've chosen not to let it bother me.
>>
>> I think Venki's change is a band aid and we should fix it right by not
>> having a dependency on config_pm for the interface to behave.
>>
>> I'll take a look at why there is now a dependency before I have more to
>> say.
>
> In kernel/power/Makefile:
>
> obj-$(CONFIG_PM)                += main.o qos.o
>
> I guess that explains things. :-)
Initially I thought we should have a way of disabling the feature on
some (minimal) kernels and so thought CONFIG_PM was the option to use.

> It's quite easy to make qos.o be independent of CONFIG_PM, in which case the
> code added by Venki can be removed, so patches welcome (for 3.4, though).
I am working on it, more to come soon.

>
> Thanks,
> Rafael

Thanks,
Jean

> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/linux-pm
