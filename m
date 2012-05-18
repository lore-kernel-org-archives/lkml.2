Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2ERFlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 01:41:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38299 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab2ERFlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 01:41:51 -0400
Date: Fri, 18 May 2012 01:41:31 -0400 (EDT)
Message-Id: <20120518.014131.519437851000725829.davem@davemloft.net>
To: herton.krzesinski@canonical.com
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com,
        eric.dumazet@gmail.com
Subject: Re: [ 12/53] net: In unregister_netdevice_notifier unregister the
 netdevices.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120518050904.GA2971@herton-Z68MA-D2H-B3>
References: <20120518023254.339945758@decadent.org.uk>
	<20120518023255.978828329@decadent.org.uk>
	<20120518050904.GA2971@herton-Z68MA-D2H-B3>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 22:41:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Fri, 18 May 2012 02:09:05 -0300

> On Fri, May 18, 2012 at 03:33:06AM +0100, Ben Hutchings wrote:
>> 3.2.18-stable review patch.  If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> [ Upstream commit 7d3d43dab4e978d8d9ad1acf8af15c9b1c4b0f0f ]
>> 
>> We already synthesize events in register_netdevice_notifier and synthesizing
>> events in unregister_netdevice_notifier allows to us remove the need for
>> special case cleanup code.
>> 
>> This change should be safe as it adds no new cases for existing callers
>> of unregiser_netdevice_notifier to handle.
> 
> It seems this introduces a regression later fixed by commit
> c57b54684060c8aced64a5b78ff69ff289af97b9

Indeed, but thankfully that only hits people who try to unload the
pktgen module which is a pretty small group of people :)
