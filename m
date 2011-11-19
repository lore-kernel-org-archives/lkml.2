Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1KSQd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 11:33:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34164 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1KSQd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 11:33:26 -0500
Date: Sat, 19 Nov 2011 20:30:58 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 3/3] security: Yama: add ptrace relationship tracking
 interface
Message-ID: <20111119163058.GA3131@albatros>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
 <1319672956-17114-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319672956-17114-4-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

Thank you for working on this!  We'll use Yama in Openwall too :-)

On Wed, Oct 26, 2011 at 16:49 -0700, Kees Cook wrote:
> +	if (mode == PTRACE_MODE_ATTACH &&
> +	    ptrace_scope &&
> +	    !capable(CAP_SYS_PTRACE) &&
> +	    !task_is_descendant(current, child) &&
> +	    !ptracer_exception_found(current, child))
> +		rc = -EPERM;

capable() is better to put after all other tests as a failed capable()
might emit a false positive warning into logs or something.

Thanks,

-- 
Vasiliy
