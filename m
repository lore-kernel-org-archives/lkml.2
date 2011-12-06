Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab1LFLpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:45:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47009 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192Ab1LFLpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:45:50 -0500
MIME-Version: 1.0
In-Reply-To: <20111202053342.GA13877@p183.telecom.by>
References: <20111202053342.GA13877@p183.telecom.by>
Date: Tue, 6 Dec 2011 13:45:49 +0200
Message-ID: <CACVxJT94xTVO3i7tzLwrjTkFdr3+ve2e1VBg6UjzVfvthtgDfw@mail.gmail.com>
Subject: Re: Rewriting kernel config after generation
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mmarek@suse.cz, sam@ravnborg.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 2, 2011 at 7:33 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> I'm trying to add compiling with -march=native to the kernel.
> The problem is that then some config options become discoverable at
> the beginning of the compilation. For example,
> CONFIG_X86_L1_CACHE_SHIFT=6 can be derived from "--param l1-cache-line-size=64".
> I suspect this is no-go, because all the dependency logic must be
> duplicated somewhere else (in the march=native script) for the above
> to work.
>
> Is there any cleaner way I'm missing?
>
> In theory, such script could even turn off CONFIG_CPU_SUP_AMD
> if it detects Intel CPU.

Hrph, this is harder than it looks because "silentoldconfig" is done at
the beginning rewriting whatever changes done to .config by hand. :-(
