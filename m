Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab1CBDCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 22:02:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33146 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab1CBDCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:02:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mtydyg7ONRe4WVSt7dyollDlVyrR4jEqEbzChEFePDZzLSp2x3aHhzK4S8zG+8gJR3
         eUW8TxgiQ6ZJR/zIgS1UgLFPdC1q4A66wBXdENQB2/9gktclQlXiOEXqX12fbU+gpCMO
         YETfaYCOcIWQrLii9RsgJofJXJ9VCpQ2ehh58=
Subject: Re: [PATCH 4/4 V2] net,rcu: don't assume the size of struct
 rcu_head
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
        paulmck@linux.vnet.ibm.com, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <4D6DAF86.2000407@cn.fujitsu.com>
References: <4D6CA860.3020409@cn.fujitsu.com>
	 <20110301.001638.104075130.davem@davemloft.net>
	 <4D6CB414.8050107@cn.fujitsu.com> <1298971213.3284.4.camel@edumazet-laptop>
	 <4D6DAF86.2000407@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 04:02:05 +0100
Message-ID: <1299034925.2930.52.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 02 mars 2011 à 10:46 +0800, Lai Jiangshan a écrit :

> Is it the cause of false sharing? I thought that all are rare write(except __refcnt)
> since it is protected by RCU.
> 
> Do you allow me just move the seldom access rcu_head to the end of the structure
> and add pads before __refcnt? I guess it increases about 3% the size of dst_entry.


dst_entry is a base class.

Its included at the beginning of other structs.

Moving rcu_head "at the end" just move it right in the middle of upper
objects as a matter of fact. This might add one cache line miss on
critical network object. A complete audit is needed.

David is doing some changes in this area, so things move fast anyway.

> I accept that I leave this code as is, when I change rcu_head I will
notify you.
> 

Thanks


