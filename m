Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab0FQInO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:43:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:54502 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806Ab0FQInM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:43:12 -0400
Message-ID: <4C19E01F.2010403@suse.cz>
Date: Thu, 17 Jun 2010 10:43:11 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Makefile asking for mrproper on new checkout with KBUILD_OUTPUT
References: <4C194AB2.7050707@panasas.com>
In-Reply-To: <4C194AB2.7050707@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.6.2010 00:05, Boaz Harrosh wrote:
> 
> I get this problem: When a few Header files are changed, like when doing
> a git checkout the Makefile is complaining about mrproper needed.
> 
> Now I'm building a:
> 	make ARCH=arch KBUILD_OUTPUT=.build_arch/
> 
> But a: 
> 	make ARCH=arch KBUILD_OUTPUT=.build_arch/ mrproper
> 
> Will not help. What the Makefile wants is a:
> 	make mrproper
> 
> doing the "make mrproper" does solves it.
> It used to be fine, I'm not sure when it started to break.
> 
> How can I debug this to see what is the offending files?

The makefile errors out if the source directory is configured (*),
because having random object files in the source directory would confuse
the VPATH build.

(*) Means: either .config or include/config exists

Michal
