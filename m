Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab1ADMDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 07:03:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab1ADMDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 07:03:44 -0500
Message-ID: <4D230C90.6060104@redhat.com>
Date: Tue, 04 Jan 2011 14:03:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
References: <20110103162637.29f23c40@annuminas.surriel.com> <20110103162918.577a9620@annuminas.surriel.com> <20110104151345.3BC2.A69D9226@jp.fujitsu.com>
In-Reply-To: <20110104151345.3BC2.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 08:14 AM, KOSAKI Motohiro wrote:
> Also, If pthread_cond_signal() call sys_yield_to imlicitly, we can
> avoid almost Nehalem (and other P2P cache arch) lock unfairness
> problem. (probaby creating pthread_condattr_setautoyield_np or similar
> knob is good one)

Often, the thread calling pthread_cond_signal() wants to continue 
executing, not yield.

-- 
error compiling committee.c: too many arguments to function

