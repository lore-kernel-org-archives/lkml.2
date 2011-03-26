Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab1CZAEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:04:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35396 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab1CZAEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=i22EN2M3Vpp+pdz8eaFn9ulenM4GVA42TB/BG2rjVRgy+Yx4rjidsZIl+Fv3Di8aCY
         A6BGUVzyReF1+lWbtv+BWoGoR1fPHYUq468oF889f/AuXMwrpjbiDKxRkFZxcn0Ih/+Z
         Djpk3rQ8roDdN7hjrfEhHHAPh0eo2E76Kknsg=
MIME-Version: 1.0
In-Reply-To: <AANLkTin51sZ2fsOzfaSWQCWkrQ+JkyVWNnM022E2GFwQ@mail.gmail.com>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110324105222.GA2625@barrios-desktop>
	<20110325090411.56c5e5b2.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=f3gu7-8uNiT4qz6s=BOhto5s=7g@mail.gmail.com>
	<20110325115453.82a9736d.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTim3fFe3VzvaWRwzaCT6aRd-yeyfiQ@mail.gmail.com>
	<AANLkTin51sZ2fsOzfaSWQCWkrQ+JkyVWNnM022E2GFwQ@mail.gmail.com>
Date: Sat, 26 Mar 2011 09:04:14 +0900
Message-ID: <AANLkTimvu2xEnDvF=HDqDxoOECp=56yj08CMSa=Fsru9@mail.gmail.com>
Subject: Re: [PATCH 0/4] forkbomb killer
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Colin Walters <walters@verbum.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you set up cpu+memory cgroup properly, I think it works well.

For well scheduled servers or some production devices, all
applications and relationship
of them can be designed properly and you can find the best cgroup set.

For a some desktop environ like mine, which has 1-4G of memory, I think a user
doesn't want to divide resources (limiting memory) for emergency
because I want to
use full resources of my poor host. Of course, I use memcg when I
handle very big
file or memory by an application when I can think of bad effects of that.

And, with experiences in ML.... I've advised "please use memcg" when I see
emails/questions about OOM....but there are still periodic OOM report to ML ;)
Maybe usual users doesn't pay costs to avoid some emergency by themselves.
(Some good daemon software should do that.)

I feel the kernel itself should have the last resort to quit
hard-to-recover status.

Thanks,
-Kame
