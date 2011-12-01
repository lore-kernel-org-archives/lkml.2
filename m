Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1LAPCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:02:06 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48831 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab1LAPCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:02:03 -0500
Date: Thu, 1 Dec 2011 16:01:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "acme@redhat.com" <acme@ghostprotocols.net>
Cc: Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v8)
Message-ID: <20111201150151.GA15110@somewhere.redhat.com>
References: <20110930134040.GA5575@quad>
 <20111129182231.GZ15738@erda.amd.com>
 <CABPqkBTR3tEGh7LymuS_JJR5SuCZfjTxZP-6qNxmZtBf0Zt9bg@mail.gmail.com>
 <20111130150829.GA15738@erda.amd.com>
 <20111130164946.GA27163@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130164946.GA27163@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 02:49:46PM -0200, acme@redhat.com wrote:
> Em Wed, Nov 30, 2011 at 04:08:29PM +0100, Robert Richter escreveu:
> > On 29.11.11 10:35:24, Stephane Eranian wrote:
> > >         sec_start = header->data_offset + header->data_size;
> > >         lseek(fd, sec_start + sec_size, SEEK_SET);
> > > 
> > >         err = do_write_feat(fd, header, HEADER_TRACE_INFO, &p, evlist);
> > >         if (err)
> > >                 goto out_free;
> > > 
> > >         err = do_write_feat(fd, header, HEADER_BUILD_ID, &p, evlist);
> > >         if (err) {
> > >                 perf_header__clear_feat(header, HEADER_BUILD_ID);
> > >                 goto out_free;
> > >         }
> 
> > > The 'clear_feat' is missing for TRACE_INFO, that's all. The question is:
> > > is case do_write_feat(trace_info) fails, is there still a way to parse the file
> > > correctly? If not, then perf should bail out, if yes, then we need to add the
> > > clear_feat(TRACE_INFO) in case of error.
> 
> > The question is, if do_write_feat() fails for HEADER_TRACE_INFO or
> > HEADER_BUILD_ID then perf_header__adds_write() fails. A failure of any
> > other feature simple disables it by calling clear_feat(). I noticed
> > this asymmetry and wonder why?

Not sure either. I must confess I didn't write that fixup part...

> > 
> > Also, is there a reason why HEADER_TRACE_INFO starts with bit 1 instead
> > of bit 0. Is bit 0 reserved for some reason?

Looks like a mistake I made from the beginning. And we can't really fix that
without breaking all perf.data :)
