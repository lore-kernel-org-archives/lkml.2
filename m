Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab0LMRPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:15:46 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:58615 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0LMRPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:15:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=feimgCH1ykMWfDKsoB3c9VErQ/KbNc6pz+CIgU7y7j7tCDTgjJvxlbsfLM2R+O14zw
         STR+ERrsNjL9R7d2uJJrj+wbK2vZqcekAqVuiYpUk5DI0r6hATKJ/TZfUc506I/236Cc
         rME6i3xVSuH8EdjHQe/NrOdszlvta3RYJYF6s=
Date: Mon, 13 Dec 2010 18:15:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Ahern" <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
Message-ID: <20101213171537.GC1691@nowhere>
References: <1291773285-16254-1-git-send-email-daahern@cisco.com>
 <1291773285-16254-2-git-send-email-daahern@cisco.com>
 <20101212201613.GA1784@nowhere>
 <4D06301C.2090309@cisco.com>
 <20101213155451.GA1691@nowhere>
 <20101213164854.GL5407@ghostprotocols.net>
 <20101213170923.GB1691@nowhere>
 <1292260289.6803.297.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292260289.6803.297.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 06:11:29PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-13 at 18:09 +0100, Frederic Weisbecker wrote:
> > 
> > 
> > Right, but Peter wanted us to get rid of these user events types.
> 
> Yes they suck.
> 
> > I guess we can't really do this as new perf tools must be able
> > to support old perf files.
> 
> Preferably, yes, but I don't see why we can't break the data file format
> if we've got good reasons to.

IMO we should prioritize the backward compatibility over some little code sanity.
It's worth a very small range of values to reserve in the kernel and we are done.
 
> > So this should be the last one to add. Something like PERF_RECORD_GEN_EVT
> > that has a field in its headers containing a sub-type which can be this
> > wall clock but can also host about everything in the future.
> > 
> > This way we don't propagate more the possible overlap with the kernel. 
> 
> I don't see why we should add more, that's going the wrong direction.

This must be the last one.
