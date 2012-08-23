Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141Ab2HWP60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:58:26 -0400
Received: from nm5.access.bullet.mail.mud.yahoo.com ([66.94.237.206]:33279
	"HELO nm5.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030605Ab2HWP6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:58:22 -0400
X-Yahoo-Newman-Id: 366311.24195.bm@smtp109.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qb2RUUYVM1mM7d.7oTMIgCWYNihgftILQSyqPesR5GoWuW8
 CKMtrBlv_a4cCH0J.WnqBEIkekp2PgasHxZu0Uq4t1E4rIpeIGIZHskz8c0x
 IWua_evhMoj6rWaWdtK3liaP7.uXrg_UBwd2xkWum0bBLzgECOEXdbt64dsr
 zQQ45KuknNHuBz64VuYyi3odhqjPVkJQY1lpqWJXa2DsDmPd_WHlXhjqcpOt
 EUUMXh6fVA.TSLP2WxBLs8StiHpAq9IlkBBq.9GuUc0u2MpZyXQSsbhsm9px
 xVucDMiR_YdG.EiAzoyBhLQR0ab8JlVYdY.T.Xy8qc0YwtzbbtwPMm1yk0GG
 KfF3P5AOx2mZL9nk4Ak468WcliQzsXOY2iLptYG8UgLs6LXnclCiV5CSqnNY
 mlYXizixjGNu_unWpz73SnkzV5CFx.MAc7XAJyQYyi5lWfX_L0IWycGimBB6
 GtOys1euGL3pO3kn1dC4J.bgLH0mbGehRQ9jklNOVlXTKhv53PuGUW1g71JC
 Ie0EiVV2xpahUrR80VK9GhvM-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <5036531A.7030207@schaufler-ca.com>
Date: Thu, 23 Aug 2012 08:58:18 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: setprocattr memory leak fix
References: <50352873.9070706@schaufler-ca.com> <27988.1345726117@warthog.procyon.org.uk>
In-Reply-To: <27988.1345726117@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2012 5:48 AM, David Howells wrote:
> Casey Schaufler <casey@schaufler-ca.com> wrote:
>
>> From: Casey Schaufler <casey@schaufler-ca.com>
>> Subject: [PATCH] Smack: setprocattr memory leak fix
>>
>> The data structure allocations being done in prepare_creds
>> are duplicated in smack_setprocattr. This results in the
>> structure allocated in prepare_creds being orphaned and
>> never freed. The duplicate code is removed from
>> smack_setprocattr.
>>
>> Targeted for git://git.gitorious.org/smack-next/kernel.git
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Acked-by: David Howells <dhowells@redhat.com>

Thanks for the review.

> Note that I do have a patch to make Smack share rule lists - I've posted it a
> number of times, but I take it you're not interested.

The patch is a big chunk of code and the feature isn't getting
used to the extent that the people who requested it seemed
certain it would be. I don't see there being value in optimizing
the per-task rule lists given the amount of use they get.

>
>   5707  06/13 [To:casey@schauf]  [PATCH 1/3] Smack: Constify some pointers<<Mak
>   5708  06/13   [To:casey@schauf]  [PATCH 2/3] Smack: Further constification<<M
>   5709  06/13   [To:casey@schauf]  [PATCH 3/3] Smack: Use rule list tail sharin
>
> David
>

