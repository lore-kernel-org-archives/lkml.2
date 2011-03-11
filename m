Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab1CKSrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:47:39 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57449 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1CKSrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:47:32 -0500
Message-ID: <4D7A6DC2.9060601@kernel.org>
Date: Fri, 11 Mar 2011 10:45:22 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table handling
References: <4D6EB335.8000306@kernel.org> <20110303061711.GG28266@mtj.dyndns.org> <4D791C9F.1010500@kernel.org> <20110311082938.GC13038@htj.dyndns.org> <20110311083351.GD13038@htj.dyndns.org> <4D7A4430.1030301@kernel.org> <20110311155446.GH13038@htj.dyndns.org> <AANLkTim31ZDBRtBFL2J5HD8j8__tzkSF_HdD-HVt6V49@mail.gmail.com> <20110311181958.GJ13038@htj.dyndns.org> <AANLkTimAA-NF43DtrZTHZWLyYMVdDkw89QCLcfsC0Rbh@mail.gmail.com> <20110311182940.GK13038@htj.dyndns.org>
In-Reply-To: <20110311182940.GK13038@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D7A6E33.00E5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 10:29 AM, Tejun Heo wrote:
> On Fri, Mar 11, 2011 at 10:25:23AM -0800, Yinghai Lu wrote:
>> now even emulation have that distance array.
>>
>> why keep it simple to make all path have that array?
> 
> Okay, I don't know, maybe, but I don't think it's gonna buy much.  We
> need boundary check in the distance testing function anyway in case
> someone calls in with out-of-bound nid's and not having distance table
> is just a degenerate case of the generic sanity check, so there really
> isn't much to be gained by allocating dummy table.

for out-of-bound nid access, looks like should generate BUG_ON for it ?
