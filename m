Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2JIG26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:28:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:63512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab2JIG2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:28:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,558,1344236400"; 
   d="scan'208";a="203279845"
Date: Tue, 9 Oct 2012 14:22:06 +0800
From: Feng Tang <feng.tang@intel.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 27/30] ACPI: EC: Add a quirk for CLEVO M720T/M730T
 laptop
Message-ID: <20121009142206.63dd9981@feng-i7>
In-Reply-To: <20121009061633.GA3648@elie.Belkin>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
	<67bfa9b60bd689601554526d144b21d529f78a09.1349761836.git.len.brown@intel.com>
	<20121009061633.GA3648@elie.Belkin>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Tue, 9 Oct 2012 14:16:33 +0800
Jonathan Nieder <jrnieder@gmail.com> wrote:

> Len Brown wrote:
> 
> > By enlarging the GPE storm threshold back to 20, that laptop's
> > EC works fine with interrupt mode instead of polling mode.
> 
> What would go wrong if the threshold were just increased to 20 on all
> models?

Then some other platform will stop to work.
	https://bugzilla.kernel.org/show_bug.cgi?id=11892 

The 26/30 and 27/30 patches are bound together to fix one bug. Some
quote from description from the 26th patch:

ACPI_EC_STORM_THRESHOLD was initially 20 when it's created, and
was changed to 8 in 2.6.28 commit 06cf7d3c7 "ACPI: EC: lower interrupt storm
threshold" to fix kernel bug 11892 by forcing the laptop in that bug to
work in polling mode.

Hope this answers your question.

Thanks,
Feng
