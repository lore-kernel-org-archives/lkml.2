Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab1AJOBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:01:31 -0500
Received: from server655-han.de-nserver.de ([85.158.177.45]:45757 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426Ab1AJOBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:01:30 -0500
Message-ID: <4D2B113A.2060303@profihost.ag>
Date: Mon, 10 Jan 2011 15:01:30 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Kay Sievers <kay.sievers@vrfy.org>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG stable, 2.6.32.27] sched: delayed cleanup of user_struct
References: <4D2AB8F7.7030506@profihost.ag> <20110110114913.GA22298@redhat.com> <20110110123630.GA27057@redhat.com> <4D2AFFB5.5000807@profihost.ag> <20110110133545.GA30163@redhat.com>
In-Reply-To: <20110110133545.GA30163@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> is it a workaround to disable CONFIG_GROUP_SCHED?
>                                  ^^^^^^^^^^^^^^^^^^
> CONFIG_USER_SCHED, not CONFIG_GROUP_SCHED.
correct but CONFIG_USER_SCHED depends on CONFIG_GROUP_SCHED and as we 
don't use CONFIG_GROUP_SCHED at all my idea was to completely remove 
this feature.

> I think that disabling it should obviously help. But it is
> possible that there is something else. Given that you can
> reproduce the crash, it would be nice if you can test this
> and report ;)
Main problem - right i can't reproduce it. But the system was crashing 
two times more in the past.

You can find the logs here:
http://pastebin.com/hNd15E8K

> Or. You can revert
> 	b00bc0b237055b4c45816325ee14f0bd83e6f590
> 	uids: Prevent tear down race
>
> 	3959214f971417f4162926ac52ad4cd042958caa
> 	sched: delayed cleanup of user_struct
Not sure if it is a good idea to introduce another race again.

Stefan
