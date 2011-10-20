Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab1JTWUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 18:20:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34098 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab1JTWUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 18:20:34 -0400
Message-ID: <4EA09EA2.3030203@zytor.com>
Date: Thu, 20 Oct 2011 15:20:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai.lu@oracle.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>
In-Reply-To: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2011 02:15 PM, Jacob Shin wrote:
> On systems with very large memory (1 TB in our case), BIOS may report a
> reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
> these from the direct mapping.

> +			if (ei->type == E820_RESERVED)
> +				continue;

This should probably be ei->type != E820_RAM or something similar.  I
haven't looked yet, what does the < 4 GiB code do?

	-hpa

