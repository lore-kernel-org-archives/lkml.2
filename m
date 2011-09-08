Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab1IHXcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:32:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab1IHXcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:32:42 -0400
Date: Thu, 8 Sep 2011 21:24:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in
	'data'
Message-ID: <20110908192445.GA30656@redhat.com>
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08, Denys Vlasenko wrote:
>
> Make PTRACE_SEIZE set ptrace options specified in 'data' parameter

Thanks, looks good. But we need the correct "Simplify PTRACE_foo..."
first.

> Make it possible to extend SEIZE in the future with more functionality
> by passing non-zero 'addr' parameter.

Agreed, this makes sense.

> Set all task->ptrace bits in one operation - before this change,
> we were adding PT_SEIZED and PT_PTRACE_CAP with task->ptrace |= BIT ops.
> This was probably ok (not a bug), but let's be on a safer side.

PT_PTRACE_CAP is fine, but PT_SEIZED is not really, afaics.

Oleg.

