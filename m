Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1J0MqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:46:14 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42846 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab1J0MqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:46:11 -0400
Subject: Re: kdump: No udev events for memory hotplug?
From: Dave Hansen <haveblue@us.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20111027073058.GA2422@osiris.boeblingen.de.ibm.com>
References: <1319645292.3321.24.camel@br98xy6r>
	 <20111026192449.GE355@redhat.com>
	 <20111027073058.GA2422@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 05:45:33 -0700
Message-ID: <1319719533.23600.55.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11102712-3534-0000-0000-000000F4D621
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 09:30 +0200, Heiko Carstens wrote:
> > Are any events generated for memory add?
> 
> Looks like uevents are only genereted when memory gets registered and
> unregistered, but not when when it gets set online or offline.
> To achieve that you would need to add similar code to
> store_mem_state()/memory_block_change_state() in drivers/base/memory.c
> like we have it already in store_online() in drivers/base/cpu.c 

Instead of doing it at that low a level, perhaps we should be generating
events when 'totalram_pages' changes.  That way, we'll also trigger
events when things like ballooning happen.

-- Dave

