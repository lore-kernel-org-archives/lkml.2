Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab2IKFmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 01:42:22 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:11679 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2IKFmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 01:42:21 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzDuK6Zxxw=
X-RZG-CLASS-ID: mo00
Message-ID: <504ECF3B.1090709@hartkopp.net>
Date: Tue, 11 Sep 2012 07:42:19 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>
CC: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v3] can: rename LED trigger name on netdev renames
References: <20120907071934.GB37685@macbook.local> <1347207464-2002-1-git-send-email-fabio.baltieri@gmail.com> <20120910142827.GB11000@vandijck-laurijssen.be> <504E30AE.50201@hartkopp.net> <20120910184049.GD2006@gmail.com> <504E3901.10901@hartkopp.net> <20120910200844.GC546@vandijck-laurijssen.be>
In-Reply-To: <20120910200844.GC546@vandijck-laurijssen.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.09.2012 22:08, Kurt Van Dijck wrote:

> On Mon, Sep 10, 2012 at 09:01:21PM +0200, Oliver Hartkopp wrote:

>>>>> +	if (msg == NETDEV_CHANGENAME) {
>>
>>
>> I do have a second remark.
>>
>> What about always using the notifiers to name the LED triggers?
>>
>> Looking into
>>
>> http://lxr.linux.no/#linux+v3.5.3/include/linux/netdevice.h#L1526
>>
>> we have NETDEV_CHANGENAME but what about
>>
>> 	NETDEV_REGISTER
>>
>> ???
>>
>> When changing and updating the LED trigger name always inside the notifier, we
>> should never run into any locking or race conditions ...
>>
>> What do you think about this idea?
>>
> But the initial name must have been set properly already in that case...
> 


Yes it is.

See register_netdevice()

http://lxr.linux.no/#linux+v3.5.3/net/core/dev.c#L5453


at the end NETDEV_REGISTER is notified:

http://lxr.linux.no/#linux+v3.5.3/net/core/dev.c#L5552

So it would be pretty elegant to create the LED trigger name in the notifier.
This would allow to remove that code at the current init function too.

Regards,
Oliver
