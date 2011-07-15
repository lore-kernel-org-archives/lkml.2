Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1GOQF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:05:28 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:61336 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1GOQF0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 15 Jul 2011 12:05:26 -0400
Message-Id: <4E208162020000780004DA39@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 15 Jul 2011 17:05:22 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ian Campbell" <Ian.Campbell@citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Keir Fraser" <keir@xen.org>
Cc: "Olaf Hering" <olaf@aepfle.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on
	 resume
References: <20110701104148.GA32729@aepfle.de>
 <20110712164342.GA12867@aepfle.de> <20110712181118.GA18662@dumpdata.com>
 <1310548364.634.355.camel@zakaz.uk.xensource.com>
In-Reply-To: <1310548364.634.355.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.07.11 at 11:12, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> It's not so much an objection to this patch but this issue seems to have
> been caused by Xen cset 20892:d311d1efc25e which looks to me like a
> subtle ABI breakage for guests. Perhaps we should introduce a feature
> flag to indicate that a guest can cope with the m2p changing size over
> migration like this?

That's actually not strait forward, as the hypervisor can't see the ELF
note specified features of a DomU kernel. Passing this information
down from the tools or from the guest kernel itself otoh doesn't
necessarily seem worth it. Instead a guest that can deal with the
upper bound of the M2P table changing can easily obtain the
desired information through XENMEM_maximum_ram_page. So I
think on the hypervisor side we're good with the patch I sent
earlier today.

Now - does anyone remember why machine_to_phys_order got
introduced in the first place (rather than doing a precise upper
bound check using the maximum number the hypervisor returned)?
I really can't see any benefit in calculating and using the much
more coarse order only.

Jan


