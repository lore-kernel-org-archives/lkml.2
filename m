Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab0LWMzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 07:55:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49248 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0LWMzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 07:55:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FWO62heyz1pojIWUPQhdKGpEJfZSO5PzdroBvL0Vu+SeYTXQjAGoFnaRQyjBz0GNId
         ptFydkh3TS1wIpfTG2xJdViPsAtsdtHZlf/3AFJgOTfPMPg3ia9oqjml3bvBJbcqsKe0
         oHbn/LrS/BBQJ5AIgONFTY18wHLXOPHN4A5AE=
Date: Thu, 23 Dec 2010 13:55:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: buggy perf callgraph output
Message-ID: <20101223125535.GA1769@nowhere>
References: <20101208164015.GA5444@amd>
 <20101208214809.GG1709@nowhere>
 <20101215130245.GA10004@amd>
 <20101216114755.GA1687@nowhere>
 <20101217053258.GC3282@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217053258.GC3282@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 04:32:58PM +1100, Nick Piggin wrote:
> That would be great, thanks! It's a really awesome tool, I appreciate
> your effort on it.

Thanks :)

So the below patch should fix the issue. Tell me if you encounter it
again, or anything else.

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d503670..c749ba6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -356,7 +356,7 @@ static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
 
 static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 				     int depth, int depth_mask, int period,
-				     u64 total_samples, int hits,
+				     u64 total_samples, u64 hits,
 				     int left_margin)
 {
 	int i;

