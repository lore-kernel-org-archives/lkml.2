Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1ABRTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 12:19:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab1ABRTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 12:19:48 -0500
Message-ID: <4D20B38B.40007@redhat.com>
Date: Sun, 02 Jan 2011 12:19:07 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Edwin Zhai <edwin.zhai@intel.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
References: <AANLkTikqDDq2GWYONu=JyGkrETMATx14LCFbm+e4PSSZ@mail.gmail.com>
In-Reply-To: <AANLkTikqDDq2GWYONu=JyGkrETMATx14LCFbm+e4PSSZ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2011 06:43 AM, Hillf Danton wrote:

> The following work is based on what Rik posted, with a few changes.

I threw out my patch before Christmas, replacing it with
Mike Galbraith's work.

Today I finally discovered why I had not been getting
very useful results testing the PLE code on the test
system.

On this particular CPU model (Intel(R) Xeon(R) CPU X5670),
the value of ple_gap needs to be at least 48 !

A ple_gap value of 41 is simply too low to trigger reliably
with Avi's kvm-unit-tests PLE test and also only triggers
a few times a second at most (not too useful) with the other
tests I had been running...

-- 
All rights reversed
