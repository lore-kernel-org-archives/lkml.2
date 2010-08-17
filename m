Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0HQDWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 23:22:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:53745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab0HQDWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 23:22:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,380,1278313200"; 
   d="scan'208";a="648418179"
Subject: Re: [PATCH 1/4] [Patch-next] ACPI, APEI, ERST Fix the wrong
 checking of Serialization Header's length
From: Huang Ying <ying.huang@intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
In-Reply-To: <4C69F094.1040607@np.css.fujitsu.com>
References: <4C69DDB5.6060103@np.css.fujitsu.com>
	 <1282008836.2744.1490.camel@yhuang-dev>
	 <4C69F094.1040607@np.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 11:22:24 +0800
Message-ID: <1282015344.2744.1500.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 10:14 +0800, Jin Dongming wrote:
> > I don't think it is necessary to change the header definition, and
> > seri_header is not a good name for me.
> Why I added this structure here is that I don't want to do following checking.
> For example,
> 	if (header_length != 0x0c) {
> 		...
> 	}

This can be:

 static int erst_check_table(struct acpi_table_erst *erst_tab)
 {
-       if (erst_tab->header_length != sizeof(struct acpi_table_erst))
+       if (erst_tab->header_length !=
+           (sizeof(struct acpi_table_erst) - sizeof(erst_tab->header)))

like Yinghai has been done.

Best Regards,
Huang Ying


