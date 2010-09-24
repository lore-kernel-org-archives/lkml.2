Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab0IXQ4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:56:33 -0400
Received: from xenotime.net ([72.52.115.56]:39670 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756987Ab0IXQ4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:56:31 -0400
Date: Fri, 24 Sep 2010 09:56:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Vernon Mauery <vernux@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v4
Message-Id: <20100924095625.5beedf5a.rdunlap@xenotime.net>
In-Reply-To: <AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
References: <20100921224610.GO13162@lucy>
	<20100923221253.GA4960@lucy>
	<20100923225346.GB4960@lucy>
	<201009241512.39311.arnd@arndb.de>
	<AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 07:14:27 -0700 Vernon Mauery wrote:

> On Fri, Sep 24, 2010 at 6:12 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 24 September 2010, Vernon Mauery wrote:
> >> +enum rtl_addr_type {
> >> +     RTL_ADDR_TYPE_IO = 1,
> >> +     RTL_ADDR_TYPE_MMIO,
> >> +} __attribute__((packed));
> >> +
> >> +enum rtl_cmd_type {
> >> +     RTL_CMD_NOP = 0,
> >> +     RTL_CMD_ENTER_PRTM,
> >> +     RTL_CMD_EXIT_PRTM,
> >> +} __attribute__((packed));
> >
> > You didn't reply to Randy's comment about the packed attribute.
> > I think it's rather confusing here.

thanks.

> Sorry.  I missed that comment.  The packed attribute on an enum forces
> it into the smallest int type it can be.  enums are normally the size
> of an int, but this enum in the RTL table must fit in an 8-bit int.

I think you would be better off making 'command' below be a u8 then.
Otherwise someone else might add an enum value that is > 255 and the
struct size will change.  I.e., the current way is error-prone.
Just using u8 for command's type is safer.


> >> +/* The RTL table as presented by the EBDA: */
> >> +struct ibm_rtl_table {
> >> +     char signature[5];
> >> +     u8 version;
> >> +     u8 rt_status;
> >> +     enum rtl_cmd_type command;
> >> +     u8 command_status;
> >> +     enum rtl_addr_type cmd_address_type;
> >> +     u8 cmd_granularity;
> >> +     u8 cmd_offset;
> >> +     u16 reserve1;
> >> +     u8 cmd_port_address[4]; /* platform dependent address */
> >> +     u8 cmd_port_value[4];   /* platform dependent value */
> >> +};
> >
> > I would recommend marking the member in this structure as packed instead,
> > not the enum.
> 
> It does not have the same effect.  Without the packed attribute on the
> enums, they end up to be the wrong size and then we would be reading
> from the wrong location in memory.

Thanks for the explanation.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
