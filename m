Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2JPQtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:49:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45713
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728Ab2JPQtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:49:32 -0400
Date: Tue, 16 Oct 2012 12:49:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v4 6/6] perf stat: implement --big-num grouping
Message-ID: <20121016164928.GB8020@infradead.org>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
 <1350344020-8071-7-git-send-email-irina.tirdea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350344020-8071-7-git-send-email-irina.tirdea@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 02:33:40AM +0300, Irina Tirdea wrote:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> In glibc, printf supports ' to group numbers with thousands' grouping
> characters. Bionic does not support ' for printf.
> 
> Implement thousands's grouping for numbers according to locale.
> The implementation uses the algorithm from glibc
> (http://www.gnu.org/software/libc/).
> 
> Bionic does not implement locales, so we need to add a configuration
> option LOCALE_SUPPORT. If it is not defined, default values for thousands
> separator and grouping are used.

Duplicating this in perf sounds like a hack.  Does gnulib provide this
feature?  It's the canonical source for getting standards or helper
functions on systems that don't support them.

