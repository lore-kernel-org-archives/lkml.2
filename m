Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1LSTMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:12:15 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58692 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab1LSTMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:12:13 -0500
Date: Mon, 19 Dec 2011 11:12:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Android low memory killer vs. memory pressure notifications
In-Reply-To: <20111219121255.GA2086@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1112191110060.19949@chino.kir.corp.google.com>
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru> <20111219121255.GA2086@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, Michal Hocko wrote:

> page_cgroup is 16B per page and with the current Johannes' memcg
> naturalization work (in the mmotm tree) we are down to 8B per page (we
> got rid of lru). Kamezawa has some patches to get rid of the flags so we
> will be down to 4B per page on 32b. Is this still too much?
> I would be really careful about a yet another lowmem notification
> mechanism.
> 

There was always general interest in a low memory notification mechanism 
even prior to memcg, see http://lwn.net/Articles/268732/ from Marcelo and 
KOSAKI-san.  The desire is not only to avoid the metadata overhead of 
memcg, but also to avoid cgroups entirely.
