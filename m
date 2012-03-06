Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031573Ab2CFXIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 18:08:32 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41461 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031456Ab2CFXIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 18:08:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ddaney.cavm@gmail.com designates 10.60.12.8 as permitted sender) smtp.mail=ddaney.cavm@gmail.com; dkim=pass header.i=ddaney.cavm@gmail.com
Message-ID: <4F5698EC.1080502@gmail.com>
Date: Tue, 06 Mar 2012 15:08:28 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mips@linux-mips.org
Subject: Re: [PATCH] irq_domain/mips: Allow irq_domain on MIPS
References: <1330100995-19823-1-git-send-email-grant.likely@secretlab.ca> <20120306195700.GK4519@linux-mips.org>
In-Reply-To: <20120306195700.GK4519@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 11:57 AM, Ralf Baechle wrote:
> On Fri, Feb 24, 2012 at 09:29:55AM -0700, Grant Likely wrote:
>
>> This patch makes IRQ_DOMAIN usable on MIPS.  It uses an ugly workaround
>> to preserve current behaviour so that MIPS has time to add irq_domain
>> registration to the irq controller drivers.  The workaround will be
>> removed in Linux v3.6
>
> Looking good, Ack.
>
> Is there any good example for the changes that need to be done to
> irq controller drivers?
>

Well it only affects things that have USE_OF, so most mips things will 
not need to do anything as they don't USE_OF.

But for those that do USE_OF, you have to call one or more of the 
irq_domain_add_*() functions.

Slightly off topic:  My OCTEON patch set tries to do this, but hasn't 
met with quite as much enthusiasm as I would have liked...

David Daney

> Thanks,
>
>    Ralf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

