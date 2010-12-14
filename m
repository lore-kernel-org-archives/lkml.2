Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab0LNQtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:49:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308Ab0LNQtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:49:17 -0500
Date: Tue, 14 Dec 2010 17:42:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 16/21] Wait for threads to freeze
Message-ID: <20101214164203.GI11400@redhat.com>
References: <20101214152259.67896960@suzukikp> <20101214154900.2d7a643c@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214154900.2d7a643c@suzukikp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14, Suzuki K. Poulose wrote:
>
> + * zero_thread_state :
> + * For threads, which are not frozen, we cannot capture the register state.

Indeed, but

> +		if (!tinfo->frozen)
> +			zero_thread_state(tinfo);

Again, we can race with TASK_STOPPED/SIGCONT. And
is_task_frozen_enough() thins task_is_stopped_or_traced() is fine.

Oleg.

