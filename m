Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab0LMRDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:03:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758369Ab0LMRDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:03:16 -0500
Message-ID: <4D0651BB.9040609@redhat.com>
Date: Mon, 13 Dec 2010 12:02:51 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/3] directed yield for Pause Loop Exiting
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101210050344.GR3158@balbir.in.ibm.com> <4D0328CC.1020809@redhat.com> <20101211135727.GU3158@balbir.in.ibm.com>
In-Reply-To: <20101211135727.GU3158@balbir.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2010 08:57 AM, Balbir Singh wrote:

> If the vpcu holding the lock runs more and capped, the timeslice
> transfer is a heuristic that will not help.

That indicates you really need the cap to be per guest, and
not per VCPU.

Having one VCPU spin on a lock (and achieve nothing), because
the other one cannot give up the lock due to hitting its CPU
cap could lead to showstoppingly bad performance.

-- 
All rights reversed
