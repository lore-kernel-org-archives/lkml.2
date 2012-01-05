Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab2AEXBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:01:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50554 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab2AEXBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:01:15 -0500
Date: Thu, 5 Jan 2012 15:01:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Rik van Riel <riel@redhat.com>, Greg KH <gregkh@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net, aarcange@redhat.com,
        mel@csn.ul.ie, dima@android.com, rebecca@android.com, san@google.com,
        akpm@linux-foundation.org, vesa.jaaskelainen@nokia.com,
        Minchan Kim <minchan@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and related
 changes in MM
In-Reply-To: <CAOJsxLH8s5cjUSdpBpLNDvtNaJjnhBwNKOMXZPzUD=XDivr7Rg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1201051458560.10521@chino.kir.corp.google.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com> <20120104195612.GB19181@suse.de> <4F04B3F0.6080103@redhat.com> <CAOJsxLH8s5cjUSdpBpLNDvtNaJjnhBwNKOMXZPzUD=XDivr7Rg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jan 2012, Pekka Enberg wrote:

> And even if people want to support multiple ABIs and fight it out to
> see which one wins, we should factor out the generic parts and put
> them under mm/*.c and not hide them in random modules.
> 

Agreed.  This came up recently when another lowmem killer was proposed and 
the suggestion was to enable the memory controller to be able to have the 
memory threshold notifications with eventfd(2) and cgroup.event_control.  
It would be very nice to have a generic lowmem notifier (like 
/dev/mem_notify that has been reworked several times in the past) rather 
than tying it to a particular cgroup, especially when that cgroup incurs a 
substantial overhead for embedded users.
