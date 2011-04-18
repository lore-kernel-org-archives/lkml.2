Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab1DROpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:45:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41414 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1DROpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:45:45 -0400
Message-ID: <4DAC4E7F.1010502@zytor.com>
Date: Mon, 18 Apr 2011 07:45:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/4] x86, gart: Don't enforce GART aperture lower-bound
 by alignment
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com> <1303134346-5805-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1303134346-5805-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 06:45 AM, Joerg Roedel wrote:
> This patch changes the allocation of the GART aperture to
> enforce only natural alignment instead of aligning it on
> 512MB. This big alignment was used to force the GART
> aperture to be over 512MB. This is enforced by using 512MB
> as the lower-bound address in the allocation range.
> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Better implementation of the existing bounds, yes, but I think the
algorithm is still wrong.  Specifically, 512 MiB seems to have been the
maximum address of the kernel at some point, but that is historic at
this point, at least on 64 bits.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

