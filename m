Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2JFJ5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 05:57:48 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:56412 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755839Ab2JFJ5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 05:57:42 -0400
Message-ID: <1349517456.1491.33.camel@x61.thuisdomein>
Subject: Re: [PATCH] regmap: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Valdis.Kletnieks@vt.edu, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Sat, 06 Oct 2012 11:57:36 +0200
In-Reply-To: <20121006085306.GB8590@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
	 <20121001100321.GB4360@opensource.wolfsonmicro.com>
	 <64681.1349223065@turing-police.cc.vt.edu>
	 <1349249016.1414.55.camel@x61.thuisdomein>
	 <59004.1349475644@turing-police.cc.vt.edu>
	 <20121006085306.GB8590@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2012 09:57:36.0418 (UTC) FILETIME=[0352F020:01CDA3A9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-06 at 09:53 +0100, Mark Brown wrote:
> On Fri, Oct 05, 2012 at 06:20:44PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 03 Oct 2012 09:23:36 +0200, Paul Bolle said:
> > > That is another way to silence GCC here.
> 
> > That's probably a preferable approach - that way, if a bogus val_count gets
> > passed in, the caller will be informed of the fact.  Which is a lot better than
> > just papering over the warning.
> 
> As I hinted earlier if someone were to send me a patch...

0) I was hoping to do that. But in the mean time I also filed a bug
report for GCC (at Fedora's bugzilla) [0].

1) In that report (after actually closing it) Jakub Jelinek pointed at
the type mismatch between regmap_volatile_range()'s 'num' (unsigned int)
and its callers (both use size_t, both through 'val_count'). And,
indeed, changing 'num' to size_t also makes this warning go away.

This might explain why you didn't see a warning on 32 bit arm (if that
is what you running while looking at my patch).

2) I hope to send in a second path shortly, changing 'num' to size_t. My
main doubt is whether its problematic that the loop index in
regmap_volatile_range() uses unsigned int too. If 'num' would exceed
UINT_MAX, that loop would never finish, wouldn't it? But is that
actually possible? Are there machines with that many registers?


Paul Bolle

0) https://bugzilla.redhat.com/show_bug.cgi?id=862620

