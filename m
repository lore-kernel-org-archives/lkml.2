Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0EXPAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:00:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058Ab0EXPAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:00:43 -0400
Date: Mon, 24 May 2010 07:57:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Johannes Berg <johannes.berg@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Frans Pop <elendil@planet.nl>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Wireless IBSS on Linux-2.6.34 broken by commit
 3bbb9ec946428b96657126768f65487a48dd090c
In-Reply-To: <Pine.LNX.4.64.1005240710460.3159@boston.corp.fedex.com>
Message-ID: <alpine.LFD.2.00.1005240754130.3689@i5.linux-foundation.org>
References: <Pine.LNX.4.64.1005240710460.3159@boston.corp.fedex.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 May 2010, Jeff Chua wrote:
> 
> -	expires_limit = expires + timer->slack;
> +	expires_limit = expires;
> 
> -	if (timer->slack < 0) /* auto slack: use 0.4% */
> +	if (timer->slack > -1)
> +		expires_limit = expires + timer->slack;
> +	else if (time_after(expires, jiffies)) /* auto slack: use 0.4% */
>  		expires_limit = expires + (expires - jiffies)/256;

Please don't reload 'jiffies' twice. It's volatile, and the compiler will 
do a crap job of it. 

Also, '0' is a normal number, but '-1' is a rather odd value. Please just 
test for non-negative by doing ">= 0" rather than "> -1"

		Linus
