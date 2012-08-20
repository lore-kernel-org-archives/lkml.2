Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2HTOMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:12:41 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:43136 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2HTOMh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 20 Aug 2012 10:12:37 -0400
Message-Id: <503261F00200007800096710@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 20 Aug 2012 15:12:32 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Alex Shi" <alex.shi@intel.com>
Cc: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: apparent regressions from TLB range flushing page set
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

without even having run that code yet, I think I see two bugs here,
both of which I'm pretty sure I pointed out at least once during the
review cycle:

For one, while TLB_FLUSH_ALL gets passed as 'end' argument to
flush_tlb_others(), the Xen code was made to check its 'start'
parameter.

Second, the UV code doesn't flush the full range at all, it simply
ignores its 'end' parameter (and hence also the "all" indicator).

While the Xen one is simple to fix, I have no clue what to do for
the UV code.

Jan

