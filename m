Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab2KNAeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:34:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:21604 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab2KNAea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:34:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,247,1352102400"; 
   d="scan'208";a="217374951"
Date: Tue, 13 Nov 2012 16:42:18 -0800 (PST)
From: Joseph Gasparakis <joseph.gasparakis@intel.com>
X-X-Sender: jgaspara@morpheus.jf.intel.com
To: Joseph Gasparakis <joseph.gasparakis@intel.com>
cc: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry@broadcom.com, saeed.bishara@gmail.com
Subject: Re: [PATCH v2 net-next 0/3 ] tunneling: Add support for hardware-offloaded
 encapsulation
In-Reply-To: <1352709418-28996-1-git-send-email-joseph.gasparakis@intel.com>
Message-ID: <alpine.LFD.2.02.1211131514060.13310@morpheus.jf.intel.com>
References: <1352709418-28996-1-git-send-email-joseph.gasparakis@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
ReplyTo: "Joseph Gasparakis" <joseph.gasparakis@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Nov 2012, Joseph Gasparakis wrote:

> The series contains updates to add in the NIC Rx and Tx checksumming support
> for encapsulated packets.
> 
> The sk_buff needs to somehow have information of the inner packet, and adding
> three fields for the inner mac, network and transport headers was the prefered
> approach. 
> 
> Not adding these fields would mean that the drivers would need to parse the
> sk_buff data in hot-path, having a negative impact in the performance.
> 
> Adding in sk_buff a pointer to the skbuff of the inner packet made sense, but
> would be a complicated change as assumptions needed to be made with regards to
> helper functions such as skb_clone() skb_copy(). Also code for the existing
> encapsulation protocols (such as VXLAN and IP GRE) had to be reworked, so the
> decision was to have the simple approach of adding these three fields.
> 
> v2 Makes sure that checksumming for IP GRE does not take place if the offload flag is set in the skb's netdev features
> 

Thank you all. I am working now on implementing a demo using ixgbe and 
will re-submit soon this series of patches taking into consideration any 
open comments.
