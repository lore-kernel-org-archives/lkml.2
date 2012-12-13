Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab2LMWzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:55:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40374 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab2LMWzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:55:10 -0500
Message-ID: <50CA5CAC.9050508@zytor.com>
Date: Thu, 13 Dec 2012 14:54:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v6 18/27] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org> <1355436141-8668-19-git-send-email-yinghai@kernel.org>
In-Reply-To: <1355436141-8668-19-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 02:02 PM, Yinghai Lu wrote:
>  1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
>  				(below)
> +1F0/001	ALL	sentinel	0: states _ext_* fields are vali

0x1f0 is unsuitable for use as sentinel -- or in fact for any purpose --
because it is quite plausible that someone may (fairly sanely) start the
copy range at 0x1f0 instead of 0x1f1... we really should have documented
it that way but it is too late now.

However, we can use 0x1ef.

	-hpa

