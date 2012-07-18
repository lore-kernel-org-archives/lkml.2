Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2GRUdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 16:33:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab2GRUdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 16:33:31 -0400
Date: Wed, 18 Jul 2012 16:33:04 -0400
From: Dave Jones <davej@redhat.com>
To: Jim Rees <rees@umich.edu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Sasha Levin <levinsasha928@gmail.com>, Trond.Myklebust@netapp.com,
        davem@davemloft.net, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: Prevent kernel stack corruption on long values
 of flush
Message-ID: <20120718203304.GA18540@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Jim Rees <rees@umich.edu>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Sasha Levin <levinsasha928@gmail.com>, Trond.Myklebust@netapp.com,
	davem@davemloft.net, linux-nfs@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1342476086-21638-1-git-send-email-levinsasha928@gmail.com>
 <20120718173913.GA1298@fieldses.org>
 <20120718200049.GA17964@umich.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718200049.GA17964@umich.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 04:00:49PM -0400, Jim Rees wrote:

 > You could use something like:
 > 
 >     char tbuf[sizeof (unsigned long) * 24 / 10 + 1 + 2]; /* + 2 for final "\n\0" */
 > 
 > since there are roughly 10 bits for every 3 decimal digits.
 > 
 > But I'm obviously confused, because I don't understand why tbuf needs to be
 > any more than 10 + 2.

Unsigned long isn't necessarily 32 bits.
On 64-bit systems %lu can be up to 18446744073709551615

	Dave

