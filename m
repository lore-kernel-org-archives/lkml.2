Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab1GGSc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:32:59 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38149 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab1GGSc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:32:58 -0400
Subject: Re: [PATCH V8 2/4 net-next] skbuff: skb supports zero-copy buffers
From: Shirley Ma <mashirle@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110707.040149.441417258943576903.davem@davemloft.net>
References: <1309990932.10209.19.camel@localhost.localdomain>
	 <20110707.040149.441417258943576903.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 11:32:25 -0700
Message-ID: <1310063545.10209.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 04:01 -0700, David Miller wrote:
> From: Shirley Ma <mashirle@us.ibm.com>
> Date: Wed, 06 Jul 2011 15:22:12 -0700
> 
> > +                     while (head) {
> > +                             put_page(head);
> > +                             head = (struct page *)head->private;
> > +                     }
> 
> Looks like you might be referencing the page after it's
> release here.  I think you need something like:
> 
>                         while (head) {
>                                 struct page *next = (struct page
> *)head->private;
>                                 put_page(head);
>                                 head = next;
>                         }
> --

You are right, will fix it.

Thanks
Shirley
 

