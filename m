Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab2BXRed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:34:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45566 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005Ab2BXReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:34:31 -0500
Message-ID: <4F47C9BF.10008@gmail.com>
Date: Fri, 24 Feb 2012 09:32:47 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonas Bonn <jonas@southpole.se>, sparclinux@vger.kernel.org,
        linux@openrisc.net
Subject: Re: [PATCH 1/2] irq_domain: Centralize definition of irq_dispose_mapping()
References: <1330102448-19172-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1330102448-19172-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 08:54 AM, Grant Likely wrote:
> Several architectures define their own empty irq_dispose_mapping().  Since
> the irq_domain code is centralized now, there is little need to do so.  This
> patch removes them and creates a new empty copy when !CONFIG_IRQ_DOMAIN is
> selected.
>
> The patch also means that IRQ_DOMAIN becomes selectable on all architectures.
>
> Signed-off-by: Grant Likely<grant.likely@secretlab.ca>
> Cc: Rob Herring<rob.herring@calxeda.com>
> Cc: "David S. Miller"<davem@davemloft.net>
> Cc: Jonas Bonn<jonas@southpole.se>
> Cc: sparclinux@vger.kernel.org
> Cc: linux@lists.openrisc.net
> ---
>   arch/openrisc/include/asm/prom.h |   10 +---------
>   arch/sparc/include/asm/prom.h    |   10 +---------
>   include/linux/irqdomain.h        |    5 ++++-
>   include/linux/of_irq.h           |    4 +---
>   4 files changed, 7 insertions(+), 22 deletions(-)
>

There is also a definition in arch/mips/include/asm/irq.h.

Probably best to get rid of that one too.

David Daney
