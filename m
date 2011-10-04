Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1JDKBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:01:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:34666 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab1JDKBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:01:14 -0400
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Oct 2011 12:00:12 +0200
In-Reply-To: <4E8A8842.9010509@gmail.com>
References: <20110929230613.GA20083@ghostprotocols.net>
	  <4E850056.1090101@gmail.com> <1317368359.19415.0.camel@twins>
	 <4E8A8842.9010509@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317722412.25926.16.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 22:14 -0600, David Ahern wrote:
> On 09/30/2011 01:39 AM, Peter Zijlstra wrote:
> > On Thu, 2011-09-29 at 17:33 -0600, David Ahern wrote:
> >>> For record that means we need to dump each per-sample_id mmap onto a
> >>> separate file, i.e. use a directory, etc.
> >>
> >> That seems like a major re-write of perf. 
> > 
> > Well we want to go there anyway. A file per cpu stream can be a lot less
> > overhead than one file for all cpu streams.
> > 
> 
> really it becomes file per cpu stream and per sample type. So a dual
> socket, quad core with HT means 16 files per sample type. ie., the
> number of files explodes quick.
> 
> I understand the allure for simplicity during the data collection. Has
> any thought been given on management of the files in such a scenario?
> User specifies a directory path instead of a file path - or both to
> handle backward compatibility?

I think the idea was a directory and a script to convert old data files
to the new format. But it was a while ago acme and I talked about this.
