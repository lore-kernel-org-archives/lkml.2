Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2IHITq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 04:19:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57103 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2IHIS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 04:18:59 -0400
MIME-Version: 1.0
In-Reply-To: <1347082551-2394-1-git-send-email-irina.tirdea@intel.com>
References: <1347082551-2394-1-git-send-email-irina.tirdea@intel.com>
Date: Sat, 8 Sep 2012 11:18:57 +0300
X-Google-Sender-Auth: y2mXscpbMZvDx04u-CCXQ0VhUVs
Message-ID: <CAOJsxLEBNsg9g4ShwzQsnjydAmbEGjZq3ELsdf=JbJ36V1ffYg@mail.gmail.com>
Subject: Re: [PATCH v3] perf bench: fix assert when NDEBUG is defined
From: Pekka Enberg <penberg@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, paulus@samba.org, dsahern@gmail.com,
        namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 8, 2012 at 8:35 AM, Irina Tirdea <irina.tirdea@gmail.com> wrote:
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

Reviewed-by: Pekka Enberg <penberg@kernel.org>
