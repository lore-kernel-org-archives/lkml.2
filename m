Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab0DHJwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:52:18 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:42966 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0DHJwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:52:16 -0400
Message-ID: <4BBDA742.9010507@lumino.de>
Date: Thu, 08 Apr 2010 11:52:02 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de> <4BBDA1CB.3070204@davidnewall.com>
In-Reply-To: <4BBDA1CB.3070204@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 11:28 AM, David Newall wrote:
> Will the system use multiple cores?  If it's only single core, perhaps
> atomic operations are really necessary?
At the moment I am just planning a single core NIOS project. But SMP is
a decent option for NIOS, as it is no hardware problem - and often has
been requested - to design multiple CPUs in a single in such an FPGA and
run SMP Linux on it.

OTOH, to do FUTEX in full (MMU) - Linux, atomic operations are
definitively necessary, as in Userland you can't disable the interrupt
without a Kernel call (which to avoid FUTEX is all about.) Currently the
plan with the NIOS (MMU, non-SMP) arch is to simulate atomic operations
with the said "atomic region" (as is done with e.g. the BlackFin arch).

(BTW.: when enumerating the ways how atomic macros are done I forgot to
mention the "new ARM" method: dedicated "load locked, store conditional"
operations that help simulating atomic behavior in user space without
the Kernel's help.)

-Michael
