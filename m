Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2B2UiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:38:09 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49630 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab2B2UiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:38:06 -0500
Message-ID: <4F4E8C46.3040005@linux.vnet.ibm.com>
Date: Wed, 29 Feb 2012 12:36:22 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@linux.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231536240.13554@router.home> <m1ehtkapn9.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1202240859340.2621@router.home> <4F47BF56.6010602@linux.vnet.ibm.com> <alpine.DEB.2.00.1202241053220.3726@router.home> <alpine.DEB.2.00.1202241105280.3726@router.home> <4F47C800.4090903@linux.vnet.ibm.com> <alpine.DEB.2.00.1202241131400.3726@router.home> <87sjhzun47.fsf@xmission.com> <alpine.DEB.2.00.1202271238450.32410@router.home> <87d390janv.fsf@xmission.com> <alpine.DEB.2.00.1202271636230.6435@router.home> <alpine.DEB.2.00.1202281329190.25590@router.home> <20120229123120.127e21fd.akpm@linux-foundation.org>
In-Reply-To: <20120229123120.127e21fd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022920-5806-0000-0000-000013082254
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 12:31 PM, Andrew Morton wrote:
> What was the user-visible impact of the bug?

It'll probably oops dereferencing task->cred:

https://lkml.org/lkml/2012/2/23/302

Although I was never actually able to get it to trigger without some
code to enlarge the race window.

