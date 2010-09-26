Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111Ab0IZFas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 01:30:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:55086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab0IZFaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 01:30:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,237,1283756400"; 
   d="scan'208";a="558026044"
Subject: Re: [PATCH 1/5] ACPI, APEI, Fix APEI related table size checking
From: Huang Ying <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20100921123945.GB18991@one.firstfloor.org>
References: <1284865235-29920-1-git-send-email-ying.huang@intel.com>
	 <1284865235-29920-2-git-send-email-ying.huang@intel.com>
	 <20100921123945.GB18991@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Sep 2010 13:30:34 +0800
Message-ID: <1285479034.15685.56.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 20:39 +0800, Andi Kleen wrote:
> On Sun, Sep 19, 2010 at 11:00:31AM +0800, Huang Ying wrote:
> > From: Yinghai Lu <yinghai@kernel.org>
> > 
> > Both ERST and EINJ table size checking is fixed.
> 
> Needs a better description.
> > ---
> >  drivers/acpi/apei/einj.c |    3 ++-
> >  drivers/acpi/apei/erst.c |    3 ++-
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
> > index 465c885..b184baa 100644
> > --- a/drivers/acpi/apei/einj.c
> > +++ b/drivers/acpi/apei/einj.c
> > @@ -426,7 +426,8 @@ DEFINE_SIMPLE_ATTRIBUTE(error_inject_fops, NULL,
> >  
> >  static int einj_check_table(struct acpi_table_einj *einj_tab)
> >  {
> > -	if (einj_tab->header_length != sizeof(struct acpi_table_einj))
> > +	if (einj_tab->header_length !=
> > +	    (sizeof(struct acpi_table_einj) - sizeof(einj_tab->header)))
> 
> I don't understand these changes. So on any system where the old check worked
> before it won't work anymore?  Since the code has been presumably tested
> before this would break systems, won't it?
> 
> Same with the other changes.

Yes. It seems that old check works on my testing machine but not on
Yinghai's machine, while the new check works on Yinghai's machine and
not on my testing machine.

So I think it is better to remove the checks. Apparently, Windows does
not check that.

Best Regards,
Huang Ying



