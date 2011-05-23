Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1EWLLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:11:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45786 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1EWLLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:11:00 -0400
Subject: Re: [PATCH 0/3] perf_events: update extra shared registers
 management (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <BANLkTinN92UpxU85r17zB+Khba8k59nJTA@mail.gmail.com>
References: <20110520143707.GA5347@quad> <1306141897.18455.8.camel@twins>
	 <1306143168.18455.10.camel@twins>
	 <BANLkTimVM2XvpJ1d9SbmAh7xZ+qSjukX+A@mail.gmail.com>
	 <BANLkTinN92UpxU85r17zB+Khba8k59nJTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 May 2011 13:10:26 +0200
Message-ID: <1306149026.18455.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 12:58 +0200, Stephane Eranian wrote:
> There is a major issue as it stands, though. You can
> get into an infinite loop bouncing between RSP_0 and RSP_1
> in case there is no solution in the group, i.e., you have 3 values
> for the extra MSR. I think you need to count the number of times
> you've called intel_try_alt_er() with success or maintain some sort
> of bitmask of possible alternate choices and when you exhaust that,
> you simply fail. 

That should be sorted by the compare with the initial idx value, no?
Once its back where it started out it'll bail.
