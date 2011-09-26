Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1IZI77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:59:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:35078 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1IZI76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:59:58 -0400
Subject: Re: [V6][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org
Date: Mon, 26 Sep 2011 10:59:14 +0200
In-Reply-To: <1316805435-14832-5-git-send-email-dzickus@redhat.com>
References: <1316805435-14832-1-git-send-email-dzickus@redhat.com>
	 <1316805435-14832-5-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317027554.9084.71.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 15:17 -0400, Don Zickus wrote:
> +       /*
> +        * Use 'false' as back-to-back NMIs are dealt with one level up.
> +        * Of course this makes having multiple 'unknown' handlers useless
> +        * as only the first one is ever run (unless it can actually determine
> +        * if it caused the NMI)
> +        */
> +       handled = nmi_handle(NMI_UNKNOWN, regs, false); 

Shouldn't we then also add something like:

WARN_ON_ONCE(type == NMI_UNKNOWN && !list_empty(&desc->head));

to __setup_nmi()?


