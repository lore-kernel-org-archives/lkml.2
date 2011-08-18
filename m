Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab1HRUWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:22:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3875 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1HRUWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:22:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=B8xKxJ+GS3KC6nfrLtudstI/PAZcr8tNTzrBuOzaRPnJkLMo5tlRLIZam9nG3ySJb
	vwXFAZV0oefUQ2jbS0Rdg==
MIME-Version: 1.0
In-Reply-To: <1313462826.27321.22.camel@sli10-conroe>
References: <1313462826.27321.22.camel@sli10-conroe>
From: Justin TerAvest <teravest@google.com>
Date: Thu, 18 Aug 2011 13:22:22 -0700
Message-ID: <CAN5ZDdewpvg=82O69yGSXJczJMZrfqrLNS=RQiD2Ne2RqQTF1w@mail.gmail.com>
Subject: Re: cfq-iosched: a regression
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,

What was the workload you were running to find this regression?

On Mon, Aug 15, 2011 at 7:47 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> We have a kernel build regression since 3.1-rc1, which is about 10%
> regression. The kernel source is in an ext3 filesystem.
> Alex Shi bisect it to commit:
> commit a07405b7802691d29ab3b23bdc76ee6d006aad0b
> Author: Justin TerAvest <teravest@google.com>
> Date:   Sun Jul 10 22:09:19 2011 +0200
>
>    cfq: Remove special treatment for metadata rqs.
>
> Apparently this is caused by lack metadata preemption, where ext3/ext4
> do use READ_META. I didn't see a way to fix the issue, so suggest
> reverting the patch.
>
> Reported-by: Alex Shi<alex.shi@intel.com>
> Reported-by: Shaohua Li<shaohua.li@intel.com>
>
>
