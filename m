Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0FFXN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 19:13:57 -0400
Received: from mail.vyatta.com ([76.74.103.46]:37216 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab0FFXNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 19:13:55 -0400
Date: Sun, 6 Jun 2010 16:13:48 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       herbert@gondor.hengli.com.au, jdike@linux.intel.com
Subject: Re: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
 external.
Message-ID: <20100606161348.427822fb@nehalam>
In-Reply-To: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still not sure this is a good idea for a couple of reasons:

1. We already have lots of special cases with skb's (frags and fraglist),
   and skb's travel through a lot of different parts of the kernel.  So any
   new change like this creates lots of exposed points for new bugs. Look
   at cases like MD5 TCP and netfilter, and forwarding these SKB's to ipsec
   and ppp and ...

2. SKB's can have infinite lifetime in the kernel. If these buffers come from
   a fixed size pool in an external device, they can easily all get tied up
   if you have a slow listener. What happens then?
