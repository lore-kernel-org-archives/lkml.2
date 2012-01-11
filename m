Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab2AKL0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:26:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756275Ab2AKL0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:26:48 -0500
Message-ID: <4F0D71F0.4030203@redhat.com>
Date: Wed, 11 Jan 2012 13:26:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Borzenkov, Andrey" <andrey.borzenkov@ts.fujitsu.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Extermeley large PageTables over 500G on kernel 2.6.32.49 (SLES11
 SP1)
References: <CB1B361E45A85849902B25342E88900501CFDC3110D6@ABGEX70E.FSC.NET> <1326278196.2767.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CB1B361E45A85849902B25342E88900501CFDC311187@ABGEX70E.FSC.NET>
In-Reply-To: <CB1B361E45A85849902B25342E88900501CFDC311187@ABGEX70E.FSC.NET>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 12:52 PM, Borzenkov, Andrey wrote:
> > If not, its normal to eat so much memory for page tables
> > 
> > grep VmPTE /proc/*/status
> > 
> > 
>
> Forgive my ignorance. I thought that
>
> 1. PTE is 8 bytes per page, which is 4K which gives 2K per 1M of memory
> 2. All processes sharing the same shared memory share the same page table
>
> So page table for Oracle SGA 500G would be around 1G and shared by all Oracle clients. Is my assumption incorrect?
>

The second assumption is incorrect.  So fully populated the 2000
processes would consume 2T; they just haven't accessed all the SGA yet.

-- 
error compiling committee.c: too many arguments to function

