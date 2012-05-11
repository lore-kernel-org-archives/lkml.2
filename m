Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946138Ab2EKRxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:53:39 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:34019 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1945931Ab2EKRxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:53:36 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jIBYBkEVM1nT__0rzms64B8UIAo4RciTfwzx1zdJrpmNCay
 KvLXXJELr5FPbvWYElTgqngSq9RmmS8TfHg6NwDA42nnTbSVyOcTLjMdIG18
 I7sGbTrIcYy1UCONr73Zqja3NEi_gbGsvki9zXEENOZpDEiHXZAy7JnTmnRO
 u8z8rTgfykVSk7m5ROcFcyUxMKX42Z_toWWBvHmkqovQU3TgCzMGKyv39CFy
 DVHEKMF5dJVMpZ.fv97xEU2FQaf7cxxu__1Slc0FcdLfoELbsIiPMm9OnW8A
 TgAL2lFVeqFYYBx1tIGygsVCkWXgxl5pzGz7.yO1cFrQoBtedlC6KEYE.qnI
 51yhF29ZfQEC2HpZQVU.eXmn067EDY5QbzMcryENw7HQ_.gSgogpDMLPkmdr
 B
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 May 2012 12:53:31 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 04/29] slub: always get the cache from its page in
 kfree
In-Reply-To: <1336758272-24284-5-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205111251420.31049@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Glauber Costa wrote:

> struct page already have this information. If we start chaining
> caches, this information will always be more trustworthy than
> whatever is passed into the function

Other allocators may not have that information and this patch may
cause bugs to go unnoticed if the caller specifies the wrong slab cache.

Adding a VM_BUG_ON may be useful to make sure that kmem_cache_free is
always passed the correct slab cache.
