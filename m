Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1KHIqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:46:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54709 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1KHIqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:46:35 -0500
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>, casteyde.christian@free.fr
Date: Tue, 08 Nov 2011 09:46:20 +0100
In-Reply-To: <20111108081433.GA3746@zhy>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
	 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
	 <1320669279.18053.29.camel@twins>
	 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
	 <1320682230.17809.11.camel@twins> <20111108025847.GB11439@zhy>
	 <1320739015.2244.0.camel@twins> <20111108081433.GA3746@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320741980.2244.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 16:14 +0800, Yong Zhang wrote:
> 
> But how do we deal with ->class_cache? Always set it in
> loop_up_lock_class()? 

Hrm.. good point, aside from that there's another problem as well, I
think we can deal with the cache being NULL, but is memset() an atomic
write? If not a read could observe an intermediate state and go funny.

I'm tempted to go with the pure kmemcheck_mark_initialized() thing for
now.
