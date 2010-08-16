Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab0HPUYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:24:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48157 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab0HPUYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:24:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=dz5YnFeXED4Wa+kAQlhKmqvVSP5uvG03y1tZkaAEzZy1NXg5l3Vifulb3jUwYgF9p
	70CBqXCfTtLogSoLNOqCw==
MIME-Version: 1.0
In-Reply-To: <4C699455.6020200@pobox.com>
References: <AANLkTikSSmP5f1csa=xPTR=EqY4D5a=6t2oDVkZ7cA-v@mail.gmail.com>
	<CAC4B8726E86A142B27A9E9A2F2F12470149041A4E@rrsmsx505.amr.corp.intel.com>
	<AANLkTik4RNvaE5OrFq3NmZ+-9DKhAAaNQ3cdPg38zOr2@mail.gmail.com>
	<4C699455.6020200@pobox.com>
Date: Mon, 16 Aug 2010 13:24:09 -0700
Message-ID: <AANLkTi=R4GQGVE5AvU9hdWXdtqZzaOswrGQA+cPgO58W@mail.gmail.com>
Subject: Re: [PATCH] 2.6.35 libata support for > 512 byte sectors (e.g. 4K Native)
From: Grant Grundler <grundler@google.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Tejun Heo <tj@kernel.org>, Linux IDE <linux-ide@vger.kernel.org>,
        Gwendal Grignou <gwendal@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 12:41 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
...
> The main question is whether the size of a DRQ block changes, when LBA
> logical size changes?

Don't we already know that depends on the ATA command?

> I need to review the ATA8 specs in this area, but I
> would think some interfaces that return 512-byte pages for things like SMART
> info would be unchanged.  How do the drives behave for PIO-Data-{In,Out}
> commands that are not reading/writing user data, but rather drive metadata?

SMART Info/Logs are meta data and as you noted unchanged.

Two other meta-data PIO commands I can think of:
o  FW update: I'm not going to risk bricking this drive to find that out.
o Vendor specific selftest/diagnostic commands (I don't know if any
exist - just a guess)

If someone from Hitachi cares to respond publicly regarding the
behavior of this "Engineering Sample", that would be appreciated and
helpful.  But feedback from any other vendor would be welcome/useful
also.

I suspect legacy tools might be needed to update firmware and those
might continue to function if DRQ block size is still 512 byte.  I'd
like to leave this hardcoded to ATA_SECT_SIZE until someone can
demonstrate a need to change it. Ok?

thanks,
grant
