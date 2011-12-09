Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab1LIOpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:45:01 -0500
Received: from mx0.aculab.com ([213.249.233.131]:50373 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754005Ab1LIOo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:44:59 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v8 1/9] Basic kernel memory functionality for the Memory Controller
Date: Fri, 9 Dec 2011 14:44:45 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AF0D@saturn3.aculab.com>
In-Reply-To: <4EE21D23.4000309@parallels.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v8 1/9] Basic kernel memory functionality for the Memory Controller
Thread-Index: Acy2gEs9H2EJ/4kgRB+dTyn5866RcQAAEu8A
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Glauber Costa" <glommer@parallels.com>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <linux-kernel@vger.kernel.org>, <lizf@cn.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>, <eric.dumazet@gmail.com>,
        <cgroups@vger.kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        "Paul Menage" <paul@paulmenage.org>
X-OriginalArrivalTime: 09 Dec 2011 14:44:45.0970 (UTC) FILETIME=[182F6F20:01CCB681]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> How about this?
> 
>          val = !!val;
> 
>          /*
>           * This follows the same hierarchy restrictions than
>           * mem_cgroup_hierarchy_write()
>           */
>          if (!parent || !parent->use_hierarchy) {
>                  if (list_empty(&cgroup->children))
>                          memcg->kmem_independent_accounting = val;
>                  else
>                          return -EBUSY;
>          }
>          else
>                  return -EINVAL;
> 
>          return 0;

Inverting the tests gives easier to read code:

	if (parent && parent->user_hierarchy)
		return -EINVAL;
	if (!list_empty(&cgroup->children))
		return -EBUSY;
	memcg->kmem_independent_accounting = val != 0;
	return 0;

NFI about the logic...
On the face of it the tests don't seem related to each other
or to the assignment!

	David

	


