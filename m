Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0HPMhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:37:04 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:58120 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab0HPMhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:37:00 -0400
Message-ID: <4C6930EA.8030406@neli.hopto.org>
Date: Mon, 16 Aug 2010 14:36:58 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Alexandre Bounine <alexandre.bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 9/9] RapidIO: Add support for IDT CPS Gen2 switches
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-10-git-send-email-alexandre.bounine@idt.com>
In-Reply-To: <1281712686-31308-10-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
> +	rio_mport_write_config_32(mport, destid, hopcount,
> +				  LOCAL_RTE_CONF_DESTID_SEL, table);
> +
> +	for (i = 0x80000000; i <= 0x800000ff;) {
> +		rio_mport_write_config_32(mport, destid, hopcount,
> +			RIO_STD_RTE_CONF_DESTID_SEL_CSR, i);

The 0x80000000 is that an autoincrement bit? If so, it only needs to do 
this once I think? If so please call it like that, and loop the 'i' 
variable through the destination IDs.

Micha
