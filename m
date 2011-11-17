Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1KQXTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:19:14 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48006 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1KQXTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:19:12 -0500
Message-ID: <4EC5966A.4000106@opensuse.org>
Date: Thu, 17 Nov 2011 20:19:06 -0300
From: =?UTF-8?B?Q3Jpc3RpYW4gUm9kcsOtZ3Vleg==?= <crrodriguez@opensuse.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andrei Warkentin <andreiw@vmware.com>, linux-kernel@vger.kernel.org,
        Rolf Eike Beer <eike-kernel@sf-tec.de>, opensuse-kernel@opensuse.org,
        Sergiu Iordache <sergiu@chromium.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [opensuse-kernel] Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
References: <1321473366-31053-1-git-send-email-andreiw@vmware.com> <20111117150549.15528e81.akpm@linux-foundation.org>
In-Reply-To: <20111117150549.15528e81.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/11/11 20:05, Andrew Morton wrote:

> I assume that nobody has gone off and checked whether all current
> callers will survive this change.  If they had, they'd have looked in
> drivers/char/ramoops.c and seen:
> 
> 	rounddown_pow_of_two(pdata->mem_size);
> 	rounddown_pow_of_two(pdata->record_size);
> 
> These operations are no-ops.  It should be
> 
> 	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
> 	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
> 
> That we have this many warts using these interfaces is an indication
> that the interfaces aren't very good.  Poorly documented, at least.
> 

making that macro an inline function and annotating with
__attribute__((warn_unused_result)) looks like a good start for me.

