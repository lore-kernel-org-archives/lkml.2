Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab0LJQiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:38:18 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44695 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab0LJQiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:38:16 -0500
Subject: Re: [RFC PATCH V2 5/5] Add TX zero copy in macvtap
From: Shirley Ma <mashirle@us.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>, mst@redhat.com,
        xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291998355.2167.53.camel@localhost.localdomain>
References: <1291976026.2167.49.camel@localhost.localdomain>
	 <1291976864.3580.7.camel@edumazet-laptop>
	 <1291998355.2167.53.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 08:38:08 -0800
Message-ID: <1291999088.2167.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 08:25 -0800, Shirley Ma wrote:
> On Fri, 2010-12-10 at 11:27 +0100, Eric Dumazet wrote:
> > You could make one atomic_add() outside of the loop, and factorize
> > many
> > things...
> > 
> > atomic_add(len, &skb->sk->sk_wmem_alloc);
> > skb->data_len += len;
> > skb->len += len;
> > skb->truesize += len;
> > while (len) {
> >         ...
> > } 
> 
> Yep, thanks, will update it! 

Maybe I should use total_len when skb frag mapping is done, something
like:

int total_len = 0;
...
total len += len;
...
skb->data_len += total_len;
skb->len += total_len;
skb->truesize += total_len;
atomic_add(total_len, &skb->sk->sk_wmem_alloc);

Shirley

