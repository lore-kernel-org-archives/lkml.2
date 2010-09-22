Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab0IVTBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:01:15 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:38031 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab0IVTBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:01:13 -0400
X-Greylist: delayed 1002 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2010 15:01:13 EDT
Date: Wed, 22 Sep 2010 14:43:29 -0400
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Mikko Vinni <mmvinni@yahoo.com>
Cc: Karl Hiramoto <karl@hiramoto.org>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: scheduling while atomic: br2684ctl (atm)
Message-ID: <20100922144329.0cb3cf86@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <647401.39574.qm@web58406.mail.re3.yahoo.com>
References: <647401.39574.qm@web58406.mail.re3.yahoo.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=-0.001
X-NRLCMF-Virus-Scanned: No virus found
X-NRLCMF-Languages: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 00:42:29 -0700 (PDT)
Mikko Vinni <mmvinni@yahoo.com> wrote:

> I get the following message apparently every time (on 2.6.36-rc4+ at
> least) when killing any old br2684ctl processes.
> "unregister_atmdevice_notifier" was added by
> 7313bb8f ("atm: propagate signal changes via notifier") so perhaps
> the unregister
> part was not tested properly for rcu interaction?

it looks like atomic_notifier_chain_unregister() cannot be called in an
atomic context.  the only reason there is a lock is to the list of
br2684_devs atomically.  however, i think the event handler could be
made to just register/unregister on module load/unload instead.

> So far I haven't noticed any ill effects from the message. Let me
> know if I should test something. Thanks.

it isnt good.  it should be fixed.  unless someone has a better idea i
will go ahead with the above.

