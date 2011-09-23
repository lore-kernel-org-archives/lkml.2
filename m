Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab1IWTPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:15:41 -0400
Received: from cobra.newdream.net ([66.33.216.30]:37766 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab1IWTPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:15:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=M237usO4eEoWOdTDWMcBinxRG
	RqpKvQh3jTm4PuxzqqTzvRHldkqhuCpvLRSoCs8eF3jL8w1ZvbbsMaqiA11ZnEfW
	ts9qoStZshXEcu5yNEzp87RUMDqy48rfDfJ4GhutzUj3xtQ3zQjFhc8XFQaI5Za2
	c9nSITaairTAzTdQcM=
Date: Fri, 23 Sep 2011 12:15:37 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Noah Watkins <noahwatkins@gmail.com>
cc: ceph-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ceph: use kernel DNS resolver
In-Reply-To: <CAB2gnbVaS=x9hurY0P8x4Ltqh11foOpsMBy2MNt662T2X9+BLQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109231213580.31698@cobra.newdream.net>
References: <CAB2gnbVw2_FSWVVmUA1OobE1Ti9Q1w3AP_67=Vo4zwZtQ=gHYg@mail.gmail.com>
 <Pine.LNX.4.64.1109221426310.19558@cobra.newdream.net>
 <CAB2gnbVaS=x9hurY0P8x4Ltqh11foOpsMBy2MNt662T2X9+BLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011, Noah Watkins wrote:
> On Thu, Sep 22, 2011 at 14:29, Sage Weil <sage@newdream.net> wrote:
> > Currently the dns resolution is handled by mount.ceph and 'rbd map/unmap'.
> > I don't think that will go away (at the very least need to support old
> > kernels).
> 
> This is good to know. I never encountered the DNS lookup because I've
> always used a non-standard installation path, avoiding mount.ceph.
> 
> > Allowing this in the raw kernel interface would be nice, but I don't think
> > we want make DNS_RESOLVER a strict dependency, since it's new, kind of
> > kludgey, and a ripe target for compiling out of small or secure kernels.
> > Can you make it build either with or without it?
> 
> I sent out a new version of the patch that defines a libceph specific 
> configuration option to use the in-kernel dns resolver.

So I was actually thinking we could just #ifdef off of 
CONFIG_DNS_RESOLVER, but I think your approach might be better because 
you'll see it in the config process and turn it on, vs having to dig 
through to wherever DNS_RESOLVER lives in kconfig.

Maybe it should default y though?

sage
