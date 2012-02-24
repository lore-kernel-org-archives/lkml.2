Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2BXSDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:03:41 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56300 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755938Ab2BXSDk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:03:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.182.202.69 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
In-Reply-To: <4F47C9BF.10008@gmail.com>
References: <1330102448-19172-1-git-send-email-grant.likely@secretlab.ca> <4F47C9BF.10008@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 24 Feb 2012 11:03:18 -0700
X-Google-Sender-Auth: lfXylm3bnBJMDpCAmmvv8EoGYfc
Message-ID: <CACxGe6s-ZG3bqqvXj5J-XGVh7nQ+pf5UVMsm-L+ffMX+r3QBew@mail.gmail.com>
Subject: Re: [PATCH 1/2] irq_domain: Centralize definition of irq_dispose_mapping()
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonas Bonn <jonas@southpole.se>, sparclinux@vger.kernel.org,
        linux@openrisc.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 10:32 AM, David Daney <ddaney.cavm@gmail.com> wrote:
> On 02/24/2012 08:54 AM, Grant Likely wrote:
>>
>> Several architectures define their own empty irq_dispose_mapping().  Since
>> the irq_domain code is centralized now, there is little need to do so.
>>  This
>> patch removes them and creates a new empty copy when !CONFIG_IRQ_DOMAIN is
>> selected.
>>
>> The patch also means that IRQ_DOMAIN becomes selectable on all
>> architectures.
>>
>> Signed-off-by: Grant Likely<grant.likely@secretlab.ca>
>> Cc: Rob Herring<rob.herring@calxeda.com>
>> Cc: "David S. Miller"<davem@davemloft.net>
>> Cc: Jonas Bonn<jonas@southpole.se>
>> Cc: sparclinux@vger.kernel.org
>> Cc: linux@lists.openrisc.net
>> ---
>>  arch/openrisc/include/asm/prom.h |   10 +---------
>>  arch/sparc/include/asm/prom.h    |   10 +---------
>>  include/linux/irqdomain.h        |    5 ++++-
>>  include/linux/of_irq.h           |    4 +---
>>  4 files changed, 7 insertions(+), 22 deletions(-)
>>
>
> There is also a definition in arch/mips/include/asm/irq.h.
>
> Probably best to get rid of that one too.

I've got a separate patch which I posted today that enables IRQ_DOMAIN
on MIPS which does indeed remove that definition.

g.
