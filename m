Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2CDREE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 12:04:04 -0500
Received: from mail.us.es ([193.147.175.20]:45034 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab2CDREA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 12:04:00 -0500
Date: Sun, 4 Mar 2012 18:03:57 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: bart.de.schuymer@pandora.be, kaber@trash.net, shemminger@vyatta.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: Resend [PATCH] netfilter: Fix copy_to_user too small size
 parametre.
Message-ID: <20120304170357.GA24080@1984>
References: <1330621743-12883-1-git-send-email-santoshprasadnayak@gmail.com>
 <20120304121841.GA23277@1984>
 <CAOD=uF6UvL2oEmJmgak4X5L0PR+qQi2=Vr22AUsAxLLOfi44rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOD=uF6UvL2oEmJmgak4X5L0PR+qQi2=Vr22AUsAxLLOfi44rw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2012 at 06:09:08PM +0530, santosh prasad nayak wrote:
> where is it broken ?
> Can you please explain ?

> >> +     strncpy(name, t->u.target->name, sizeof(name));
> >>       hlp = ubase + (((char *)e + e->target_offset) - base);
> >>       t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);

In ebt_make_names, you dereference t but it is not initialized.

Note that strncpy refers to t->u.target->name which is initialized a
couple of lines after it.
