Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab2IVUPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 16:15:19 -0400
Received: from mail.vyatta.com ([76.74.103.46]:40247 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab2IVUPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 16:15:18 -0400
Date: Sat, 22 Sep 2012 13:14:45 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, davem@davemloft.net, mlindner@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net] sky2: fix rx filter setup on link up
Message-ID: <20120922131445.611d794d@nehalam.linuxnetplumber.net>
In-Reply-To: <1347894617-13614-1-git-send-email-jiri@resnulli.us>
References: <1347894617-13614-1-git-send-email-jiri@resnulli.us>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012 17:10:17 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> +	sky2_write_rx_filter(sky2, filter);
> +	memcpy(sky2->rx_filter, filter, sizeof(sky2->rx_filter));

This isn't safe since rx_filter might be referred to from interrupt
context (ie link up PHY interrupt). Maybe using atomic64 would be
best.
