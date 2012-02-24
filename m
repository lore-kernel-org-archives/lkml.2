Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab2BXQyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:54:19 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:48201 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753007Ab2BXQyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:54:18 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HY2XSCMVM1mz2pUuj4Ep8LTuGTQFI1vq7nWxFHYvcjzxTSd
 D48oJaKvhEvJLkiP2M.r3W1bFoMoYzPhYI8Kc3Jf9IYz2kkHKN.6lGu3MFnT
 YB.sv4Suf8w12Mn9W2rtS993QsctaZ5jvDycY_ecWl9xNI1Q7k570m3Q8ZQK
 tZ9mWf4khSMPNYMvSNAqrQwq_wyw9YcaZOAYT.h9lkUvrCR9TVblaQZ9pDbZ
 Iyb7jOtpWsZ3JyoSy5D0JeLeLDkDga4O2zYRV809OeS0tl0IeKqnJViQ0JSR
 GOdXqKGAc.Pd8XGxTdBrIQsGiqpBdQtUJM0tznjy7UfM565puNuZSSpqSIoN
 oUGUWFX6cf4I7ok1j_Nkq5oYvbZpVAUe0kVR.SEAP4t4uasRmFaW4Ykix5DB
 4
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 24 Feb 2012 10:54:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
In-Reply-To: <4F47BF56.6010602@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1202241053220.3726@router.home>
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231536240.13554@router.home>
 <m1ehtkapn9.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1202240859340.2621@router.home> <4F47BF56.6010602@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Dave Hansen wrote:

> On 02/24/2012 07:20 AM, Christoph Lameter wrote:
> > Subject: migration: Do not do rcu_read_unlock until the last time we need the task_struct pointer
> >
> > Migration functions perform the rcu_read_unlock too early. As a result the
> > task pointed to may change. Bugs were introduced when adding security checks
> > because rcu_unlock/lock sequences were inserted. Plus the security checks
> > and do_move_pages used the task_struct pointer after rcu_unlock.
> >
> > Fix those issues by removing the unlock/lock sequences and moving the
> > rcu_read_unlock after the last use of the task struct pointer.
> >
> > Signed-off-by: Christoph Lameter <cl@linux.com>
>
> It doesn't fix the code duplication, but it definitely does fix the bug

Yes I did not want to override all your good work.

Could you do another patch that removed the duplication?

