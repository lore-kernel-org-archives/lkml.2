Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2ISLnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:43:09 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36545 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2ISLnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:43:04 -0400
Date: Wed, 19 Sep 2012 13:42:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] tools lib traceevent: Handle alloc_arg failure
Message-ID: <20120919114258.GA16696@gmail.com>
References: <87boh23epi.fsf@sejong.aot.lge.com>
 <1348037109-17252-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348037109-17252-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> +		if (!left) {
> +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> +			goto out_free;

> +		if (!right) {
> +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> +			goto out_free;
> +		}

> +		if (!left) {
> +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> +			goto out_free;
> +		}

> +		if (!left) {
> +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> +			goto out_free;
> +		}

> +		if (!right) {
> +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> +			goto out_free;
> +		}

> +		if (!left) {
> +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> +			goto out_free;
> +		}

These repetitive patterns are seriously uglifying the code and 
are crying out loud for a out_war_free label:

		if (!left)
			goto out_warn_free;

(The function here seems to be rather large as well, making it a 
possible candidate for shrinkage/splitup.)

Thanks,

	Ingo
