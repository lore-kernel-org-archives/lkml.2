Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab0ESMIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:08:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:34962 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab0ESMII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:08:08 -0400
Date: Wed, 19 May 2010 09:07:48 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [BUG] perf: record does not seem to store buildids anymore
Message-ID: <20100519120747.GF14367@ghostprotocols.net>
References: <AANLkTimmScKO8YnPJWfTqFXBXQYwbbdej-gaYnHCgeTc@mail.gmail.com>
 <1274242869.16737.25.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274242869.16737.25.camel@tropicana>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 18, 2010 at 11:21:09PM -0500, Tom Zanussi escreveu:
> Neither the live-mode nor inject patches should have changed how offline
> processing happens - that case still uses the original perf header write
> path.
> 
> I think the introduction of the 'machines' abstraction may have broken
> build ids - looking for instance at perf_header__adds_write(), the
> HEADER_BUILD_ID feature is set when dsos__read_build_ids() returns true,
> but the session->machines loop that reads the build_ids doesn't seem to
> have the host machine in it, so doesn't find any buildids for the host,
> and therefore doesn't set the feature or later write the buildid table.
> 
> I was able to get the buildids written by adding the host_machine to the
> loop in dsos__read_build_ids() and dsos__write_buildid_table() and was
> able to see them using 'perf buildid-list' by also adding host_machine
> to perf_session__fprintf_dsos_buildid().
> 
> I'm guessing this isn't the right way to fix it, as the code that deals
> with the buildids seems to assume that the host_machine is also in the
> session->machines list, so I'll have to look into it some more myself
> before sending a patch, unless someone beats me to it ;-)

Well spotted, I introduced this bug when moving the host machine out of
the list of machines so that we didn't had to lookup it everytime we
needed it.

If you don't send it before I have breakfast I'll fix it :-)

- Arnaldo
