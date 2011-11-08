Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1KHJk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:40:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:39338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab1KHJk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:40:58 -0500
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>, casteyde.christian@free.fr
Date: Tue, 08 Nov 2011 10:40:46 +0100
In-Reply-To: <20111108090735.GA4038@zhy>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
	 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
	 <1320669279.18053.29.camel@twins>
	 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
	 <1320682230.17809.11.camel@twins> <20111108025847.GB11439@zhy>
	 <1320739015.2244.0.camel@twins> <20111108081433.GA3746@zhy>
	 <1320741980.2244.4.camel@twins> <20111108090735.GA4038@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320745246.2244.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 17:07 +0800, Yong Zhang wrote:
> So something like below?

that fails to clear/init the class_cache, leading to all sorts of
problems.

Wiping the class_cache just reduces performance somewhat, not wiping
them is disastrous since it can results in wild pointer derefs.

Now we could fix up register_lock_class() to reset the class_cache,
although that's a little tricky and I'm not sure its worth it.

Anyway, I see you just realized the same.. ;-)
