Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2ANXTG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 18:19:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab2ANXTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 18:19:04 -0500
Date: Sun, 15 Jan 2012 00:19:03 +0100
From: Michal Marek <mmarek@suse.cz>
To: Jean Sacren <sakiwit@gmail.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        amwang@redhat.com
Subject: Re: [PATCH] kbuild: Fix compiler warning with assertion when calling
 'fwrite'
Message-ID: <20120114231902.GB19267@sepie.suse.cz>
References: <87lisype1v.fsf@faui43f.informatik.uni-erlangen.de>
 <CACqU3MWZuqgpxG7FSvr2LkqTqwF-gQM8hQSnTTpHpcWT2LHGNA@mail.gmail.com>
 <4EC8FF93.7010706@suse.cz>
 <20111123055351.GB14454@mail.gmail.com>
 <877h2r1hb3.fsf@faui43f.informatik.uni-erlangen.de>
 <CACqU3MXe3vu8OmcTsU4u8h+zWfOyo455Q-RLAJrADJM4xoJnPg@mail.gmail.com>
 <20111125234253.GD14454@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111125234253.GD14454@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 04:42:53PM -0700, Jean Sacren wrote:
> Reinhard Tartler discovered a corner case of calling xfwrite() where the
> length of the string is zero.
> 
> Arnaud Lacombe suggested to use assertion for the corner case, as
> fwrite(3) is currently used:
> 
>  1) in comment printers. Empty comment are not allowed.
>  2) in a callback passed to expr_print(), where the string printed is
>     either NULL OR non-empty.
>  3) in the lexer, auto-generated, and unused.
> 
> I feel using assertion is a good solution:
> 
>  1) It cleanly takes care of the above-mentioned corner case.
>  2) It can be easily disabled by defining NDEBUG.
>  3) It asserts xfwrite() is simply a wrapper for fwrite().
> 
> Reported-by: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>

Applied to kbuild.git#kconfig.

Michal
