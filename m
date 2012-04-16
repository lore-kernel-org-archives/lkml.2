Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2DPMRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 08:17:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab2DPMQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 08:16:59 -0400
Date: Mon, 16 Apr 2012 14:16:28 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
Message-ID: <20120416121627.GA1660@m.brq.redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
 <1334503015.28150.16.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334503015.28150.16.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 05:16:55PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-04-04 at 23:16 +0200, Jiri Olsa wrote:
> > - added 'group=...' syntax to group events (patches 1-5).
> 
> > - added 'group:1=...' syntax to specify which event to sample (leader) 
> 
> I'm still sad about not actually using {} for grouping. Esp. since you
> use ';' which needs escaping anyway:

yea, I realized we need ending separator after all ;)
so right we could use {} then..

so smth like:

  '{cycles,faults}'
   - anonymous group

  'group1{cycles,faults}
   - group with name 'group1'

  'group1:1{cycles,faults}
   - group with name 'group1' and modifier '1'

  'group1{cycles,faults},{instructions,cache-misses},faults'
  '{cycles,faults},group1:2{instructions,cache-misses},faults' ls
   - group/event combinations 


group:        group_spec '{' events '}'
group_spec:   name  ':' mod | empty


also, any thoughts about the displaying question? ;)

> I'm looking on how to present this data in perf and it seems we need
> to reset all siblings once we read/store them (in kernel) to the
> leader sample.
> 
> My current thinking is to store siblings' sum values for each
> hists entry of the sample (perf report count unit) .. and display
> them in similar way we display callchains: for each hists entry
> display the sum value for each sibling.
> 
> Could you provide more of your world examples? Your expectations about
> presenting this..
> 
> Maybe we want to make the reset optional, and do some do some other
> math with siblings' values..?

Not sure it could affect the syntax, but it'd be better to have
whole picture

thanks,
jirka
