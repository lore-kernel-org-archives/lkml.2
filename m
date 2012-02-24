Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab2BXRIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:08:46 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:39478 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757393Ab2BXRIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:08:44 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Mqt_UMAVM1krxXoTwwI5DXe4flWleuuvaGAsU3JF.oz1YgB
 HL1TpySiOoEK66lHHKBj42ghBcGvz2iXXGqpTVoBrLH7BEJDkAVlAnpkvmLa
 Z3ct9wVV887zeleiK1a7I62AXQkD4clvknL9ptb78_lG3vIydoOKGw20IxmO
 JLUPwYaNTyKgUc6plxPHmcil_2jVL6O76LhmpW6xx.0ULeJmCSL_ovWqyJ0E
 ELNMuS4xP3_6H37WkJl.h4MSKQadBeffzv7Ps0clgA7eSGndjhdLEZ1i4JrZ
 HxriwLkC0oTc0OF4iySXJsN7SYwaqJvFgKr.4ZcHEaZOdUm1tPRV.PRiD9pC
 IU45Qt6j7fUnwR8NUGPTJ00Cxm_Mi9bCP9v9uggZTGJOwDz6FBycvY.zaU8r
 0
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 24 Feb 2012 11:08:41 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
In-Reply-To: <alpine.DEB.2.00.1202241053220.3726@router.home>
Message-ID: <alpine.DEB.2.00.1202241105280.3726@router.home>
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231536240.13554@router.home>
 <m1ehtkapn9.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1202240859340.2621@router.home> <4F47BF56.6010602@linux.vnet.ibm.com> <alpine.DEB.2.00.1202241053220.3726@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh and another thing. There are certain functions that are now called
under rcu read lock()

	security_task_movememory

and

	cpuset_mems_allowed


cpuset_mems_allowed takes a mutex. Hmmm... Under rcu?

security_task_movememory does some kind of security hook.


Is that all safe? If not then we need to take a refcount on the task
struct after all.

