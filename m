Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1I2SyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:54:10 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:54180 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab1I2SyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:54:08 -0400
Date: Thu, 29 Sep 2011 14:51:51 -0400 (EDT)
From: Doug Ledford <dledford@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [159/244] ipc/mqueue.c: fix mq_open() return value
Message-ID: <f27ffef8-9ec1-4254-bb26-1f2fdf4366c7@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110929175716.GA5815@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.11.231.143]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> Um, that's the way this patch is upstream, right?  So perhaps it
> should
> be fixed there first and then I can take the fix into -stable?

Upstream is a bit of a fuzzy statement ;-)  It might be in -next, but it's not in Linus' tree or Andrew's -mm tree or else my recent patches would have conflicted.  And in fact, upon further reflection, I think maybe that particular test could use being split into two distinct tests.  One for wrapping the byte counter, which would return -ENOMEM, and one for exceeding RLIMIT_MSGQUEUE which would return -EPERM (not sure if that's right, I would have to poke around elsewhere, but it seems a better response when you are violating a ulimit than nomem to me anyway).

-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

