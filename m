Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab0CZE3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 00:29:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60125 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0CZE33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 00:29:29 -0400
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sysfs: make s_count a kref
References: <20100324031829.2136.66489.stgit@notabene.brown>
	<20100324032008.2136.15346.stgit@notabene.brown>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 25 Mar 2010 21:29:24 -0700
In-Reply-To: <20100324032008.2136.15346.stgit@notabene.brown> (NeilBrown's message of "Wed\, 24 Mar 2010 14\:20\:08 +1100")
Message-ID: <m1wrwzln8b.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: neilb@suse.de, linux-kernel@vger.kernel.org, gregkh@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

> s_count in sysfs behaves exactly like a kref, so change it to
> be one.
> This requires adding a KREF_INIT macro to kref.h

Except where it doesn't.  The whole no_recurse thing is definitely
not idiomatic kref usage.  I could find only 3 instances of someone even
looking at the return value.  I would argue based on that the return
value of kref_put should be removed.

KREF_INIT if we want it should be added in a separate patch.

kref should be kept for the stupid simple cases where so we don't have
to think about refcounting, and just know it works.  kref should not
be where we are getting clever, and it this feels like getting clever
to me.

It isn't like the atomic primitives are any worse than kref.

Eric
