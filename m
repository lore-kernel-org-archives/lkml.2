Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2BNVDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:03:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:59074 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab2BNVDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:03:20 -0500
Message-ID: <1329253391.2293.31.camel@twins>
Subject: Re: [PATCHv4 0/9] perf tool: parser generator for events parsing
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Date: Tue, 14 Feb 2012 22:03:11 +0100
In-Reply-To: <1329253030.2293.27.camel@twins>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
	 <1329236924.2293.13.camel@twins> <1329237838.2293.20.camel@twins>
	 <1329250830.2293.24.camel@twins> <1329253030.2293.27.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 21:57 +0100, Peter Zijlstra wrote:
> On Tue, 2012-02-14 at 21:20 +0100, Peter Zijlstra wrote:
> > OK, this one works. the attributes thing wants NULL termination.
> > Thanks
> > for mentioning that Jiri. 
> 
> OK, it mostly works, except:
> 
> perf record -e "cpu/config=0x108000c0/upp" ./loop_1b_locks
> 
> doesn't seem to work...

This seems to come back to hardcoding config* vs including it in every
single format description.

I prefer to have all perf_event_attr fields (of interest) hard-coded in
the parser so that we can omit them for all actual format descriptions.

These would be: period, config, config1, config2 and stephane's new
branch_sample_type, although that might want to get a shorter name.
