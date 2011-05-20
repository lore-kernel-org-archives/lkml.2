Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1ETX6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 19:58:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58841 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab1ETX56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 19:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vf1nITC7KcUvygsWuW3lOrjQBWHKgLwkIZ3G15EKzHfmyUJJQgzUNdeK7iO/E0EG/7
         2elletJy8Ga0QGlfrA3z9lLG5493hKE0lhh5lQPTKxS1gUa66Dk2k3qqEQslXa7Kw91v
         dj/gFQBFNLC3F3qJ4Z7RtQEGw6yFCR2FoAPTc=
MIME-Version: 1.0
In-Reply-To: <20110520144919.57541b8d.akpm@linux-foundation.org>
References: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520124212.facdc595.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520144919.57541b8d.akpm@linux-foundation.org>
Date: Sat, 21 May 2011 08:57:57 +0900
Message-ID: <BANLkTikeEw4WNutzBs5bVnrmUs23dfVPug@mail.gmail.com>
Subject: Re: [PATCH 2/8] memcg: easy check routine for reclaimable
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, hannes@cmpxchg.org,
        Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/21 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 20 May 2011 12:42:12 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> +bool mem_cgroup_test_reclaimable(struct mem_cgroup *memcg)
>> +{
>> +     unsigned long nr;
>> +     int zid;
>> +
>> +     for (zid = NODE_DATA(0)->nr_zones - 1; zid >= 0; zid--)
>> +             if (mem_cgroup_zone_reclaimable_pages(memcg, 0, zid))
>> +                     break;
>> +     if (zid < 0)
>> +             return false;
>> +     return true;
>> +}
>
> A wee bit of documentation would be nice.

Yes, I'll add some.

>  Perhaps improving the name
> would suffice: mem_cgroup_has_reclaimable().
>
ok, I will use that name.

-Kame
