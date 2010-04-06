Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab0DFTSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:18:44 -0400
Received: from claw.goop.org ([74.207.240.146]:40648 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693Ab0DFTSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:18:40 -0400
Message-ID: <4BBB890E.5040808@goop.org>
Date: Tue, 06 Apr 2010 12:18:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Dmitry Torokhov <dtor@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>
Subject: Re: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com> <20100405142419.2c9bea3d.akpm@linux-foundation.org> <20100405225833.GA25970@dtor-ws.eng.vmware.com> <4BBB622F.4070501@redhat.com> <4BBB7CA3.2060802@goop.org> <4BBB7F1E.3030307@redhat.com>
In-Reply-To: <4BBB7F1E.3030307@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 11:36 AM, Avi Kivity wrote:
> On 04/06/2010 09:25 PM, Jeremy Fitzhardinge wrote:
>> On 04/06/2010 09:32 AM, Avi Kivity wrote:
>>> Yeah.  If we wanted commonality, we could make a balloon_core.c that 
>>> contains the common code.  IMO that's premature, but perhaps there's 
>>> some meat there (like suspend/resume support and /proc//sys interface).
>>
>> I think it would be useful to have common:
>>
>>   1. User and kernel mode ABIs for controlling ballooning.  It assumes
>>      that the different balloon implementations are sufficiently
>>      similar in semantics.   (Once there's a kernel ABI, adding a
>>      common user ABI is trivial.)
>>   2. Policy driving the ballooning driver, at least from the guest
>>      side.  That is, some good metrics from the vm subsystem about
>>      memory pressure (both positive and negative), and something to
>>      turn those metrics into requests to the balloon driver.
>>
>> 1) is not a huge amount of code, but something consistent would be 
>> nice.  2) is something we've been missing and is a bit of an open 
>> question/research project anyway.
>
> 3) Code that attempts to reclaim 2MB pages when possible

Yes.  Ballooning in 4k units is a bit silly.

     J

