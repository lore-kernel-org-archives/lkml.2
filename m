Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0HRFfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:35:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:57611 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab0HRFfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:35:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,225,1280732400"; 
   d="scan'208";a="313820801"
Subject: Re: [PATCH 1/4] [Patch-next] ACPI, APEI, ERST Fix the wrong
 checking of Serialization Header's length
From: Huang Ying <ying.huang@intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Lu Yinghai <yinghai@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
In-Reply-To: <4C6A139D.20507@np.css.fujitsu.com>
References: <4C69DDB5.6060103@np.css.fujitsu.com>
	 <1282008836.2744.1490.camel@yhuang-dev>
	 <4C69F094.1040607@np.css.fujitsu.com>
	 <1282015344.2744.1500.camel@yhuang-dev> <4C6A139D.20507@np.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 13:34:56 +0800
Message-ID: <1282109696.2744.1553.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 12:44 +0800, Jin Dongming wrote:
> (2010/08/17 12:22), Huang Ying wrote:
> > On Tue, 2010-08-17 at 10:14 +0800, Jin Dongming wrote:
> >>> I don't think it is necessary to change the header definition, and
> >>> seri_header is not a good name for me.
> >> Why I added this structure here is that I don't want to do following checking.
> >> For example,
> >> 	if (header_length != 0x0c) {
> >> 		...
> >> 	}
> > 
> > This can be:
> > 
> >  static int erst_check_table(struct acpi_table_erst *erst_tab)
> >  {
> > -       if (erst_tab->header_length != sizeof(struct acpi_table_erst))
> > +       if (erst_tab->header_length !=
> > +           (sizeof(struct acpi_table_erst) - sizeof(erst_tab->header)))
> > 
> > like Yinghai has been done.
> > 
> Yes. It looks good. And I am sorry I am unaware of Yinghai' patch. 

Maybe you can help push this fix in, it seems that Yinghai is busy on
something else?

Hi, Yinghai,

Do you mind for Dongming to push this fix?

Best REgards,
Huang Ying


