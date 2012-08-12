Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2HLBQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 21:16:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56392 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2HLBQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 21:16:43 -0400
Date: Sat, 11 Aug 2012 18:16:42 -0700 (PDT)
Message-Id: <20120811.181642.1587792778007257202.davem@davemloft.net>
To: yefremov.denis@gmail.com
Cc: mst@redhat.com, jasowang@redhat.com, ebiederm@xmission.com,
        ian.campbell@citrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] macvtap: rcu_dereference outside read-lock section
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344679527-13377-1-git-send-email-yefremov.denis@gmail.com>
References: <1344679527-13377-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Efremov <yefremov.denis@gmail.com>
Date: Sat, 11 Aug 2012 14:05:27 +0400

> -		if (rcu_dereference(vlan->taps[i]) == q)
> +		if (rcu_dereference_protected(vlan->taps[i],
> +				lockdep_is_held(&macvtap_lock)) == q)

You must use the proper combination of TAB character and spaces
to line up the lockdep_is_held() argument with the first column
after openning "(" on the previous line.

Never be lazy and use only TABs.
