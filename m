Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2KZGoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 01:44:07 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:41085 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2KZGoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 01:44:05 -0500
Subject: Re: [PATCH RFC] [INET]: Get cirtical word in first 64bit of cache
 line
From: Eric Dumazet <eric.dumazet@gmail.com>
To: ling.ma.program@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <1353900555-5966-1-git-send-email-ling.ma.program@gmail.com>
References: <1353900555-5966-1-git-send-email-ling.ma.program@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Nov 2012 22:44:01 -0800
Message-ID: <1353912241.30446.1257.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 11:29 +0800, ling.ma.program@gmail.com wrote:
> From: Ma Ling <ling.ma.program@gmail.com>
> 
> In order to reduce memory latency when last level cache miss occurs,
> modern CPUs i.e. x86 and arm introduced Critical Word First(CWF) or
> Early Restart(ER) to get data ASAP. For CWF if critical word is first member
> in cache line, memory feed CPU with critical word, then fill others
> data in cache line one by one, otherwise after critical word it must
> cost more cycle to fill the remaining cache line. For Early First CPU will
> restart until critical word in cache line reaches.
> 
> Hash value is critical word, so in this patch we place it as first member
> in cache line(sock address is cache-line aligned), and it is also good for
> Early Restart platform as well .
> 
> Thanks
> Ling

networking patches should be sent to netdev.

(I understand this patch is more a generic one, but at least CC netdev)

You give no performance numbers for this change...

I never heard of this CWF/ER, where are the official Intel documents
about this, and what models really benefit from it ?

Also, why not moving skc_net as well ?

BTW, skc_daddr & skc_rcv_saddr are 'critical' as well, we use them in
INET_MATCH()

It seems we have a 32bit hole on 64bit arches, so we probably should
move inet_dport/inet_num in it. It could well remove a full cache line
miss (I'll send a patch for this after tests)

Thanks




