Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1COWg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:36:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42270 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1COWg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:36:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gO7yiV5/FOBbPhEgVWBM6xEaJ8wSXfOFxx/x+f4TczWa+HklZrsNTBjegiE0Bf3FaX
         QdHaVe+TfSPhAbOJQwRI0pD+frlEId2cXtMnkiEaMSx7VsHkSR9uSDjaNquet0kGecbl
         yr4GgAy9hrrOR25B93aFs7gV5BO5VvmPRtfiE=
MIME-Version: 1.0
In-Reply-To: <20110315184629.GB3620@n2100.arm.linux.org.uk>
References: <20110315181941.26948.65323.stgit@e102109-lin.cambridge.arm.com>
	<20110315184629.GB3620@n2100.arm.linux.org.uk>
Date: Tue, 15 Mar 2011 22:36:55 +0000
X-Google-Sender-Auth: vQP3fmO17QiJ_-Nhh9RP63-9g-A
Message-ID: <AANLkTinb52LL8rAM6A1SKrnz+Q=azc_9fQtiR7aYi+HW@mail.gmail.com>
Subject: Re: [PATCH] Avoid indefinite wait in smp_call_function_many() if
 cpumask is modified
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Saeed Bishara <saeed.bishara@gmail.com>,
        Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 15 March 2011, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Mar 15, 2011 at 06:20:56PM +0000, Catalin Marinas wrote:
>> On ARM processors (and not only) with software broadcasting of the TLB
>> maintenance operations, smp_call_function_many() is given a
>> mm_cpumask(mm) as argument. This cpumask may be modified (bits cleared)
>> during the smp_call_function_many() execution as a result of other
>> events like ASID roll-over.
>
> We shouldn't be modifying a mask which has been passed into one of these
> functions.  Having masks change beneath a function which is actively
> using it and can wait is an obvious recipe for problems and races.

It's not that bad since the mask is copied inside the function.
Anyway, it looks like such patch has been around for more than a
month, so I'm not pushing it anymore.

Catalin

-- 
Catalin
