Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1BROx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:53:59 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59698 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1BROx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:53:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=CdcCDZkgC2Ld7QY1o1WlakLwlvxRJF4Vl2MktbkXZLJNTqTZ+7MH/JPvU1/W5xi3EF
         /WRQ7fTOD8TMvhA62Zuvmaofb2WnQhWBhqPFeBhNktN618/FHKcBI+ghA8k/SWT+DuIF
         y4bEm97enYFOSb4Ph+gtooSVEfHKgAXiP8n8M=
Date: Fri, 18 Feb 2011 12:53:48 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org
Subject: Re: [PATCH 1/3] perf events: fix WARN_ON_ONCE for 64-bit raw data,
 SW events
Message-ID: <20110218145348.GA302@ghostprotocols.net>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
 <1298008433-22911-2-git-send-email-daahern@cisco.com>
 <1298026821.5226.642.camel@laptop>
 <4D5E8338.8010602@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5E8338.8010602@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 18, 2011 at 07:33:28AM -0700, David Ahern escreveu:
> On 02/18/11 04:00, Peter Zijlstra wrote:
> > On Thu, 2011-02-17 at 22:53 -0700, David Ahern wrote:
> >> This check does not work out for 64-bit counter:
> >>
> >>     sizeof(u32) + sizeof(u64) = 4 + 8 = 12
> >>
> >> which does not pass the WARN_ON_ONCE test. I'm guessing (hoping
> >> really) that the intent is that the size of the raw data is a
> >> multiple of 4 bytes, not 8.
> > 
> > No the data must come in 8bytes strides.
> > 
> 
> Then the sizeof the size field needs to be moved to u64; right now it is
> u32:
> 
> struct perf_raw_record {
>     u32             size;
>     void                *data;
> };
> 
> So size should be changed to u64 rather than modifying the WARN_ON_ONCE?

Yeah, I guess so, 32-bit has to die it seems, gets in the way of testing
:-)

- Arnaldo
