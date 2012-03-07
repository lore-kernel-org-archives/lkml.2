Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab2CGG6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:58:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51905 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2CGG6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:58:12 -0500
MIME-Version: 1.0
In-Reply-To: <CABhMZUU_YNMXAU0Mr5zQMzxrk_XkFzk1HrwAN0SQxDf8n+F9kA@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<CABhMZUU_YNMXAU0Mr5zQMzxrk_XkFzk1HrwAN0SQxDf8n+F9kA@mail.gmail.com>
Date: Tue, 6 Mar 2012 22:58:11 -0800
X-Google-Sender-Auth: T9Fqq4Zzt1BX1J7Nwjqh-FP2kFc
Message-ID: <CAE9FiQVNYWnZzfdNsW38P4vsD1ZpXeA+SwqqDK45SZAAphz_6A@mail.gmail.com>
Subject: Re: [PATCH 00/23] PCI, x86: pci root bus hotplug support
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bjorn.helgaas@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 8:44 PM, Bjorn Helgaas <bjorn.helgaas@gmail.com> wrote:
> On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> Does this series support hot-add, too, or just removal?
>
> If it is intended to support hot-add, I didn't see any support for
> _CBA, which I *think* is the way hotplug-capable host bridges are
> required to report MMCONFIG areas.

to make the whole hotplug working with intel new cpus with IIO,
in addition to physical cpu and memory hotplug, will still need
a. ioapic controller hotplug
b. intr-remapping hotplug
c. intel-iommu hotplug
d. mmconf support.
e. root bus hotplug

this patch set is only involved with partitally root bus removal/add back.
and assume ioapic, intr-remap, intel-iommu, and mmconf related are
working from early initialization.

that will help us to help to fix bugs like devices refcount leaking.

Yinghai
