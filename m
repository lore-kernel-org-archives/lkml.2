Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2AaTpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:45:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47770 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab2AaTpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:45:09 -0500
Date: Tue, 31 Jan 2012 20:44:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arun Sharma <asharma@fb.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Glauber Costa <glommer@parallels.com>, christoph.paasch@uclouvain.be
Subject: Re: [PATCH] net: Disambiguate kernel message
Message-ID: <20120131194450.GA8020@elte.hu>
References: <1327963304-24828-1-git-send-email-asharma@fb.com>
 <CAErSpo54KRJbWEQ0fB_kuGx0qRQKWpH9d3mN=dPdiNfWH+Dhww@mail.gmail.com>
 <20120131181554.GA24397@dev3310.snc6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131181554.GA24397@dev3310.snc6.facebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arun Sharma <asharma@fb.com> wrote:

> +				printk(KERN_INFO "TCP: too many orphaned "
>  				       "sockets\n");

> +				printk(KERN_INFO "TCP: out of memory. "
> +				       "Consider tuning tcp_mem\n");

> +			printk(KERN_INFO "TCP: out of memory. "
> +					 "Consider tuning tcp_mem\n");
> +		if (too_many_orphans && net_ratelimit())
> +			printk(KERN_INFO "TCP: too many orphaned sockets\n");

A small detail: please don't line break user-visible strings in 
mid sentence. Just keep the line long. Makes it much easier to 
search for the source of a kernel message:

   git grep "TCP: too many orphaned sockets"

Thanks,

	Ingo
