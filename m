Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab2EKSGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:06:45 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:23271 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933067Ab2EKSGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:06:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: sSe1gaUVM1kSFynf23djkWegyS3yy1OwKvLkY1.W88wFOST
 GtIumnc5T1Evw4XGe0vYKupI3dxTowEFRWY1NblCk5S0YqtD9vOfdLsa9MeD
 N.H97pjNCZLO9BLeXm_sBGg8xBK2CLypioFL8uBh.z_A3nYhj.w7rUdWKMq_
 fumzejLOVgQ6Hnm5uZc0pi8bSlxZR0cFTBika4jqmtYTot4aqCGw_2R3giGA
 dNxGB5bapIcTg78EOfPas.4CwFRMIddJ_fdrXeFeqpWe3GpDlDGG7kk3fQWw
 gUuNbP4sxVN9YECMiklbyru11rSwbaxlC0S3MwU9qGE.Dl_jo3qbY0iWCpZu
 ynr9ic.wphwSDht2TuTMVKxk6ZmvZH_TwXKAOUE3cXk22iKOEIztZGAcrrO8
 biqoBQV.pMOLPhi2fzKno87BaXYDLeRT9IBkb
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 May 2012 13:06:36 -0500 (CDT)
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
In-Reply-To: <4FAD531D.6030007@parallels.com>
Message-ID: <alpine.DEB.2.00.1205111305570.386@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205111251420.31049@router.home> <4FAD531D.6030007@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Glauber Costa wrote:

> > Adding a VM_BUG_ON may be useful to make sure that kmem_cache_free is
> > always passed the correct slab cache.
>
> Well, problem is , it isn't always passed the "correct" slab cache.
> At least not after this series, since we'll have child caches associated with
> the main cache.
>
> So we'll pass, for instance, kmem_cache_free(dentry_cache...), but will in
> fact free from the memcg copy of the dentry cache.

Urg. But then please only do this for the MEMCG case and add a fat big
warning in kmem_cache_free.
