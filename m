Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2EJPkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:40:31 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:23260 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2EJPka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:40:30 -0400
Message-ID: <1336664428.2581.21.camel@lorien2>
Subject: Re: [PATCH v2 3/7] ACPI: Add _OST support for sysfs eject
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Toshi Kani <toshi.kani@hp.com>
Cc: shuahkhan@gmail.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 09:40:28 -0600
In-Reply-To: <1336587377.16730.150.camel@misato.fc.hp.com>
References: <1336507944-10219-1-git-send-email-toshi.kani@hp.com>
	 <1336507944-10219-4-git-send-email-toshi.kani@hp.com>
	 <1336581973.2498.15.camel@lorien2>
	 <1336587377.16730.150.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 12:16 -0600, Toshi Kani wrote:

> > > 
> > > Added macro definitions of _OST source events and status codes.
> > > Also renamed OSC_SB_CPUHP_OST_SUPPORT to OSC_SB_HOTPLUG_OST_SUPPORT
> > > since this _OSC bit is not specific to CPU hotplug. This bit is
> > > defined in Table 6-147 of ACPI 5.0 as follows.

Sorry. Missed that. It was in patch 7. Any reason why this feature is
split across 7 patches? Might be better to combine patches 1, 2, and 7
as it contains the infrastructure type code for _OST. Something to
consider.

There is no functional change with this patch set in the sense that _OST
doesn't get evaluated on platforms that don't support _OST, however
there is run-time change on all architectures with patches 3, 4, and 5.
There are couple of new kfree() calls introduced. Something to take a
closer to make sure it is safe in that path.

Also, what missing functionality does evaluating _OST add to the kernel?
What happens if OS continues to not evaluate _OST? It is an optional
method, looking for what is the value add?

-- Shuah

