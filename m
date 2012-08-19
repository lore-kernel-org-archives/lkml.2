Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2HSP3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:29:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58400 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2HSP3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:29:19 -0400
Date: Sun, 19 Aug 2012 17:29:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@suse.com>
Cc: andi@firstfloor.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, akpm@linux-foundation.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 03/74] sections: Make external kallsyms tables __visible
Message-ID: <20120819152918.GX11413@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-4-git-send-email-andi@firstfloor.org> <5030A96F020000780008A1F1@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5030A96F020000780008A1F1@nat28.tlf.novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 08:53:03AM +0100, Jan Beulich wrote:
> >>> Andi Kleen <andi@firstfloor.org> 08/19/12 5:02 AM >>>
> >-extern const unsigned long kallsyms_addresses[] __attribute__((weak));
> >-extern const u8 kallsyms_names[] __attribute__((weak));
> >+extern __visible const unsigned long kallsyms_addresses[] __attribute__((weak));
> >+extern __visible const u8 kallsyms_names[] __attribute__((weak));
>  
> Shouldn't we minimally aim at consistency here:
> - all attributes in a one place (I personally prefer the placement between type
>   and name, for compatibility with other compilers, but there are rare cases -
>   iirc not on declarations though - where gcc doesn't allow this)

Ok.

> - not using open coded __attribute__(()) when a definition (here: __weak) is
>   available, or alternatively open coding all of them (__attribute__((weak, ...)))?

I just kept the original code. But yes it should be using __weak.
I can change that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
