Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0CTSxa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 14:53:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48400 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0CTSx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 14:53:29 -0400
Message-ID: <4BA519A3.3000605@kernel.org>
Date: Sat, 20 Mar 2010 11:53:23 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86-32: Split cache flush handler from simd handler
References: <1268936453-3727-1-git-send-email-brgerst@gmail.com>	 <1268936453-3727-2-git-send-email-brgerst@gmail.com>	 <4BA3FBB5.2050008@zytor.com> <73c1f2161003192108n72311e00h49fcf9eac5a2b4fc@mail.gmail.com> <4BA45527.5050202@zytor.com>
In-Reply-To: <4BA45527.5050202@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 09:55 PM, H. Peter Anvin wrote:
> 
> Ah, guess it was even older than I first realized ... I should have
> searched for the string "cache flush denied" instead.
> 
> Sounds like we should do three things:
> 
> a) update the comment to actually reflect what is going on;
> b) compile it out for > 486;
> c) report the error as trap 13 rather than 19.
> 

Actually what we should do is recognize that this is nothing other than
a misdirected #GP, and as a result send the fault down the #GP handler
(do_general_protection)... there really isn't any need for a special
routine at all.

	-hpa
