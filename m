Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2E2OUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:20:23 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:48949 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752577Ab2E2OUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:20:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9R89Yb0VM1lFf1VwaaoklXzl2kirCm74wmSXy3N3c1lU28T
 SdpQFHvBJYnC3rOu.kgiTyNKpbztRv09Vi7w9nOwDOnNx.1d8q.OLKFJqiEv
 .AR0eeMyChN6tkEDmOtzjg7Jjk6V8yyBC4RnXN5a9DiRhlGmfNNOdeHYPdhP
 TCyYoheTxqi2.jCY3iS987M7Qzuikdd_jOL8Ud0lY8gmQzfowRg_nSF4oZ3L
 4xsAiZS7mY9hOV3VegEElrX3_bi8eo13afmAtAVjXIfzkhph5tX5mYr9Gt7k
 koJh86ZxhEmpWE6wFBWFJownXUZ6xpBuqr.Pydvq00LndMsuhi0MoDDXvL0J
 jS0dxLeSNS_b1ebAgrckSmGhdtJeXZpR6RLJaRrqZox.nY_4PTsFjlm0eDN4
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 09:20:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 05/28] memcg: Reclaim when more than one page
 needed.
In-Reply-To: <alpine.DEB.2.00.1205290917230.4666@router.home>
Message-ID: <alpine.DEB.2.00.1205290919130.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290917230.4666@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Christoph Lameter wrote:

> >  	 * unlikely to succeed so close to the limit, and we fall back
> >  	 * to regular pages anyway in case of failure.
> >  	 */
> > -	if (nr_pages == 1 && ret)
> > +	if (nr_pages <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER) && ret) {

Should this not be

	 nr_pages <= 1 << PAGE_ALLOC_COSTLY_ORDER
