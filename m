Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab2JQRuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:50:16 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:22012 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518Ab2JQRuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:50:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcFADDvflBthdl2/2dsb2JhbABFvGiDPoEIgiABAQV4ARALDQsJFg8JAwIBAgFFBg0BBwEBiAS7cYtYhkIDm00iijCCcQ
Message-ID: <507EEEE6.9040008@computer.org>
Date: Wed, 17 Oct 2012 19:46:14 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Dmitry Fleytman <dmitry@daynix.com>
CC: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Chris Webb <chris.webb@elastichosts.com>,
        Richard Davies <richard.davies@elastichosts.com>
Subject: Re: [PATCH] e1000 driver RX race condition fixed
References: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
In-Reply-To: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 07:19 PM, Dmitry Fleytman wrote:
> There is a race condition in e1000 driver.
> It enables HW receive before RX rings initalization.
> In case of specific timing this may lead to host memory corruption
> due to DMA write to arbitrary memory location.
> Following patch fixes this issue by reordering initialization steps.
> 
> Other Intel network drivers does not seem to have this issue.
> 
> Dmitry Fleytman (1):
>   RX initialization sequence fixed - enable RX after corresponding ring
>     initialization only
> 
>  drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    9 +++++----
>  drivers/net/ethernet/intel/e1000/e1000_main.c    |   18 ++++++++++++++++--
>  2 files changed, 21 insertions(+), 6 deletions(-)
> 

Would it be at all possible to copy netdev on networking-related
discussions?
