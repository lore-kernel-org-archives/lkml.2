Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab1CIPKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:10:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52914 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1CIPKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:10:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O7xxyWSdfAHOIT+Uh+aoIBEJMArLjyFG7Ezi+AYjogFoU7+IygYrewdAbW1eesDEEm
         vXXQtfAhjZmzqpctQr8JeyH07ocP9AruZeePxK2IsiEio72DZc8r8QH46CME4ofGJr1x
         tZ/Dmo6qhEr2GHW/CR/7W/c3PZd/EGLl17I0c=
Date: Wed, 9 Mar 2011 23:09:49 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Adam Majer <adamm@zombino.com>
Cc: netdev@vger.kernel.org,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, bridge@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Issue NETDEV_CHANGE notification when bridge changes
 state
Message-ID: <20110309150949.GE16951@cr0.redhat.com>
References: <20110306051833.GA3098@mira.lan.galacticasoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110306051833.GA3098@mira.lan.galacticasoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 05, 2011 at 11:18:33PM -0600, Adam Majer wrote:
>
>IPv6 address autoconfiguration relies on an UP interface to processes
>traffic normally. A bridge that is UP enters LEARNING state and this
>state "eats" any Router Advertising packets sent to the
>bridge. Issuing a NETDEV_CHANGE notification on the bridge interface
>when it changes state allows autoconfiguration code to retry
>querying router information.
>
...

>+static void br_port_change_notifier_handler(struct work_struct *work)
>+{
>+	struct net_bridge *br = container_of(work,
>+					     struct net_bridge,
>+					     change_notification_worker);
>+
>+	rtnl_lock();
>+	netdev_state_change(br->dev);
>+	rtnl_unlock();
>+}
>+

Do you really want user-space to get this notification too?
Why do you put it into a workqueue? Maybe it has to be called in
process-context?

Thanks.
