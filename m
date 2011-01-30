Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1A3OEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 09:04:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab1A3OEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 09:04:52 -0500
Message-ID: <4D456FF9.2010309@redhat.com>
Date: Sun, 30 Jan 2011 16:04:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 3/6] KVM-GST: KVM Steal time accounting
References: <1296244340-15173-1-git-send-email-glommer@redhat.com> <1296244340-15173-4-git-send-email-glommer@redhat.com>
In-Reply-To: <1296244340-15173-4-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2011 09:52 PM, Glauber Costa wrote:
> This patch accounts steal time time in kernel/sched.
> I kept it from last proposal, because I still see advantages
> in it: Doing it here will give us easier access from scheduler
> variables such as the cpu rq. The next patch shows an example of
> usage for it.
>
> Since functions like account_idle_time() can be called from
> multiple places, not only account_process_tick(), steal time
> grabbing is repeated in each account function separatedely.
>

I accept that steal time is worthwhile, but do you have some way to 
demonstrate that the implementation actually works and is beneficial?

Perhaps run two cpu-bound compute processes on one vcpu, overcommit that 
vcpu, and see what happens to the processing rate with and without steal 
time accounting.  I'd expect a fairer response with steal time accounting.

-- 
error compiling committee.c: too many arguments to function

