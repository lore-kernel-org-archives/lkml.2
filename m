Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2EaQmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:42:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46410 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2EaQmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:42:14 -0400
Message-ID: <4FC79F61.6030907@wwwdotorg.org>
Date: Thu, 31 May 2012 10:42:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 03:58 AM, Peter De Schrijver wrote:
> Add an extension API for clocks. This allows clocktypes to provide extensions
> for features which are uncommon and cannot be easily mapped onto normal clock
> framework concecpts. eg: resetting blocks, configuring clock phase etc.

I'm not sure that we should expose module reset as an operation on a clock.

In Tegra, there are resets that affect multiple clocks (well, they
affect portions of HW that use multiple clocks, not the clocks themselves).

Conversely, it's possible in general that there could be some clock
domains where different subsets of the clock domain are affected by
different reset domains.

Tieing the clock and reset domains together doesn't seem correct. A
separate reset API (and perhaps reset binding for DT) might make more sense.
