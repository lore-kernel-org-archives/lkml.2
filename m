Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab2ITPGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:06:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab2ITPGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:06:43 -0400
Date: Thu, 20 Sep 2012 12:05:51 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] perf tool: Add a global variable "const char
 *input_name"
Message-ID: <20120920150551.GD26278@infradead.org>
References: <1348150779-17707-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348150779-17707-1-git-send-email-feng.tang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 20, 2012 at 10:19:39PM +0800, Feng Tang escreveu:
> Currently many perf ommands annotate/evlist/report/script/lock etc
> all support "-i" option to chose a specific perf data, and all
> of them create a local "input_name" to save the file name for
> that perf data.
> 
> So adding a global variable could unify all those local ones, and
> it will also be useful for other codes which need to know the file name.

But I think the input_name should be passed as a parameter to whoever
needs it. Think about 'perf diff', for instance, it deals with two
perf.data files.

In general I think we should _remove_ more globals :-)

- Arnaldo
