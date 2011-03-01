Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab1CAFdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:33:49 -0500
Received: from lokagrupo.gerwinski.de ([213.239.212.49]:43118 "EHLO
	lokagrupo.gerwinski.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1CAFds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:33:48 -0500
Date: Tue, 1 Mar 2011 06:33:21 +0100
Message-ID: <1298957601.20632.221121@goedel.fjf.gnu.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=us-ascii
Subject: Re: brk() should check
	randomize_va_space rather then CONFIG_COMPAT_BRK
To: linux-kernel@vger.kernel.org, jkosina@suse.cz
References: <1298792275.19234.928360@goedel.fjf.gnu.de>
	<alpine.LNX.2.00.1102281524480.2160@pobox.suse.cz>
	<alpine.LNX.2.00.1102281530060.2160@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1102281530060.2160@pobox.suse.cz>
From: Frank Heckenbach <f.heckenbach@fh-soft.de>
User-Agent: semail 20060101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:

> On Mon, 28 Feb 2011, Jiri Kosina wrote:
> 
> > how do you avoid race here?
> > 
> > More precisely -- randomize_va_space can be changed in runtime, when 
> > already running processess have been started with different 
> > randomize_va_space value (and thus the shifting of mm->brk already 
> > happened in arch_randomize_brk())

I see. So would it help setting mm->brk = mm->start_brk =
mm->end_code if randomize_va_space < 2 in load_elf_binary() (and
elsewhere if needed -- not sure if other binformats are affected)?

> Oh, and also see the commit
> 
> 	commit 5520e89485252c759ee60d313e9422447659947b
> 	Author: Jiri Kosina <jkosina@suse.cz>
> 	Date:   Thu Jan 13 15:47:23 2011 -0800
> 
> 	    brk: fix min_brk lower bound computation for COMPAT_BRK
> 
> which is quite relevant here as well

AFAICS, this patch only changes the CONFIG_COMPAT_BRK case. I'm more
interested in the !CONFIG_COMPAT_BRK case (since my old binaries
work with CONFIG_COMPAT_BRK as is). Since e.g., Debian's default
kernel doesn't set CONFIG_COMPAT_BRK, I had hoped I could get them
to run by setting randomize_va_space to 0 or 1.

> (and you seem to be sending patch
> against code that doesn't have this patch applied).

Well, I used the last stable release; I hadn't noticed there was a
more recent change, sorry.

Frank
