Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0IMJVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 05:21:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab0IMJVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 05:21:33 -0400
Message-ID: <4C8DED17.6080801@suse.de>
Date: Mon, 13 Sep 2010 11:21:27 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Vasu Dev <vasu.dev@linux.intel.com>, Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH 0/2] lio-target: Add support for libcrypto crc32c and
 crc32-intel offload
References: <1284201076-22361-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1284201076-22361-1-git-send-email-nab@linux-iscsi.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings all,
> 
> This patch series converts the LIO-Target fabric module from using a legacy
> internal slicing by 1x CRC32C algorithm to the slicing by 1x CRC32C available in
> crc32c.ko, as well as initial support for the Nehalem series crc32c-intel.ko
> instruction offload available since v2.6.27 in late 2008.
> 
> So far this series has been lightly tested with a handful of Open-iSCSI client VMs
> with the optimized crc32c-intel.ko offload case, and there appears to be some
> HeaderDigest failures for one case with RHEL6 B2 x86_64, while Ubuntu i686 on
> v2.6.27 and OpenSuse 11.2 x86_64 on v2.6.31 work as expected with HeaderDigest=CRC32C
> and DataDigest=CRC32C using the offload on the LIO-Target side.
> 
> Currently this patch disables the new iSCSI TPG attribute crc32c_x86_offload
> to force the crc32c.ko slicing by x1 CRC32C algorithm until these compatibility
> issues with existing libcrc32c clients can be properly resolved with the Nehalem
> CRC32C offload instructions running on the LIO-Target side.
> 
Due to a customer issue I had to revisit the CRC32 issue recently.
And according to you the main reason for using your own CRC routines
had been endianness issues.
IE the in-kernel crc32c routines apparently weren't able to
calculate the checksum in an endianness-independent manner.
So a CRC calculated on a BE machine would fail to be validated by a
LE machine and vice versa.

Has this been fixed / verified?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
