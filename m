Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab2KPNFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:05:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53586 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2KPNFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:05:12 -0500
Message-ID: <50A63A01.3080404@redhat.com>
Date: Fri, 16 Nov 2012 14:05:05 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Christoph Hellwig <hch@infradead.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] target: Add max_write_same_len device attribute
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>  <1352405238-23267-3-git-send-email-nab@linux-iscsi.org>  <20121115105312.GC28956@infradead.org> <1353007392.4447.22.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1353007392.4447.22.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/11/2012 20:23, Nicholas A. Bellinger ha scritto:
>>> > > 
>>> > > This patch adds a new max_write_same_len device attribute for use with
>>> > > WRITE_SAME w/ UNMAP=0 backend emulation.
>>> > > 
>>> > > Also, update block limits VPD emulation code in spc_emulate_evpd_b0() to
>>> > > set the default MAXIMUM WRITE SAME LENGTH value of zero.
>> > 
>> > why do we need an exposed attribute for this?
>> > 
> This is useful for userspace to reduce the allowed maximum from the
> default 0xFFFF set by IBLOCK.  Allowing huge WRITE_SAMEs can very much
> effect performance (esp. with spinning media), so being able to reduce
> the max we accept via a userspace tunable is helpful.

Unfortunately this doesn't really help.  Linux will submit the smaller
WRITE SAMEs in parallel, and this could easily bring the target to its
knees.

(This was reported to me with a Linux virtual machine sending WRITE SAME
commands to a Nexenta iSCSI target running OpenSolaris.  QEMU can be
easily replaced with LIO, with the same effect).

Paolo
