Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab1JDNmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 09:42:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65174 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab1JDNmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 09:42:07 -0400
Date: Tue, 4 Oct 2011 10:41:55 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
Message-ID: <20111004134155.GA31979@ghostprotocols.net>
References: <20110929230613.GA20083@ghostprotocols.net>
 <4E850056.1090101@gmail.com>
 <1317368359.19415.0.camel@twins>
 <4E8A8842.9010509@gmail.com>
 <1317722412.25926.16.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317722412.25926.16.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 04, 2011 at 12:00:12PM +0200, Peter Zijlstra escreveu:
> On Mon, 2011-10-03 at 22:14 -0600, David Ahern wrote:
> > On 09/30/2011 01:39 AM, Peter Zijlstra wrote:
> > > On Thu, 2011-09-29 at 17:33 -0600, David Ahern wrote:
> > >>> For record that means we need to dump each per-sample_id mmap onto a
> > >>> separate file, i.e. use a directory, etc.

> > >> That seems like a major re-write of perf. 

> > > Well we want to go there anyway. A file per cpu stream can be a lot less
> > > overhead than one file for all cpu streams.

> > really it becomes file per cpu stream and per sample type. So a dual
> > socket, quad core with HT means 16 files per sample type. ie., the
> > number of files explodes quick.

> > I understand the allure for simplicity during the data collection. Has
> > any thought been given on management of the files in such a scenario?
> > User specifies a directory path instead of a file path - or both to
> > handle backward compatibility?

> I think the idea was a directory and a script to convert old data files
> to the new format. But it was a while ago acme and I talked about this.

I don't remember the script idea, but that would work too.

WRT major rewrites, well, as we go on developing any piece of software,
those kinds of things happen :-)

If it is to improve things, make them faster, cope with new hardware
realities, keep our jobs, so be it! ;-)

- Arnaldo
