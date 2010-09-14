Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab0INWVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:21:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754451Ab0INWVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:21:42 -0400
Date: Tue, 14 Sep 2010 15:20:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Thomas Moll <thomas.moll@sysgo.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: Re: [PATCH v2 09/10] RapidIO: Add support for IDT CPS Gen2 switches
Message-Id: <20100914152049.8d42783f.akpm@linux-foundation.org>
In-Reply-To: <1284476363-1677-10-git-send-email-alexandre.bounine@idt.com>
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
	<1284476363-1677-10-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 10:59:22 -0400
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> +static int
> +idtg2_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
> +		       u16 table, u16 route_destid, u8 route_port)
> +{
> +	/*
> +	 * Select routing table to update
> +	 */
> +	if (table == RIO_GLOBAL_TABLE)
> +		table = 0;
> +	else
> +		table++;
> +
> +	rio_mport_write_config_32(mport, destid, hopcount,
> +				  LOCAL_RTE_CONF_DESTID_SEL, table);
> +
> +	/*
> +	 * Program destination port for the specified destID
> +	 */
> +	rio_mport_write_config_32(mport, destid, hopcount,
> +				  RIO_STD_RTE_CONF_DESTID_SEL_CSR,
> +				  (u32)route_destid);
> +
> +	rio_mport_write_config_32(mport, destid, hopcount,
> +				  RIO_STD_RTE_CONF_PORT_SEL_CSR,
> +				  (u32)route_port);
> +	udelay(10);
> +
> +	return 0;
> +}

The handling of `table' is strange.  One would expect the caller of
this function to provide the correct table index, and for the caller to
increment that index at an appropriate time.

So I take a look around but cannot find any means by which
->add_entry() is called with anything other than RIO_GLOBAL_TABLE. 
Maybe I missed something.  Is this all dead code?
