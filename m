Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0FANQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:16:44 -0400
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:62795 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012Ab0FANQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:16:42 -0400
X-Greylist: delayed 791 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2010 09:16:42 EDT
From: Ian Campbell <ijc@hellion.org.uk>
To: Petr Ovtchenkov <ptr@void-ptr.info>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <201006011622.58834.ptr@void-ptr.info>
References: <201006011622.58834.ptr@void-ptr.info>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 14:03:07 +0100
Message-ID: <1275397387.24218.20972.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: constant half-byte from /proc/sys/kernel/random/uuid
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=1ggfb5FlKZQUfF3vzm9UBYZ2uTfLsbs/8dSljwg5+mE= c=1 sm=0 a=nZLmAaR5cR4A:10 a=hO-oPbc3tlwA:10 a=IkcTkHD0fZMA:10 a=8pif782wAAAA:8 a=H0G_-gRozxSwJ53WFS4A:9 a=avJ8EQlvkFqhzAuE8btYGwmeM8gA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 16:22 +0400, Petr Ovtchenkov wrote:
> Lack of randomness during generating uuid.
[...]
> See on 7th high half-byte: it '4' in
> all cases---4b, 42, 40, 43, 49, 41,
> 4b, 4b, 4e. Checked three comps, with
> similar results. All Linux-generated UUID (boot_id)
> that I see in internet has '4' in this
> half-byte.

This appears to be deliberate. From drivers/char/random.c:

        void generate_random_uuid(unsigned char uuid_out[16])
        {
                get_random_bytes(uuid_out, 16);
                /* Set UUID version to 4 --- truly random generation */
                uuid_out[6] = (uuid_out[6] & 0x0F) | 0x40;
                /* Set the UUID variant to DCE */
                uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
        }
        EXPORT_SYMBOL(generate_random_uuid);

Version 4 UUIDs and the format used are described at
http://en.wikipedia.org/wiki/Universally_Unique_Identifier

Ian.

-- 
Ian Campbell
Current Noise: Jesu - Your Path To Divinity

Build a system that even a fool can use and only a fool will want to use it.

