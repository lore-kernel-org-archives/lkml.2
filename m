Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab2ITGy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:54:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46039 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2ITGy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:54:57 -0400
Date: Wed, 19 Sep 2012 23:54:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Out of memory on 3.5 kernels
In-Reply-To: <20120920060202.GB10758@schottelius.org>
Message-ID: <alpine.DEB.2.00.1209192351440.30029@chino.kir.corp.google.com>
References: <20120920060202.GB10758@schottelius.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Nico Schottelius wrote:

> for some time the slab usage is quite high (~3.2 GiB) and whenever I try
> to do a backup with ccollect (which is using rsync), a lot of processes
> (like chromium) are being killed over night.
> 

Yeah, over 81% of your memory is consumed by slab and that doesn't shrink 
over the duration of the log you posted.  It would be interesting to see 
if there was a leak somewhere: try looking at slabtop and determining if 
you have a cache using an egregious amount of memory; if there aren't any 
clear winners, then we'll still see what is hogging most of your memory 
and see how it compares to 3.4.2.  You can also check if there is a leak 
using kmemleak, but this requires a reboot (see 
Documentation/kmemleak.txt).
