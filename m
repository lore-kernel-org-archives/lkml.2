Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab2HQO13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:27:29 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52788 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757022Ab2HQO1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:27:21 -0400
Date: Fri, 17 Aug 2012 10:27:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Hans de Goede <hdegoede@redhat.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Miklos Szeredi <miklos@szeredi.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [REGRESION] Suspend hangs with 3.6-rc1 on Lenovo T60 notebook
In-Reply-To: <Pine.LNX.4.44L0.1208171011560.25520-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1208171025330.25520-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2012, Alan Stern wrote:

> On Fri, 17 Aug 2012, Hans de Goede wrote:
> 
> > No my patch was a hack to undo the results of the commit causing
> > the regression in the IDE case. But Alan's approach clearly is
> > much better! Once we are sure drvdata is not used anywhere the
> > dev_set_drvdata call could be removed in the place where my
> > hack added a second call to it. Note that there are likely
> > actual ide drivers using it, without setting it themselves since
> > the ide core was setting it. So removing it will require even more
> > auditing / checking.
> 
> I did search for dev_get_drvdata() calls in drivers/ide; there were no 
> other calls that retrieved an ide_drive_t value.  But I didn't check 
> anywhere else in the kernel.  In fact, I'm not sure where else to look.

After a little more checking: Among all the .c files in the kernel
which match the pattern '[^a-z]ide_', the only occurrences of
dev_get_drvdata() which retrieve an ide_drive_t value are the two in
ide-pm.c.

Alan Stern

