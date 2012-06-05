Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab2FEQuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:50:40 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40840 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab2FEQui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:50:38 -0400
Date: Tue, 5 Jun 2012 18:50:09 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: anilkumar@ti.com
Cc: mkl@pengutronix.de, bhupesh.sharma@st.com, federico.vaga@gmail.com,
        alan@lxorguk.ukuu.org.uk, wg@grandegger.com, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] c_can_pci: generic module for c_can on PCI
Message-ID: <20120605165008.GA21871@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13E9CB18A@DBDE01.ent.ti.com>
References: <331ABD5ECB02734CA317220B2BBEABC13E9CB18A@DBDE01.ent.ti.com>
  <4FCE07EE.40003@pengutronix.de>
   <D5ECB3C7A6F99444980976A8C6D896384FA5EC4DFC@EAPEX1MAIL1.st.com>
   <4FC135C6.5030206@grandegger.com> <1677842.Pq7naXsvrI@harkonnen>
   <D5ECB3C7A6F99444980976A8C6D896384FA5EC4B37@EAPEX1MAIL1.st.com>
   <3650428.HarNR9HfNF@harkonnen> <20120605131337.GA15432@mail.gnudd.com>
  <20120605133013.GA16108@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am late to the discussion, is there any specific reason to maintain a
> separate platform file (c_can_pci.c).

Because it depends on pci and ifdef is bad.

> I think 90% of the code is copied from c_can_paltform.c, code
> changes will be less if you merge to existing c_can platform driver.

Yes, but then we need to ifdef around, which merges two bad files
into a single but worse file.

But since the only current user of c_can is the platform device, why
not merging the platform with the core and having pci just register a
platform device?  The only problem I see is that we need cooperation,
because neither me nor federico have a c_can equipped board besides
the pci one.

thanks
/alessandro
