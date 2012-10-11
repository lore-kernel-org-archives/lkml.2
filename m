Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab2JKM6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:58:23 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36684 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308Ab2JKM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:58:19 -0400
Message-ID: <1349960296.2425.53.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RESEND PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 13:58:16 +0100
In-Reply-To: <5076AE3B.5040509@imgtec.com>
References: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com>
	 <1349951069.2425.44.camel@dabdike.int.hansenpartnership.com>
	 <5076AE3B.5040509@imgtec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 12:32 +0100, James Hogan wrote:
> On 11/10/12 11:24, James Bottomley wrote:
> > On Thu, 2012-10-11 at 10:15 +0100, James Hogan wrote:
> >> The struct scsi_varlen_cdb_hdr is expected to be exactly 10 bytes when
> >> used in struct osd_cdb_head, but it isn't marked as packed. Some
> >> architectures will round the struct size up which triggers BUILD_BUG_ON
> >> compile errors in osd_initiator.c when the outer structs are unexpected
> >> sizes. This is fixed by marking struct scsi_varlen_cdb_hdr as __packed.
> > 
> > What actual problem have you encountered? The structure is {u8[8], u16}
> > which is naturally packed on every architecture I know about.  I've even
> > built osd_initiator without problem on parisc, which has some of the
> > most rigid alignment rules I've seen.
> 
> Hi James,
> 
> The alignment is fine (the offset of the u16 is 8 bytes), but
> unfortunately with the metag port of gcc, sizeof(struct
> scsi_varlen_cdb_hdr) is rounded up to a 4 byte boundary (even though the
> largest data member alignment is only 2 bytes), which is 12 bytes
> instead of 10.

That sounds to be a bug in your compiler ... it shouldn't be rounding up
structure sizes if the structure can fit in 10 bytes.  This isn't
happening in any other architecture that I know of (otherwise we'd have
had a reported build break).

James


