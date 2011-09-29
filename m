Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1I2L4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:56:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58127 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1I2L4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:56:06 -0400
Subject: Re: [PATCH 2/4] kmemleak: Handle percpu memory allocation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
	 <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Sep 2011 13:56:13 +0200
Message-ID: <1317297373.2855.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 29 septembre 2011 à 12:02 +0100, Catalin Marinas a écrit :
> This patch adds kmemleak callbacks from the percpu allocator, reducing a
> number of false positives caused by kmemleak not scanning such memory
> blocks. The percpu chunks are never reported as leaks because of current
> kmemleak limitations with the __percpu pointer not pointing directly to
> the actual chunks.
> 
> Reported-by: Huajun Li <huajun.li.lee@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>,
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---

Hi Catalin

I wonder if you tried it on a 16 or 64 cpus machine ?

I guess we should increase CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE default

Or you could add new kmemleak_percpu_alloc() / kmemleak_percpu_free()
primitives to not waste entries in early_log[]



