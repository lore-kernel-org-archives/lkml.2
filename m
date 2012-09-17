Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab2IQQMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:12:46 -0400
Received: from mail.vyatta.com ([76.74.103.46]:56885 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab2IQQMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:12:45 -0400
Date: Mon, 17 Sep 2012 09:12:14 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, davem@davemloft.net, mlindner@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net] sky2: fix rx filter setup on link up
Message-ID: <20120917091214.5cd9b0f5@nehalam.linuxnetplumber.net>
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

> In my case I have following problem. sky2_set_multicast() sets registers
> GM_MC_ADDR_H[1-4] correctly to:
> 0000 0800 0001 0410
> However, when adapter gets link and sky2_link_up() is called, the values
> are for some reason different:
> 0000 0800 0016 0410

Rather than papering over the problem, it would be better to
trace back what is setting those registers and fix that code.

> This in my case prevents iface to be able to receive packets with dst mac
> 01:80:C2:00:00:02 (LACPDU dst mac), which I set up previously by
> SIOCADDMULTI.
> 
> So remember computed rx_filter data and write it to GM_MC_ADDR_H[1-4] on
> link_up.
>

Please do some more root cause analysis. Just save/restoring the
registers is just a temporary workaround.
