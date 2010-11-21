Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab0KUKB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 05:01:58 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:60652 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab0KUKB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 05:01:57 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Handle DT_UNKNOWN on filesystems that don't support d_type
References: <1290300139-2695-1-git-send-email-sbohrer@rgmadvisors.com>
X-Yow: Have my two-tone, 1958 Nash METRO brought around..
Date: Sun, 21 Nov 2010 11:01:53 +0100
In-Reply-To: <1290300139-2695-1-git-send-email-sbohrer@rgmadvisors.com> (Shawn
	Bohrer's message of "Sat, 20 Nov 2010 18:42:19 -0600")
Message-ID: <m2ipzryoz2.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Bohrer <sbohrer@rgmadvisors.com> writes:

> +		if (((lang_dirent.d_type == DT_DIR &&			\
> +		      lang_dirent.d_type != DT_UNKNOWN) ||		\
> +		     (lang_dirent.d_type == DT_UNKNOWN &&		\
> +		      is_directory(scripts_path, &lang_dirent))) &&	\

		if ((lang_dirent.d_type == DT_DIR ||			\
		     (lang_dirent.d_type == DT_UNKNOWN &&		\
		      is_directory(scripts_path, &lang_dirent))) &&	\

> +		if ((script_dirent.d_type != DT_DIR &&			\
> +		     script_dirent.d_type != DT_UNKNOWN) ||		\
> +		    (script_dirent.d_type == DT_UNKNOWN &&		\
> +		     !is_directory(lang_path, &script_dirent)))

		if (script_dirent.d_type != DT_DIR &&			\
		    (script_dirent.d_type != DT_UNKNOWN ||		\
		     !is_directory(lang_path, &script_dirent)))

(DeMorgan: !(a && b) <-> (!a || !b); !(a || b) <-> (!a && !b))

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
