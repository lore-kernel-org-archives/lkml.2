Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab0GBULa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 16:11:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:44718 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575Ab0GBUL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 16:11:29 -0400
Message-ID: <4C2E47E9.5090408@suse.cz>
Date: Fri, 02 Jul 2010 22:11:21 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Nicolas Palix <npalix@diku.dk>, Randy Dunlap <rdunlap@xenotime.net>,
       Roland Dreier <rdreier@cisco.com>, Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Andy Isaacson <adi@hexapodia.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, walter harms <wharms@bfs.de>,
       Joerg Roedel <joro@8bytes.org>, Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/7] Add a target to use the Coccinelle checker
References: <1275837307-4283-1-git-send-email-npalix@diku.dk> <1275837307-4283-2-git-send-email-npalix@diku.dk> <20100630185851.GA17502@shinshilla>
In-Reply-To: <20100630185851.GA17502@shinshilla>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.6.2010 20:58, Kulikov Vasiliy wrote:
>> +if [ "$COCCI" = "" ] ; then
>> +    for f in `find $srctree/scripts/coccinelle/ -name '*.cocci' -type f | sort`; do
>> +	coccinelle $f $srctree;
>> +    done
>> +else
>> +    coccinelle $COCCI $srctree
>> +fi
> 
> I think it is more usefull to use $M instead of $srctree to run simple
> 'make coccicheck'.

Good idea, but
1) The right variable to look for is $KBUILD_EXTMOD
2) If this is not set, the script should check files in $srctree as before

Michal
