Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab2BXQsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:48:33 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55650 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab2BXQsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:48:32 -0500
Message-ID: <4F47BF56.6010602@linux.vnet.ibm.com>
Date: Fri, 24 Feb 2012 08:48:22 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231536240.13554@router.home> <m1ehtkapn9.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1202240859340.2621@router.home>
In-Reply-To: <alpine.DEB.2.00.1202240859340.2621@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022416-5806-0000-0000-000012DCE21D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 07:20 AM, Christoph Lameter wrote:
> Subject: migration: Do not do rcu_read_unlock until the last time we need the task_struct pointer
> 
> Migration functions perform the rcu_read_unlock too early. As a result the
> task pointed to may change. Bugs were introduced when adding security checks
> because rcu_unlock/lock sequences were inserted. Plus the security checks
> and do_move_pages used the task_struct pointer after rcu_unlock.
> 
> Fix those issues by removing the unlock/lock sequences and moving the
> rcu_read_unlock after the last use of the task struct pointer.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

It doesn't fix the code duplication, but it definitely does fix the bug
I was originally trying to address.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

