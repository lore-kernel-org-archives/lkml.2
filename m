Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1HKRic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:38:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42918 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab1HKRi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:38:29 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: running of out memory => kernel crash
Date: Thu, 11 Aug 2011 19:38:25 +0200
User-Agent: KMail/1.8.2
Cc: David Rientjes <rientjes@google.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>,
        "\"linux-mm@kvack.org\"" <linux-mm@kvack.org>
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com> <CAK1hOcN7q=F=UV=aCAsVOYO=Ex34X0tbwLHv9BkYkA=ik7G13w@mail.gmail.com> <1313075625.50520.YahooMailNeo@web111715.mail.gq1.yahoo.com>
In-Reply-To: <1313075625.50520.YahooMailNeo@web111715.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201108111938.25836.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 August 2011 17:13, Mahmood Naderan wrote:
> >What it can possibly do if there is no swap and therefore it 
> 
> >can't free memory by writing out RAM pages to swap?
> 
> 
> >the disk activity comes from constant paging in (reading)
> >of pages which contain code of running binaries.
> 
> Why the disk activity does not appear in the first scenario?

Because there is nowhere to write dirty pages in order to free
some RAM (since you have no swap) and reading in more stuff
from disk can't possibly help with freeing RAM.

(What kernel does in order to free RAM is it drops unmodified
file-backed pages, and doing _that_ doesn't require disk I/O).

Thus, no reading and no writing is necessary/possible.


> >Thus the only option is to find some not recently used page
> > with read-only, file-backed content (usually some binary's 
> 
> >text page, but can be any read-only file mapping) and reuse it.
> Why "killing" does not appear here? Why it try to "find some 
> 
> recently used page"?

Because killing is the last resort. As long as kernel can free
a page by dropping an unmodified file-backed page, it will do that.
When there is nothing more to drop, and still more free pages
are needed, _then_ kernel will start oom killing.

-- 
vda
