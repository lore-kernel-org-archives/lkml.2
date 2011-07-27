Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1G0RMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:12:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35106 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1G0RMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:12:15 -0400
Date: Wed, 27 Jul 2011 19:12:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, David Miller <davem@davemloft.net>,
        Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
        Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] vfs: avoid taking locks if inode not in lists
Message-ID: <20110727171212.GZ8006@one.firstfloor.org>
References: <1311294452.2576.18.camel@schen9-DESK> <20110723132411.GA22183@infradead.org> <1311633550.2576.33.camel@schen9-DESK> <20110725225154.GD22133@ZenIV.linux.org.uk> <1311636178.2576.34.camel@schen9-DESK> <1311660013.2996.6.camel@edumazet-laptop> <1311668466.2355.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110726090357.GA13013@infradead.org> <1311672994.2355.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1311780065.2356.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311780065.2356.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Before even taking locks, we can perform an unlocked test to check if
> inode can possibly be in the lists.
> 
> On a 2x4x2 machine, a close(socket()) pair can be 200% faster with these
> changes.

Great result! Seems simple and obvious to me.

-Andi

