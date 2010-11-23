Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0KWSam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:30:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52628 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752460Ab0KWSal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:30:41 -0500
Date: Tue, 23 Nov 2010 18:30:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/3] mfd: Added new regulator_data pointer to ab8500
 board configuration
Message-ID: <20101123183037.GA19212@rakim.wolfsonmicro.main>
References: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com>
 <1290536754-21775-2-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290536754-21775-2-git-send-email-bengt.g.jonsson@stericsson.com>
X-Cookie: I brake for chezlogs!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 07:25:52PM +0100, Bengt Jonsson wrote:

> The ab8500 regulator board configuration will be better separated
> from the MFD board configuration. This patch adds a void pointer
> for this purpose.

Adding something completely typesafe seems like a real loss - if you
want to point to something else at least point to a particular type -
eg, 

struct foo;

struct pdata {
	int other_stuff;
	struct foo *foo;
};

>  	struct regulator_init_data *regulator[AB8500_NUM_REGULATORS];
> +	void *regulator_data;

It'd also help if you could articulate the problem you see with the
current approach...
