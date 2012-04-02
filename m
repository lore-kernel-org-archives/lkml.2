Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2DBVlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:41:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55694 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2DBVlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:41:17 -0400
Date: Mon, 02 Apr 2012 17:40:06 -0400 (EDT)
Message-Id: <20120402.174006.70116829696492189.davem@davemloft.net>
To: remi@remlab.net
Cc: levinsasha928@gmail.com, remi.denis-courmont@nokia.com, davej@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phonet: Check input from user before allocating
From: David Miller <davem@davemloft.net>
In-Reply-To: <201204022201.41808.remi@remlab.net>
References: <1333398660-11552-1-git-send-email-levinsasha928@gmail.com>
	<201204022201.41808.remi@remlab.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 02 Apr 2012 14:40:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rémi Denis-Courmont" <remi@remlab.net>
Date: Mon, 2 Apr 2012 22:01:40 +0300

> Le lundi 2 avril 2012 23:31:00 Sasha Levin, vous avez écrit :
>> A phonet packet is limited to USHRT_MAX bytes, this is never checked during
>> tx which means that the user can specify any size he wishes, and the kernel
>> will attempt to allocate that size.
> 
> Does this really solve the problem?  I guess 128kb is still possible with 
> USHRT_MAX plus skbuff overhead, which might still trigger OOM relatively 
> easily once the memory gets sufficiently fragmented.
> 
> How does UDP deal with this?

UDP generates a fragment list of MTU sized SKBs.

Phonet could avoid the large allocations by building page based
SKBs.
