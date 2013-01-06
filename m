Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3AFMBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 07:01:39 -0500
Received: from 1wt.eu ([62.212.114.60]:37533 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab3AFMBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 07:01:38 -0500
Date: Sun, 6 Jan 2013 13:01:29 +0100
From: Willy Tarreau <w@1wt.eu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Gallatin <gallatin@myri.com>
Subject: Re: Major network performance regression in 3.7
Message-ID: <20130106120129.GA22432@1wt.eu>
References: <20130106005053.GS16031@1wt.eu> <1357435276.1678.5067.camel@edumazet-glaptop> <20130106013027.GV16031@1wt.eu> <1357436430.1678.5111.camel@edumazet-glaptop> <1357437086.1678.5135.camel@edumazet-glaptop> <1357438591.1678.5205.camel@edumazet-glaptop> <20130106025256.GY16031@1wt.eu> <1357457724.1678.5941.camel@edumazet-glaptop> <20130106092435.GZ16031@1wt.eu> <20130106102525.GA22151@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130106102525.GA22151@1wt.eu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 11:25:25AM +0100, Willy Tarreau wrote:
> OK good news here, the performance drop on the myri was caused by a
> problem between the keyboard and the chair. After the reboot series,
> I forgot to reload the firmware so the driver used the less efficient
> firmware from the NIC (it performs just as if LRO is disabled).
> 
> That makes me think that I should try 3.8-rc2 since LRO was removed
> there :-/

Just for the record, I tested 3.8-rc2, and the myri works as fast with
GRO there as it used to work with LRO in previous kernels. The softirq
work has increased from 26 to 48% but there is no performance drop when
using GRO anymore. Andrew has done a good job !

Willy

