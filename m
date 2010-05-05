Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab0EEV1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:27:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab0EEV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:27:24 -0400
Date: Wed, 5 May 2010 17:27:23 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Bastien Nocera <hadess@hadess.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
Message-ID: <20100505212722.GA4902@bombadil.infradead.org>
References: <1272994594.13354.215.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272994594.13354.215.camel@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 06:36:34PM +0100, Bastien Nocera wrote:
> +static struct dmi_system_id __initdata dmi_system_table[] = {
<snip>
> +	/* Intel Apple Macs never have an i8042 controller */
> +	if (dmi_check_system(dmi_system_table) > 0)
> +		return -ENODEV;

Hi Bastien,

These uses of dmi_ would need to be protected by CONFIG_DMI from being
compiled on platforms where DMI doesn't exist (like powerpc.)

regards, Kyle
