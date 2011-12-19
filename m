Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1LSLo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:44:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab1LSLoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:44:25 -0500
Message-ID: <4EEF2382.4010605@redhat.com>
Date: Mon, 19 Dec 2011 13:44:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu>
In-Reply-To: <20111219112326.GA15090@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 01:23 PM, Ingo Molnar wrote:
> What's behind this huge speedup? Does ebizzy use user-space 
> spinlocks perhaps? Could we do something on the user-space side 
> to get a similar speedup?

kvm tries to detect spinlocks (by trapping repeated executions of PAUSE)
and yield to a related vcpu.  It's far from perfect however, and relies
on the spinlock code using PAUSE.

-- 
error compiling committee.c: too many arguments to function

