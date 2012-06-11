Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2FKNrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:47:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48044 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2FKNrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:47:52 -0400
Message-ID: <1339422464.30462.17.camel@twins>
Subject: Re: [PATCH] perf/x86: fix broken LBR fixup code
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, asharma@fb.com, mingo@elte.hu
Date: Mon, 11 Jun 2012 15:47:44 +0200
In-Reply-To: <20120611134426.GA7542@quad>
References: <20120611134426.GA7542@quad>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 15:44 +0200, Stephane Eranian wrote:
> I noticed that the LBR fixups were not working anymore
> on programs where they used to. I tracked this down to
> a recent change to copy_from_user_nmi().
> 
> commit db0dc75d6403b6663c0eab4c6ccb672eb9b2ed72
> Author: Arun Sharma <asharma@fb.com>
> Date:   Fri Apr 20 15:41:36 2012 -0700
> 
>     perf/x86: Check user address explicitly in copy_from_user_nmi()
>     
> This commit added a call to __range_not_ok() to the
> copy_from_user_nmi() routine. The problem is that the logic
> of the test must be reversed. __range_not_ok() returns 0 if the
> range is VALID. We want to return early from copy_from_user_nmi()
> if the range is NOT valid.

D'0h.. Thanks!
