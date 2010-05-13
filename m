Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab0EMOk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:40:26 -0400
Received: from mail4.comsite.net ([205.238.176.238]:56185 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab0EMOkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:40:25 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.98.68;
From: Milton Miller <miltonm@bga.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: akpm@linux-foundation.org, Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Divy Le Ray <divy@chelsio.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, containers@lists.linux-foundation.org,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Peter Zijlstra <peterz@infradead.org>, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 1/9] mm: add generic adaptive large memory allocation APIs
In-Reply-To: <1273744285-8128-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: vi
Date: Thu, 13 May 2010 09:39:36 -0500
X-Originating-IP: 71.22.98.68
Message-ID: <1273761576_4060@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 at 17:51:25 +0800, Changli Gao wrote:

> +static inline void *kvcalloc(size_t n, size_t size)
> +{
> +	return __kvmalloc(n * size, __GFP_ZERO);
> 

This needs multiply overflow checking like kcalloc.

milton
