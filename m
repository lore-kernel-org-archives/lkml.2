Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246Ab0EDXZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 19:25:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371Ab0EDXZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 19:25:34 -0400
Date: Tue, 4 May 2010 16:24:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@kernel.crashing.org>,
       Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
       Thomas Moll <thomas.moll@sysgo.com>
Subject: Re: [PATCH -mm 4/5] RapidIO: Add switch domain routines
Message-Id: <20100504162457.0c8d23ba.akpm@linux-foundation.org>
In-Reply-To: <1272901558-9292-5-git-send-email-alexandre.bounine@idt.com>
References: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com>
	<1272901558-9292-5-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 May 2010 11:45:57 -0400
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> +static int
> +idtcps_set_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
> +		       u8 sw_domain)
> +{
> +	/*
> +	 * Switch domain configuration operates only at global level
> +	 */
> +	rio_mport_write_config_32(mport, destid, hopcount,
> +				  IDTCPS_RIO_DOMAIN, (u32)sw_domain);
> +	return 0;
> +}
> +
> +static int
> +idtcps_get_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
> +		       u8 *sw_domain)
> +{
> +	u32 regval;
> +
> +	/*
> +	 * Switch domain configuration operates only at global level
> +	 */
> +	rio_mport_read_config_32(mport, destid, hopcount,
> +				IDTCPS_RIO_DOMAIN, &regval);
> +
> +	*sw_domain = (u8)(regval & 0xff);
> +
> +	return 0;
> +}

This ignores the return values from rio_mport_write_config_*().

AFACIT these things always return hard-wired 0 anyway.  Perhaps we
should give up and change ->cread() and friends to return void.  That
beats the alternative of adding lots of untestable test-n-return
unwinding code.

