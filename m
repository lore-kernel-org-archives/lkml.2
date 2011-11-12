Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab1KLSlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 13:41:09 -0500
Received: from smtp.newsguy.com ([74.209.136.69]:49830 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1KLSlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 13:41:07 -0500
Message-ID: <4EBECB89.2020102@newsguy.com>
Date: Sat, 12 Nov 2011 11:39:53 -0800
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110917 Lightning/1.0b3pre Thunderbird/3.1.12
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/16] mtd/docg3: add OOB layout to mtdinfo
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr> <1320912342-30147-8-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1320912342-30147-8-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 12:05 AM, Robert Jarzmik wrote:
> +static struct nand_ecclayout docg3_oobinfo = {
> +	.eccbytes = 8,
> +	.eccpos = {7, 8, 9, 10, 11, 12, 13, 14},
> +	.oobfree = {{0, 7}, {15, 1} },
> +	.oobavail = 8,
> +};
> +

Just FYI, per Ivan's suggestion, I changed this to use the last oob byte as a
"page programmed" flag for the purpose of detecting bit flips when reading a
blank page.  Maybe something to keep in mind.  You can have a look at the latest
G4 driver patch to see exactly how I use it.

Mike

