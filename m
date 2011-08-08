Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1HHMZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:25:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46116 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1HHMZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:25:46 -0400
Subject: Re: regarding [PATCH] Add libpfm4 support (v3)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>
Date: Mon, 08 Aug 2011 14:25:25 +0200
In-Reply-To: <20110808120432.GB2076@jolsa.brq.redhat.com>
References: <20110808120432.GB2076@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312806326.10488.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 14:04 +0200, Jiri Olsa wrote:
> hi,
> 
> any chance of getting this included?
> http://article.gmane.org/gmane.comp.linux.perfmon2.devel/2912
> http://article.gmane.org/gmane.comp.linux.perfmon2.devel/2912/raw
> 
> it needs just some little changes to fit to current tip tree

While I don't mind extending the current way to input events I don't
think using libpfm4 for it is desired.

One of the ideas that has been floating about is to provide a format
file in the sysfs representation of the pmu. This format file would
describe the config space. The tool would parse this and use it to
provide better input capabilities.

This is not an easy task however, since the format syntax needs to be
capable enough to describe all the various config muck we need to
support, think for example of the P4 mess.

For Intel/AMD (excluding P4) its mostly simple, with Intel having a
slightly harder time for the offcore bits.

As to the various arch event lists, again that is not something we need
a whole library for, parsing those text files isn't hard. Maintaining
the various arch event lists in a sane format is the 'hard' part and is
something I think we should push to the vendors, because they're
basically the only ones capable.


