Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2E2T0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 15:26:09 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:21235 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754088Ab2E2T0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 15:26:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xVQjavwVM1nMeH_Iu0jYQC.Bzqe8Pfn7iVxlr_rmz0aCJNp
 g6oDUgVmST1vkFijna7tNTbkwW8W95dPo5w4Fv12Oyb3gPhy4PRTlUMgQwaM
 m3xiHrld0u7R54K85bpytyvbksJMaMkmRmjlTzKVSkz.tzGesD1QQm6V3LH3
 xIYiZIs8WzGCbwFI9SQbYnTQmZwLgtxXvN63HFSrCPmohqP.xja8XGGfGeqS
 o9MxPuH.9zq5PRWg70vD8S4IBuojOQR1CjvikV6FI_oMB64z2TutGCBnf3Pj
 ofKqlyiF4EH5YcXfzMmS0v_LSTIra0n_EL0XUe_SifUG9fAalEkCtXLLfDhu
 k0FlBjJg_cERtEE8yEwCER5nsjuodUncd5AvTcZ1Sj927GJhoyG3128dTcX4
 Q
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 14:26:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
In-Reply-To: <4FC506E6.8030108@parallels.com>
Message-ID: <alpine.DEB.2.00.1205291424130.8495@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-14-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290932530.4666@router.home> <4FC4F1A7.2010206@parallels.com> <alpine.DEB.2.00.1205291101580.6723@router.home>
 <4FC501E9.60607@parallels.com> <alpine.DEB.2.00.1205291222360.8495@router.home> <4FC506E6.8030108@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Glauber Costa wrote:

> But we really need a page to be filled with objects from the same cgroup, and
> the non-shared objects to be accounted to the right place.

No other subsystem has such a requirement. Even the NUMA nodes are mostly
suggestions and can be ignored by the allocators to use memory from other
pages.

> Otherwise, I don't think we can meet even the lighter of isolation guarantees.

The approach works just fine with NUMA and cpusets. Isolation is mostly
done on the per node boundaries and you already have per node statistics.

