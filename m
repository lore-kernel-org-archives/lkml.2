Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0DUI4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:56:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50930 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0DUI4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:56:03 -0400
Subject: Re: [PATCH] perf lock: Fix state machine to recognize lock sequence
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
In-Reply-To: <20100421012651.GC7120@nowhere>
References: <4BC09546.5050309@dcl.info.waseda.ac.jp>
	 <1271407446-27180-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100421012651.GC7120@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 10:55:58 +0200
Message-ID: <1271840158.1776.63.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 03:26 +0200, Frederic Weisbecker wrote:
> The max lockdep depth may
> change in the future, or become variable, so we can't relay on that.
> 
Change, possible, variable unlikely, you need a memory allocation to
extend it, and memory allocation takes locks, which is not a nice thing
to do in the middle of lockdep.

