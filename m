Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab0JURZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:25:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597Ab0JURZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:25:45 -0400
Date: Thu, 21 Oct 2010 10:25:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush ANAND <pratyush.anand@st.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>
Subject: Re: [PATCH V2 45/69] ST SPEAr: PCIE gadget suppport
Message-Id: <20101021102534.5845ac4a.akpm@linux-foundation.org>
In-Reply-To: <0901B62280FF37468247D8348744254F449565AA97@EAPEX1MAIL1.st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
	<c91308e26397dbe49f384c7d3cf168593e1fe8b0.1285933332.git.viresh.kumar@st.com>
	<20101019144725.977297f5.akpm@linux-foundation.org>
	<0901B62280FF37468247D8348744254F449565AA97@EAPEX1MAIL1.st.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 22:18:28 +0800 Pratyush ANAND <pratyush.anand@st.com> wrote:

> > > +static ssize_t pcie_gadget_show_help(struct device *dev,
> > > +           struct device_attribute *attr, char *buf)
> > > +{
> > > +   char text[] = "\t\tlink read->ltssm status\n \
> > > +           link write->arg1 = UP to enable ltsmm DOWN to disable\n \
> > > +           int_type read->type of supported interrupt\n \
> > > +           int_type write->arg1 = interrupt type to be configured and\n \
> > > +           can be INTA, MSI or NO_INT\n \
> > > +           (select MSI only when you have programmed no_of_msi)\n \
> > > +           no_of_msi read->zero if MSI is not enabled by host\n \
> > > +           and positive value is the number of MSI vector granted\n \
> > > +           no_of_msi write->arg1 = number of MSI vector needed\n \
> > > +           inta write->arg1 = 1 to assert INTA and 0 to de-assert\n \
> > > +           send_msi write->arg1 = MSI vector to be send\n \
> > > +           vendor_id read->programmed vendor id (hex)\n\
> > > +           vendor_id write->arg1 = vendor id(hex) to be programmed\n \
> > > +           device_id read->programmed device id(hex)\n \
> > > +           device_id write->arg1 = device id(hex) to be programmed\n \
> > > +           bar0_size read->size of bar0 in hex\n \
> > > +           bar0_size write->arg1= size of bar0 in hex\n \
> > > +           (default bar0 size is 1000 (hex) bytes)\n \
> > > +           bar0_address read->address of bar0 mapped area in hex\n \
> > > +           bar0_address write->arg1 = address of bar0 mapped area in
> > hex\n\
> > > +           (default mapping of bar0 is SYSRAM1(E0800000)\n \
> > > +           (always program bar size before bar address)\n \
> > > +           (kernel might modify bar size and address to align)\n \
> > > +           (read back bar size and address after writing to check)\n \
> > > +           bar0_rw_offset read->offset of bar0 for which bar0_data \n \
> > > +           will return value\n \
> > > +           bar0_rw_offset write->arg1 = offset of bar0 for which\n \
> > > +           bar0_data will write value\n \
> > > +           bar0_data read->data at bar0_rw_offset\n \
> > > +           bar0_data write->arg1 = data to be written at\n \
> > > +           bar0_rw_offset\n";
> > > +
> > > +   int size = (sizeof(text) < PAGE_SIZE) ? sizeof(text) : PAGE_SIZE;
> > > +
> > > +   return snprintf(buf, size, "%s", text);
> > > +}
> >
> > What the heck is this??
> >
> 
> This was just to provide help for different sysfs nodes. What could be the other
> Way to do it? Should it be better to remove help node from here provide all the help
> In a separate document?

Yes, documenting it externally would be more typical.

