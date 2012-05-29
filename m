Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab2E2Ov0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:51:26 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:23327 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753942Ab2E2OvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:51:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MsRLOVEVM1mK2qKLV9LVsWnCayV.pi1UbXcBaOpf5aNSwsB
 sJoIoIbCzQSbEVkBwOtGzns4urh.d7LsH4xyfj8Zz9iTSR6.kZ3AjeQxZfOx
 r9lk167Jhvj0Pve0gAqLQnthqE2ps2baguAXfYjfcJUisl4t_ouYQh6qMrhV
 G1OtS2EezAFYDLIBm4w7K1TgmwYxfeYpSabfMd.x6VN5Lw6cexjABajdCWbW
 BNYA_Q9jWYDtEWNmb9TWzcyXAHfSf6wBYs.CJ3qGOaGjiF2DrmDtXO2otPmQ
 UVv3EeWSkIme18Ger6VD2WwJNND3FEHJFuxpvAsSrtCxCPv6IP4j2EjJ_vqv
 ih2JV13iJSIaLyChLRGbtrTXfVTXGgJJsAZO3AEZlUC_5.15tLxmpP8XsbRU
 x
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 09:51:20 -0500 (CDT)
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
Subject: Re: [PATCH v3 18/28] slub: charge allocation to a memcg
In-Reply-To: <1337951028-3427-19-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205290948250.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-19-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Glauber Costa wrote:

> This patch charges allocation of a slab object to a particular
> memcg.

I am wondering why you need all the other patches. The simplest approach
would just to hook into page allocation and freeing from the slab
allocators as done here and charge to the currently active cgroup. This
avoids all the duplication of slab caches and per node as well as per cpu
structures. A certain degree of fuzziness cannot be avoided given that
objects are cached and may be served to multiple cgroups. If that can be
tolerated then the rest would be just like this patch which could be made
more simple and non intrusive.

