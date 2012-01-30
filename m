Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2A3Sve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:51:34 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53240 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2A3Svb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:51:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5QYvx6dtL4NqW4Pu29HXbS-kcTq-GKvpJO8AJ6vRYeBw@mail.gmail.com>
References: <1327718971-9598-1-git-send-email-yinghai@kernel.org>
	<1327718971-9598-10-git-send-email-yinghai@kernel.org>
	<CAErSpo5QYvx6dtL4NqW4Pu29HXbS-kcTq-GKvpJO8AJ6vRYeBw@mail.gmail.com>
Date: Mon, 30 Jan 2012 10:51:30 -0800
X-Google-Sender-Auth: VLiAKYVGZlvtLJSUz4mu7IVEiZA
Message-ID: <CAE9FiQWLRvXXyeEhvW+n55_Q+P88xyfgLCKwyK8d4tg679-8gg@mail.gmail.com>
Subject: Re: [PATCH 09/13] PCI: Probe safe range that we can use for
 unassigned bridge.
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 7:59 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Jan 27, 2012 at 6:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Try to allocate from parent bus busn_res. if can not find any big enough, will try
>> to extend parent bus top. even the extending is through allocating, after allocating
>> will pad the range to parent buses top.
>>
>> When extending happens, We will record the parent_res, so could use it as stopper
>> for really extend/shrink top later.
>>
..
>
> I think what this does is "find the largest available area in 'res'."
> That *sounds* sort of useful (and like something that could go
> somewhere more generic than drivers/pci/probe.c), but there's no
> locking, so we don't have any assurance that the area we find will
> *remain* available.

two usages:
1. init booting : should be safe, that is sequential scanning
2. hotplug: we should have overall lock somewhere for it?

>
> Since the caller should deal with failure anyway (if the largest
> available area is no longer available by the time it gets around to
> allocating it), it seems like it'd be better to fold this into the
> caller somehow.



>> +               if (ret == 0) {
>> +                       /* release busn_res */
>
> Comments like this that repeat exactly what the next line of code does
> without adding any useful information are unnecessary and distracting.

ok, will remove them.

Yinghai
