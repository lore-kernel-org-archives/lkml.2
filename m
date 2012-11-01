Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636Ab2KAO0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:26:40 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:60974 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761388Ab2KAO0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:26:38 -0400
Date: Thu, 1 Nov 2012 10:26:28 -0400
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: davem@davemloft.net, dwmw2@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] pppoatm: fix race condition with destroying of
 vcc
Message-ID: <20121101102628.6e3d3cae@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <20121031220435.GA25157@shrek.podlesie.net>
References: <1350926091-12642-2-git-send-email-krzysiek@podlesie.net>
	<201210301426.q9UEQkI7007209@thirdoffive.cmf.nrl.navy.mil>
	<20121030182001.GA30373@shrek.podlesie.net>
	<20121031094147.GA1004@shrek.podlesie.net>
	<20121031160352.68353ecc@thirdoffive.cmf.nrl.navy.mil>
	<20121031220435.GA25157@shrek.podlesie.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012 23:04:35 +0100
Krzysztof Mazur <krzysiek@podlesie.net> wrote:

> There are also some minor potential issues in pppoatm driver:
> 
> 	- locking issues, but now only between pppoatm_send() and
> 	  vcc_sendmsg() and maybe some other functions,

these have been around for a while.  i agree that something should be
done about it.  just not sure what should be synchronizing this mess.

> 	- missing check for SS_CONNECTED in pppoatm_ioctl,

in practice you will never run into this because a pvc is immediately
put into SS_CONNECTED mode (right before the userspace open()
returns).  however, should it check?  yes.  i dont see anything
preventing you from running ppp on svc's.

