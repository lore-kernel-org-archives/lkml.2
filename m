Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1AYDEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 22:04:36 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47474 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1AYDEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 22:04:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KGXLPtM8aCe2wl182KsVHcXQC5kzjrBmBUC83+xpxFJIHX2J+PW4o42+Cpuk4VimBJ
         7PQdpUhVXlasIciJ8W39JAlDv4PMWcYID4k5dmUpkJh7CA328b3L3VAYdG8835I9XeTV
         QNhD2cHxcMWikl7akW2SUr99oV00GkqgktDGk=
MIME-Version: 1.0
In-Reply-To: <20110125024629.GA8931@sli10-conroe.sh.intel.com>
References: <1295915725.1949.967.camel@sli10-conroe>
	<AANLkTikOdiQR+rWXzoU9z5sJv9Q2=ehdhi1NCHXT0a-w@mail.gmail.com>
	<1295917864.1949.970.camel@sli10-conroe>
	<AANLkTimwSNsjR5PnVP8JvzwEBwy3VtDp4DvNecKsTnxJ@mail.gmail.com>
	<1295919258.1949.973.camel@sli10-conroe>
	<AANLkTikfxGF_4ZjJXP7kNChkDBnva5iStTPRLs3B86+c@mail.gmail.com>
	<20110125020123.GA30965@sli10-conroe.sh.intel.com>
	<AANLkTingD-=kXuNReEXeQGX3WVAAam5jVSBrkM2HCc-B@mail.gmail.com>
	<20110125024629.GA8931@sli10-conroe.sh.intel.com>
Date: Tue, 25 Jan 2011 14:04:33 +1100
Message-ID: <AANLkTinsv8zDU50bWhN+gvJn5fUZ9rx=sOkp0gdpexkB@mail.gmail.com>
Subject: Re: more dput lock contentions in 2.6.38-rc?
From: Nick Piggin <npiggin@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 1:46 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Tue, Jan 25, 2011 at 10:09:48AM +0800, Nick Piggin wrote:

>> What does an actual snippet from perf with callgraphs look like?
> here is another perf report

OK well there a lot of hits reading /proc/mounts and statfs, but still
more that appear to be coming from fstat/open/unlink/rename.

It looks like they are coming from dropping rcu walk along the path
rather than a full restart. So we will have to see where those are
coming from. My stats patch will help with that.

Thanks,
Nick
