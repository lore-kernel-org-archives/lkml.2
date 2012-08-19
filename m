Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2HSPXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:23:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58378 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2HSPXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:23:50 -0400
Date: Sun, 19 Aug 2012 17:23:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@suse.com>
Cc: andi@firstfloor.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, akpm@linux-foundation.org, jmario@redhat.com,
        rusty@rustcorp.com.au, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 59/74] lto: Handle LTO common symbols in module loader
Message-ID: <20120819152349.GV11413@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-60-git-send-email-andi@firstfloor.org> <5030B77E020000780008A233@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5030B77E020000780008A233@nat28.tlf.novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 09:53:02AM +0100, Jan Beulich wrote:
> >>> Andi Kleen <andi@firstfloor.org> 08/19/12 4:59 AM >>>
> >@@ -1904,6 +1904,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  >
> >        switch (sym[i].st_shndx) {
> >        case SHN_COMMON:
> >+            /* Ignore common symbols */
> >+            if (!strncmp(name, "__gnu_lto", 9))
> >+                break;
> >+
> >            /* We compiled with -fno-common.  These are not
> >               supposed to happen.  */
> >            pr_debug("Common symbol: %s\n", name);
> 
> I think it is dangerous to just match the start of the symbol name here -
> this may in the future well lead to ignoring symbols we shouldn't be
> ignoring.
> 
> Also I would think the added comment ought to say "Ignore LTO symbols."
> Otherwise its sort of contradicting the purpose of the case being handled
> here.

Ok maybe should error out. This case only happens with fat LTO when
the LTO step is not actually run.

It used to happen because old versions of this patchkit 
didn't correctly LTO modules

I'll change it to error out. The reason for the prefix was that
there is a __gnu_lto_vXXX and the version number could change.

Thanks for the reviewws.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
