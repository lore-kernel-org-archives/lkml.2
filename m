Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2FMI5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:57:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:56274 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2FMI5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:57:47 -0400
Message-ID: <1339577859.31548.127.camel@twins>
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Date: Wed, 13 Jun 2012 10:57:39 +0200
In-Reply-To: <1339536350-10463-1-git-send-email-andi@firstfloor.org>
References: <1339536350-10463-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 14:25 -0700, Andi Kleen wrote:
> At CPU hotplug or S3 resume time there is a short race window
> where something might run on the CPUs but before the microcode
> update notifier runs. For the current workarounds that need this
> this is acceptable and shouldn't be a problem. 

I'm not convinced,.. the CPU_ONLINE notifier stuff runs pretty late, by
then its already running normal userspace.

We really should do the ucode update from CPU_STARTING.
