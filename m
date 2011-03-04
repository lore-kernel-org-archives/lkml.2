Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056Ab1CDN4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:56:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56440 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab1CDN4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:56:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mMT8JCV4ABApHbB80bM3+QOWORor47AI7wsuHH2X8UBxcqA/CfowvhqIsStLpb1B+X
         V6VTp7f8kAhS4Mq4PAvErPuP6kvHaGql+wkowJkDOkv3yRC/nji7HXagoEiFOo/7FJcO
         69kKSLTXi2afHFica5OU9A+CWS+v40pZDlQTU=
Date: Fri, 4 Mar 2011 14:56:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf lock: clean the options for perf record
Message-ID: <20110304135635.GB1972@nowhere>
References: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <4D63D685.2010401@dcl.info.waseda.ac.jp>
 <1298389415.2217.243.camel@twins>
 <20110222182206.GB1799@nowhere>
 <4D648A65.2040107@dcl.info.waseda.ac.jp>
 <4D667D60.5010903@dcl.info.waseda.ac.jp>
 <20110224165014.GB1840@nowhere>
 <4D67E286.8010907@dcl.info.waseda.ac.jp>
 <AANLkTikUGO=Obm7Ue4VzEueQ7DERPiwci1VV9NmKZf1u@mail.gmail.com>
 <4D70B3E1.8020108@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D70B3E1.8020108@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 06:41:53PM +0900, Hitoshi Mitake wrote:
> On 03/01/11 23:55, Frederic Weisbecker wrote:
> >On Sat, Feb 26, 2011 at 02:10:30AM +0900, Hitoshi Mitake wrote:
> >>It seems that I was too preprocessed with the method and
> >>forgot the purpose...
> >>
> >>Maybe the things like simple lockstat visualizer or
> >>special diff between two lockstat snapshots are
> >>useful for the first looking at big picture.
> >>I feel that they have worth to write and test.
> >
> >Indeed they sound like good ideas. Being able to do a diff
> >on locks profiles would be useful to compare two changes on
> >the kernel.
> >
> 
> BTW, how do you think about the idea of exporting data in
> python (or other neutral) expression from procfs? I feel it is a
> good idea. Communicating with unified format between user space and
> kernel space will reduce lots of parsing overhead. Is this too
> aggressive or insane?

Well, I'm not sure about the goal of parsing that lockstat file.

lockstat is a global measurement since the boot. One of the point with
perf is that you can measure the same things than lockstat (and more)
on a delimited context and time slice: a process or a cpu for a given time.

So the right source is more on perf.data resulting in a precise measurement
than in a global /proc/, right?
