Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab2DZWUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:20:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48540 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2DZWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 18:20:36 -0400
Date: Thu, 26 Apr 2012 15:20:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.4-rc4 oom killer out of control.
In-Reply-To: <20120426215257.GA12908@redhat.com>
Message-ID: <alpine.DEB.2.00.1204261517100.28376@chino.kir.corp.google.com>
References: <20120426193551.GA24968@redhat.com> <alpine.DEB.2.00.1204261437470.28376@chino.kir.corp.google.com> <20120426215257.GA12908@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012, Dave Jones wrote:

> /sys/kernel/mm/ksm/full_scans is increasing constantly
> 
> full_scans: 146370
> pages_shared: 1
> pages_sharing: 4
> pages_to_scan: 1250
> pages_unshared: 867
> pages_volatile: 1
> run: 1
> sleep_millisecs: 20
> 

full_scans is just a counter of how many times it has scanned mergable 
memory so it should be increasing constantly.  Whether pages_to_scan == 
1250 and sleep_millisecs == 20 is good for your system is unknown.  You 
may want to try disabling ksm entirely (echo 0 > /sys/kernel/mm/ksm/run) 
to see if it significantly increases responsiveness for your workload.
