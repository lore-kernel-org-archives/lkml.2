Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2IHOML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 10:12:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33203 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2IHOMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 10:12:06 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, paulus@samba.org, dsahern@gmail.com,
        namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v3] perf bench: fix assert when NDEBUG is defined
References: <1347082551-2394-1-git-send-email-irina.tirdea@intel.com>
Date: Sat, 08 Sep 2012 23:11:57 +0900
In-Reply-To: <1347082551-2394-1-git-send-email-irina.tirdea@intel.com> (Irina
	Tirdea's message of "Sat, 8 Sep 2012 08:35:51 +0300")
Message-ID: <87a9x0a9jm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  8 Sep 2012 08:35:51 +0300, Irina Tirdea wrote:
> From: Irina Tirdea <irina.tirdea@intel.com>
>
> When NDEBUG is defined, the assert macro will be expanded to nothing.
> Some assert calls used in perf are also including some functionality
> (e.g. system calls), not only validity checks. Therefore, if NDEBUG is
> defined, this functionality will be removed along with the assert.
> Perf also defines BUG_ON based on assert, so it has the same problem.
>
> Define BUG_ON so that the condition will be executed when NDEBUG is defined.
> Replace the assert statements that have these side effects with BUG_ON.
>
> For defining BUG_ON, use "if (cond) {}" insted of "if (cond) ;" because in
> the latter case build fails with "error: suggest braces around empty body in
> an ‘if’ statement [-Werror=empty-body]"
>
> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
