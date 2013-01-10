Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab3AJAez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:34:55 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:38981 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab3AJAex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:34:53 -0500
MIME-Version: 1.0
In-Reply-To: <5274779.gJQ3WSr6QB@vostro.rjw.lan>
References: <20121030040237.GA10472@google.com> <CAErSpo6qX3ih9DXLqxqJw141OAeTFu0YfSih6LyD0sd2gS-Vyg@mail.gmail.com>
 <CAE9FiQWm6=1JXA7EB-a0aqgTFQ5ZeCxz_gAU+ABUce1Ovn1Siw@mail.gmail.com> <5274779.gJQ3WSr6QB@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 Jan 2013 17:34:32 -0700
Message-ID: <CAErSpo7QBNzaMKOGpkrPxop+WN+RMAoeOBUPiFDi9HFyH+UoOQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] PCI, ACPI, x86: Reserve fw allocated resource for
 hot-add root bus
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 1:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, January 09, 2013 11:01:39 AM Yinghai Lu wrote:
>> On Wed, Jan 9, 2013 at 10:39 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> >> the reason why we need to change those codes for x86, we want to make it support
>> >> pci root bus hotplug. So it would be reasonable for us to align other
>> >> platform to x86
>> >> changes after pci root bus hotplug change is completely done.
>> >
>> > OK, I opened https://bugzilla.kernel.org/show_bug.cgi?id=52531 as a
>> > way to keep track of this consistency issue and merged
>> > pci/yinghai-survey-resources to my -next branch.
>>
>> Thanks a lot. will send other pci root bus hotplug out.
>>
>> question: now Rafael's tree has acpi-scan branch and it touches pci-root.c.
>>
>> so is it ok for me to base patches on your pci/next and his pm/acpi-scan?
>> how?
>> can you two have some arrangement like you pulling Rafael's branch?
>
> My acpi-scan branch is not going to be rebased going forward, so it can be
> pulled from safely if that helps.

I'm happy to do that, but it is outside the scope of my limited git
experience.  My guess is that I should do this (doing the pull into a
branch which I later merge into my -next branch):

  $ git checkout -b pci/yinghai-survey-resources+acpi-scan
pci/yinghai-survey-resources
  $ git pull --no-ff --log
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
acpi-scan
  $ vi drivers/acpi/pci_root.c    # resolve conflicts
  $ git add drivers/acpi/pci_root.c
  $ git commit

  $ git checkout next
  $ git merge --no-ff --log pci/yinghai-survey-resources+acpi-scan

Is that reasonable?  This won't cause issues when both Rafael and I
ask Linus to pull from our trees later?

Bjorn
