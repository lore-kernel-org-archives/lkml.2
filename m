Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1CKTGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:06:32 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:54914 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab1CKTGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:06:30 -0500
Message-ID: <4D7A7272.70100@kernel.org>
Date: Fri, 11 Mar 2011 11:05:22 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86-64, NUMA: Don't call numa_set_distanc() for
 all possible node combinations during emulation
References: <4D6E91EC.6040906@kernel.org> <20110302190208.GD28266@mtj.dyndns.org> <4D6E9541.2040201@kernel.org> <20110302191338.GE28266@mtj.dyndns.org> <4D6EA975.8070200@kernel.org> <20110302205704.GF28266@mtj.dyndns.org> <4D6EB335.8000306@kernel.org> <20110303061711.GG28266@mtj.dyndns.org> <4D791C9F.1010500@kernel.org> <20110311082938.GC13038@htj.dyndns.org> <20110311093124.GE13038@htj.dyndns.org>
In-Reply-To: <20110311093124.GE13038@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D7A7293.00B1,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 01:31 AM, Tejun Heo wrote:
> The distance transforming in numa_emulation() used to call
> numa_set_distance() for all MAX_NUMNODES * MAX_NUMNODES node
> combinations regardless of which are enabled.  As numa_set_distance()
> ignores all out-of-bound distance settings, this doesn't cause any
> problem other than looping unnecessarily many times during boot.
> 
> However, as MAX_NUMNODES * MAX_NUMNODES can be pretty high, update the
> code such that it iterates through only the enabled combinations.
> 
> Yinghai Lu identified the issue and provided an initial patch to
> address the issue; however, the patch was incorrect in that it didn't
> build emulated distance table when there's no physical distance table
> and unnecessarily complex.
> 
>   http://thread.gmane.org/gmane.linux.kernel/1107986/focus=1107988
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Yinghai Lu <yinghai@kernel.org>
