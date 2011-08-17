Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab1HQGkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 02:40:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38516 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1HQGkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 02:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAFdhcLRKvfqBnXCXLwq-Qe1eNAGC-8XJ3BtHpQKzaa3RhHyp6A@mail.gmail.com>
References: <CAFdhcLRKvfqBnXCXLwq-Qe1eNAGC-8XJ3BtHpQKzaa3RhHyp6A@mail.gmail.com>
Date: Wed, 17 Aug 2011 02:40:19 -0400
Message-ID: <CAFdhcLTFv4Wk0kBb2NSL7oh+78BJ=6qPT4XfcOssOkwEERyj=w@mail.gmail.com>
Subject: Re: [PATCH 2/5] writeback: dirty position control
From: David Horner <ds2horner@gmail.com>
To: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Cc: jack@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I noticed a significant typo below (another of those thousand eyes,
thanks to Jan Kara's post that started ne looking) :

 > +static unsigned long bdi_position_ratio(struct backing_dev_info *bdi,
 > + unsigned long thresh,
...
 > + * For JBOD case, bdi_thresh (not bdi_dirty!) could fluctuate up to its
 > + * own size, so move the slope over accordingly.
 > + */
 > + if (unlikely(bdi_thresh > thresh))
 > + bdi_thresh = thresh;
 > + /*
 > + * scale global setpoint to bdi's:  setpoint *= bdi_thresh / thresh
 > + */
 > + x = div_u64((u64)bdi_thresh << 16, thresh | 1);

                  ^
 I believe should be

    x = div_u64((u64)bdi_thresh << 16, thresh + 1);

    David Horner
