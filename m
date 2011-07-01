Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab1GAXH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 19:07:57 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:41553 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657Ab1GAXH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 19:07:56 -0400
Subject: Re: [PATCH 0/5 v2] PCI: fix cardbus and sriov regressions
From: Ben Hutchings <bhutchings@solarflare.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, socketcan@hartkopp.net, bhelgaas@google.com,
        linux@dominikbrodowski.net
In-Reply-To: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Sat, 02 Jul 2011 00:07:48 +0100
Message-ID: <1309561669.2693.20.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2011 23:07:55.0155 (UTC) FILETIME=[B5D5BE30:01CC3843]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18232.005
X-TM-AS-Result: No--3.084600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 16:47 -0700, Ram Pai wrote:
> The following patch-set fixes regressions caused by:
> 
> the commit "PCI: update bridge resources to get more big ranges when allocating space (again)"
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da7822e5ad71ec9b745b412639f1e5e0ba795a20
> 
> patch 1/5: fix calculation of additional resource size for hotplug bridges
> patch 2/5: ability to resize assigned pci-resource
> patch 3/5: make SRIOV BARs resources optional
> patch 4/5: make cardbus bridge resources optional
> patch 5/5: code and terminology cleanup
> 
> The regression was caused on some platforms with limited i/o and memory
> resources, the optional resources were allocated ahead of required resources,
> thus starving the latter. The patchset ensures that all the required resources
> are satisfied before any optional resources are satisfied.

This certainly fixes the problem I originally reported: all the basic
BARs for devices with SR-IOV enabled are mapped.

When testing this, I noticed that a BAR which we fail to allocate space
for may be left configured with an address range that overlaps that of
other BARs.  However, that does not appear to be a regression.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

