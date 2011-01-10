Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1AJNnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:43:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab1AJNnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:43:22 -0500
Date: Mon, 10 Jan 2011 14:35:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG stable, 2.6.32.27] sched: delayed cleanup of user_struct
Message-ID: <20110110133545.GA30163@redhat.com>
References: <4D2AB8F7.7030506@profihost.ag> <20110110114913.GA22298@redhat.com> <20110110123630.GA27057@redhat.com> <4D2AFFB5.5000807@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2AFFB5.5000807@profihost.ag>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Stefan Priebe - Profihost AG wrote:
>
> Hi,
>
> is it a workaround to disable CONFIG_GROUP_SCHED?
                                ^^^^^^^^^^^^^^^^^^
CONFIG_USER_SCHED, not CONFIG_GROUP_SCHED.

I think that disabling it should obviously help. But it is
possible that there is something else. Given that you can
reproduce the crash, it would be nice if you can test this
and report ;)

Or. You can revert

	b00bc0b237055b4c45816325ee14f0bd83e6f590
	uids: Prevent tear down race

	3959214f971417f4162926ac52ad4cd042958caa
	sched: delayed cleanup of user_struct

patches for testing.

Oleg.

