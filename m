Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab1BNVc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 16:32:58 -0500
Received: from smtp.nokia.com ([147.243.1.47]:58998 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1BNVcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 16:32:55 -0500
Message-ID: <4D599F60.4010800@iki.fi>
Date: Mon, 14 Feb 2011 23:32:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101123 SeaMonkey/2.0.11
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH -next] PCI: fix tlan build when CONFIG_PCI is not enabled
References: <20110214181137.ee8d4c08.sfr@canb.auug.org.au> <20110214122750.e1e03bc8.randy.dunlap@oracle.com>
In-Reply-To: <20110214122750.e1e03bc8.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_PCI is not enabled, tlan.c has a build error:
> drivers/net/tlan.c:503: error: implicit declaration of function 'pci_wake_from_d3'
> 
> so add an inline function stub for this function to pci.h when
> PCI is not enabled, similar to other stubbed PCI functions.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>

Hi Randy,

I think this issue in tlan driver was caused by my recent patch which
added the suspend/resume support to tlan:

<URL:http://marc.info/?l=linux-netdev&m=129564436110754&w=3>

There apparently are tlan cards which are EISA (not PCI) which I forgot
when writing the patch. The suspend/resume has been only tested with PCI
as I have no EISA bus (let alone EISA tlan card!).

I'm going to send a fix to the tlan driver in any case.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
