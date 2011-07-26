Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1GZQrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:47:01 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:37483 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751431Ab1GZQqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:46:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fePMFtwC19GPUVldgj7eTfNGKODj/TnFtu5ANfI/BjTU3dIKgSLbEIPca3mdTmnWr7naMMeA7VKK0231vrVK0wKBHs6N38yVNHKDV8NIm2NhWT+FGut6O0OY0Aj2XbDx;
Date: Tue, 26 Jul 2011 09:46:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 5/5] drm/i915: DP_PIPE_ENABLED must check
 transcoder on CPT
Message-ID: <20110726094648.2100f149@jbarnes-desktop>
In-Reply-To: <1311662194-4050-6-git-send-email-keithp@keithp.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com>
	<1311662194-4050-6-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jul 2011 23:36:34 -0700
Keith Packard <keithp@keithp.com> wrote:

> Display port pipe selection on CPT is not done with a bit in the
> output register, rather it is controlled by a couple of bits in the
> separate transcoder register which indicate which display port output
> is connected to the transcoder.
> 
> This patch replaces the simplistic macro DP_PIPE_ENABLED with the
> rather more complicated function dp_pipe_enabled which checks the
> output register to see if that is enabled, and then goes on to either
> check the output register pipe selection bit (on non-CPT) or the
> transcoder DP selection bits (on CPT).
> 
> Before this patch, any time the mode of pipe A was changed, any
> display port outputs on pipe B would get disabled as
> intel_disable_pch_ports would ensure that the mode setting operation
> could occur on pipe A without interference from other outputs
> connected to that pch port
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---

Ah nice catch.  I expect one day we'll have all the chipset and PCH
differences coded...

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
