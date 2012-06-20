Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab2FTIzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:55:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:54002 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab2FTIzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:55:03 -0400
Message-ID: <1340182493.21745.73.camel@twins>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for
 AMD family 15h
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 10:54:53 +0200
In-Reply-To: <CABPqkBS=QAnoz3-_XgRPoRsUh4GbpHQe+u75dR=pLG2isC8Ccw@mail.gmail.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
	 <CABPqkBS=QAnoz3-_XgRPoRsUh4GbpHQe+u75dR=pLG2isC8Ccw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 10:36 +0200, Stephane Eranian wrote:
> 
> I dont' quite understand the design choice here. In Fam15h, there is a clean
> design for the uncore PMU. It has its own distinct set of 4 counters. Unlike
> Fam10h, where you program core counters to access the NB counters. So
> why not like with Intel uncore, create a separate NB PMU which would
> advertise its characteristics? That does not preclude re-using the existing
> AMD-specific routines wherever possible. I think the advantage is that
> muxing or starting/stopping of the core PMU would not affect uncore and
> vice-versa for instance. Wouldn't this also alleviate the problems with
> assigning indexes to uncore PMU counters? 

Quite agreed, it also avoids making a trainwreck of the counter rotation
on overload.


