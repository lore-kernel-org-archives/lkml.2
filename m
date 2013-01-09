Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3AIRxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:53:39 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:38450 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057Ab3AIRxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:53:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5vEb=63jGsqfau1G=f54oqq17pc3ZzcpzhL7hQrtYhng@mail.gmail.com>
References: <20121030040237.GA10472@google.com>
	<1352003971-22278-1-git-send-email-yinghai@kernel.org>
	<CAE9FiQUn=bcgOLFzBwsBT1-O1poRNy9qYTb0w9EAya3_inKqAw@mail.gmail.com>
	<CAErSpo5Z57asEXbfesOjXMEPj4WM3YMbzQH3s-v_NBrnPNmuVQ@mail.gmail.com>
	<CAErSpo4LS7ShCbeOm1s9ob1MjPfUSWn9J96UHRBP6van54swQA@mail.gmail.com>
	<CAE9FiQV5x1S1BNHrXq0wMRDx7PD5BoCh3fOnq2vS_AOAGL8Rrw@mail.gmail.com>
	<CAErSpo5vEb=63jGsqfau1G=f54oqq17pc3ZzcpzhL7hQrtYhng@mail.gmail.com>
Date: Wed, 9 Jan 2013 09:53:35 -0800
X-Google-Sender-Auth: 1ynXZF2w1ZQS8yV6jRaeEkK-xxE
Message-ID: <CAE9FiQUxxjZmd3C33_ujSeL1EjcKHHSoGusQwfBD+Zd=cwCDZA@mail.gmail.com>
Subject: Re: [PATCH 0/8] PCI, ACPI, x86: Reserve fw allocated resource for
 hot-add root bus
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
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

On Wed, Jan 9, 2013 at 9:35 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> I don't know, that could be separated patcheset after we conclude
>> pci root bus hotplug support.
>
> The main reason I review patches before merging them is to identify
> issues that we can fix before they affect everybody.  It makes my life
> a lot easier if I don't have to keep track of pending unaddressed
> review comments.  Is there an advantage to waiting and doing this work
> later?
>
>>>> In general these look good.  My main concern is that they only touch
>>>> x86, without touching the similar code in frv, microblaze, mn10300,
>>>> and powerpc.

the reason why we need to change those codes for x86, we want to make it support
pci root bus hotplug. So it would be reasonable for us to align other
platform to x86
changes after pci root bus hotplug change is completely done.
Also I have for_dev_each_res patches rely on this patchset.
After those done, we can move the code from x86 to drivers/pci and delete
other arches code one by one.

Yinghai
