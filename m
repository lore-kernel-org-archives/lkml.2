Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab2EKDH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:07:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56514 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab2EKDHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:07:54 -0400
Date: Thu, 10 May 2012 23:07:37 -0400 (EDT)
Message-Id: <20120510.230737.585788465862567756.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: jrnieder@gmail.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, eric.dumazet@gmail.com,
        subramanian.vijay@gmail.com
Subject: Re: [ 074/167] [PATCH 14/26] tcp: fix tcp_trim_head()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336705215.8274.425.camel@deadeye>
References: <20120509055040.099618905@decadent.org.uk>
	<20120509081617.GD32230@burratino>
	<1336705215.8274.425.camel@deadeye>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 20:07:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 11 May 2012 04:00:15 +0100

> On Wed, 2012-05-09 at 03:16 -0500, Jonathan Nieder wrote:
>> Ben Hutchings wrote:
>> 
>> > 3.2-stable review patch.  If anyone has any objections, please let me know.
>> [...]
>> > [ Upstream commit 4fa48bf3c75069d636fc8830743c929a062e80dc ]
>> >
>> > commit f07d960df3 (tcp: avoid frag allocation for small frames)
>> > breaked assumption in tcp stack that skb is either linear (skb->data_len
>> > == 0), or fully fragged (skb->data_len == skb->len)
>> >
>> > tcp_trim_head() made this assumption, we must fix it.
>> 
>> Is this needed in the context of 3.2.y (which does not include
>> f07d960df3)?
> [...]
> 
> The code being replaced really didn't make sense, but unless there is
> some other case that breaks the assumption described then I don't think
> this meets the stable rules.  David?

It's a prerequisite for cleanly applying the patch that comes right
afterwards.
