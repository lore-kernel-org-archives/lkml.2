Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab1JMW7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 18:59:35 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:41134 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755715Ab1JMW7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 18:59:33 -0400
Date: Thu, 13 Oct 2011 23:59:18 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Victor Kamensky <kamensky@cisco.com>
Cc: David Daney <david.daney@cavium.com>, manesoni@cisco.com,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        ananth@in.ibm.com
Subject: Re: [PATCH] MIPS Kprobes: Support branch instructions probing
Message-ID: <20111013225918.GA12513@linux-mips.org>
References: <20111013090749.GB16761@cisco.com>
 <4E971FD3.2020308@cavium.com>
 <20111013180714.GA7422@linux-mips.org>
 <Pine.GSO.4.58.1110131205410.7452@infra-view9.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.58.1110131205410.7452@infra-view9.cisco.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 12:16:27PM -0700, Victor Kamensky wrote:

> Yes, it does make a lot of sense. Don't you think we need to do
> EXPORT_SYMBOL for __compute_return_epc as well? So it could be used by
> klms.
> 
> Actually we have yet another copy of it in mips uprobes code, which
> normally is built as klm, if we refactor and export __compute_return_epc
> all three places could use the same function.

Nothing wrong with exporting __compute_return_epc() as long as there are
actually users of the exported symbol.  So far it's only used from the
kernel proper which is why it's not been exported.  However I'd prefer it
to be exported as EXPORT_SYMBOL_GPL().

  Ralf
