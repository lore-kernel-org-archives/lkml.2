Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab0JMJqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:46:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:43315 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab0JMJp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 05:45:59 -0400
Message-ID: <4CB57FC2.9020509@kernel.org>
Date: Wed, 13 Oct 2010 11:45:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH unfinished update] firewire: sbp2: parallelize login/inquiry,
 reconnect, and shutdown
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de> <tkrat.1433473bc081daa9@s5r6.in-berlin.de> <tkrat.6dd361dadace9a41@s5r6.in-berlin.de> <tkrat.b190ad8b687a549a@s5r6.in-berlin.de> <4CB4EAA5.5010605@s5r6.in-berlin.de>
In-Reply-To: <4CB4EAA5.5010605@s5r6.in-berlin.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Oct 2010 09:45:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/13/2010 01:09 AM, Stefan Richter wrote:
> More extensive change but probably with simpler end result: Let
> sbp2_probe and sbp2_update perform login/scsi_add_device/reconnect
> directly.  sbp2_probe and sbp2_update are serialized per node, but
> (since 2.6.36 with cmwq) parallelized across nodes.

I don't know much about firewire details but just in case it helps.
libata does the ATA part of probing in parallel using the async
mechanism (which is a wrapper around workqueue now) and executes the
SCSI probing in a serialized context.  If SCSI parallel probing is
causing the problem, maybe firewire can do similar thing?  The
difference between using async and workqueue directly is only in how
things can be ordered.  There are cases where parallelizing probe is
easier with async but one way or the other it shouldn't matter too
much.

Thanks.

-- 
tejun
