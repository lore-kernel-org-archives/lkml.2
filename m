Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab2DCGg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 02:36:29 -0400
Received: from oyp.chewa.net ([91.121.6.101]:59010 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab2DCGg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 02:36:27 -0400
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] phonet: Check input from user before allocating
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 03 Apr 2012 08:36:20 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: <levinsasha928@gmail.com>, <davej@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20120402.174006.70116829696492189.davem@davemloft.net>
References: <1333398660-11552-1-git-send-email-levinsasha928@gmail.com> <201204022201.41808.remi@remlab.net> <20120402.174006.70116829696492189.davem@davemloft.net>
Message-ID: <dc6e3bc8b96d91bd7ce44639b60cfec2@chewa.net>
User-Agent: RoundCube Webmail/0.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Apr 2012 17:40:06 -0400 (EDT), David Miller

<davem@davemloft.net> wrote:

> UDP generates a fragment list of MTU sized SKBs.

> 

> Phonet could avoid the large allocations by building page based

> SKBs.



Oh right. And Phonet devices don't support scatter/gather, so that I guess

that would merely delay the problem.



Also sendmsg() code would need to be reectored to look up the output

device and then the MTU before allocating the socket buffer. This will only

work if the default MTU is reduced first :/



-- 

Rémi Denis-Courmont

Sent from my collocated server
