Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0IHN4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:56:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65110 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0IHN4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=AZTilR4u07rWAa4ZMAdKgqAzihXlzzSIV1OQSwd252mFq07zDnRJ/KhCkCX7ZgpVlL
         uCd+yDqhdwJzzOQZIj1bqI1XuThgQOU41G+UXR5GFCQ/qjNl0mVroniRTi2pAeuTn2cl
         Ejw29zCQVlL1C5UUS20tpDs7Tw6jTyHvLoBz0=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1283953967.23762.22.camel@laptop>
References: <4c8793a9.cde7d80a.3bb6.0290@mx.google.com>
	<1283953967.23762.22.camel@laptop>
Date: Wed, 8 Sep 2010 15:56:21 +0200
Message-ID: <AANLkTikcJ3X0q8SXb55NbrFRd5GUVEXGzbePGUtxF+Wf@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v2)
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, robert.richter@amd.com, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 3:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-09-08 at 15:30 +0200, Stephane Eranian wrote:
>> +       } times[NR_CPUS] ____cacheline_aligned_in_smp;
>
> That's fail! NR_CPUS can be like 4k for distro configs.
>
How do you do this on struct that are dynamically allocated?
The number of css is dynamic.

> Use proper per-cpu allocations.
>
