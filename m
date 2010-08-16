Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab0HPMSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:18:41 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:47488 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0HPMSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:18:40 -0400
Message-ID: <4C692C9D.6040100@neli.hopto.org>
Date: Mon, 16 Aug 2010 14:18:37 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Alexandre Bounine <alexandre.bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/9] RapidIO: Add relation links between RIO device structures
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-5-git-send-email-alexandre.bounine@idt.com>
In-Reply-To: <1281712686-31308-5-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
> Create back and forward links between RIO devices. These links are intended for
> use by error management and hot-plug extensions.

As RapidIO is a switched network, the concept of 'previous' and 'next' 
devices is invalid. Perhaps it's just the way they were 
discovered/enumerated, but that does not matter any more at runtime. Or 
at least, should not matter.

> @@ -237,6 +241,7 @@ struct rio_switch {
>  	u16 hopcount;
>  	u16 destid;
>  	u8  inport;
> +	u8  nports;
>  	u8 *route_table;
>  	u32 port_ok;

This can be extracted from the swpinfo field (which you removed in 
another patch)?

Micha
