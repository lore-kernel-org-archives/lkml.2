Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3AHS1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:27:30 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:49922 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab3AHS12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:27:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4LS7ShCbeOm1s9ob1MjPfUSWn9J96UHRBP6van54swQA@mail.gmail.com>
References: <20121030040237.GA10472@google.com>
	<1352003971-22278-1-git-send-email-yinghai@kernel.org>
	<CAE9FiQUn=bcgOLFzBwsBT1-O1poRNy9qYTb0w9EAya3_inKqAw@mail.gmail.com>
	<CAErSpo5Z57asEXbfesOjXMEPj4WM3YMbzQH3s-v_NBrnPNmuVQ@mail.gmail.com>
	<CAErSpo4LS7ShCbeOm1s9ob1MjPfUSWn9J96UHRBP6van54swQA@mail.gmail.com>
Date: Tue, 8 Jan 2013 10:27:25 -0800
X-Google-Sender-Auth: f_nCh1eK9eLLRU546q0TO2ojHp4
Message-ID: <CAE9FiQV5x1S1BNHrXq0wMRDx7PD5BoCh3fOnq2vS_AOAGL8Rrw@mail.gmail.com>
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

On Tue, Jan 8, 2013 at 9:57 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> I'm really sorry that it's taken me so long to get to these.
>>
>> I applied these to my pci/yinghai-survey-resources branch.  I
>> re-ordered the last two and reworked some of the changelogs.
>
> To be clear about this, the pci/yinghai-survey-resources branch I
> mentioned is a staging branch that just gets build test coverage.  I
> don't plan to actually merge this or put it into -next until the
> questions below are resolved.
>
> My inclination, until I'm persuaded otherwise, is to wait for patches
> that preserve the similarities among these architectures.

I don't know, that could be separated patcheset after we conclude
pci root bus hotplug support.

>
>> In general these look good.  My main concern is that they only touch
>> x86, without touching the similar code in frv, microblaze, mn10300,
>> and powerpc.
>>
>> This code (pcibios_resource_survey(), pcibios_assign_resources(),
>> pcibios_allocate_resources(), pcibios_allocate_bus_resources()) was
>> obviously copied from x86 originally, and I'd like to preserve the
>> similarity between them.  It would be even better to refactor it so
>> it's actually *shared*, but I don't think that's a requirement right
>> now.

yes, should be moved to drivers/pci

>>
>> If we allow it to diverge now, it will make it harder to refactor and
>> harder to notice when bug fixes should be applied to all of them.  For
>> example, looking at pcibios_allocate_resources(), commit 575939cf5
>> added some SR-IOV support to x86.  Should similar code be added for
>> frv, microblaze, mn10300, and powerpc?

should be treated the same.

>>
>> Anybody else have thoughts on this?
>>
>> Bjorn
