Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab2J2T7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:59:46 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:49430 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754877Ab2J2T7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:59:44 -0400
Message-ID: <1351540778.2721.7.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] net: dsa/slave: Fix compilation warnings
From: Ben Hutchings <bhutchings@solarflare.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <davem@davemloft.net>, <linaro-dev@lists.linaro.org>, <patches@linaro.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 29 Oct 2012 19:59:38 +0000
In-Reply-To: <5afab1ebe83e4361f1fd75bbea0c559af195bf02.1351529738.git.viresh.kumar@linaro.org>
References: <5afab1ebe83e4361f1fd75bbea0c559af195bf02.1351529738.git.viresh.kumar@linaro.org>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 22:27 +0530, Viresh Kumar wrote:
> Currently when none of CONFIG_NET_DSA_TAG_DSA, CONFIG_NET_DSA_TAG_EDSA and
> CONFIG_NET_DSA_TAG_TRAILER is defined, we get following compilation warnings:
> 
> net/dsa/slave.c:51:12: warning: 'dsa_slave_init' defined but not used [-Wunused-function]
> net/dsa/slave.c:60:12: warning: 'dsa_slave_open' defined but not used [-Wunused-function]
> net/dsa/slave.c:98:12: warning: 'dsa_slave_close' defined but not used [-Wunused-function]
> net/dsa/slave.c:116:13: warning: 'dsa_slave_change_rx_flags' defined but not used [-Wunused-function]
> net/dsa/slave.c:127:13: warning: 'dsa_slave_set_rx_mode' defined but not used [-Wunused-function]
> net/dsa/slave.c:136:12: warning: 'dsa_slave_set_mac_address' defined but not used [-Wunused-function]
> net/dsa/slave.c:164:12: warning: 'dsa_slave_ioctl' defined but not used [-Wunused-function]
> 
> Fix them by enclosing these routines under #ifdef,endif.
[...]

This is not a useful configuration.  It might make more sense to make
NET_DSA a hidden option and have the DSA drivers (in drivers/net/dsa)
select it rather than depending on it.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

