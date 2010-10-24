Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab0JXQP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 12:15:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab0JXQP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 12:15:56 -0400
Message-ID: <4CC45BAD.2060308@redhat.com>
Date: Sun, 24 Oct 2010 18:15:41 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
CC: linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: CFQ and dm-crypt
References: <4CC439ED.8090400@dcs.fmph.uniba.sk>
In-Reply-To: <4CC439ED.8090400@dcs.fmph.uniba.sk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2010 03:51 PM, Richard Kralovic wrote:
> CFQ io scheduler relies on using task_struct current to determine which
> process makes the io request. On the other hand, some dm modules (such
> as dm-crypt) use separate threads for doing io. As CFQ sees only these
> threads, it provides a very poor performance in such a case.
> 
> IMHO the correct solution for this would be to store, for every io
> request, the process that initiated it (and preserve this information
> while the request is processed by device mapper). Would that be feasible?

Yes, this seems to be correct solution. I think this should be
handled by core device-mapper (as you noted, more dm targets using
threads to process.)


> Other possibility is to avoid using separate threads for doing io in dm
> modules. The attached patch (against 2.6.36) modifies dm-crypt in this
> way, what results into much better behavior of cfq (e.g., io priorities
> work correctly).

Sorry, this completely dismantles the way how dm-crypt solves problems
with stacking dm devices.
Basically it reintroduces possible deadlocks for low memory
situations (the reason why there are these threads).

Milan
