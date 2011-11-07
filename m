Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1KGMcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:32:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab1KGMcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:32:07 -0500
Subject: Re: [RFC PATCH 4/4] lockdep: fix race condition in
 __lock_set_class()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 07 Nov 2011 13:30:54 +0100
In-Reply-To: <1320398790-21663-5-git-send-email-yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
	 <1320398790-21663-5-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320669054.18053.25.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 17:26 +0800, Yong Zhang wrote:
> When someone call lock_set_class() with valid key, nothing
> protect the initializing of 'lockdep_map'; thus could lead
> to flase positive warning from lockdep (such as "key not in
> .data!"). This patch cure that potential issue.

How? that warning is triggered of the lock_class_key * passed into
lockdep_init_map and is unrelated to the actual content of the
lockdep_map.


