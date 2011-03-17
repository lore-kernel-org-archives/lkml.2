Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1CQRHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:07:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33824 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab1CQRHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:07:30 -0400
Date: Thu, 17 Mar 2011 10:07:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [BUG] usb_wwan: build error
Message-Id: <20110317100718.6f4d6fe3.randy.dunlap@oracle.com>
In-Reply-To: <201103170702.28752.oliver@neukum.org>
References: <1300341100.10164.523.camel@edumazet-laptop>
	<201103170702.28752.oliver@neukum.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D823FCB.00B1,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 07:02:28 +0100 Oliver Neukum wrote:

> Am Donnerstag, 17. März 2011, 06:51:40 schrieb Eric Dumazet:
> > commit 16871dcac74c (usb_wwan: error case of resume) added a build error
> > if CONFIG_PM_RUNTIME is not defined.
> > 
> >   CC [M]  drivers/usb/serial/usb_wwan.o
> > drivers/usb/serial/usb_wwan.c: In function ‘play_delayed’:
> > drivers/usb/serial/usb_wwan.c:702: error: ‘struct dev_pm_info’ has no
> > member named ‘usage_count’
> > 
> > I suspect we should use pm_runtime_put_noidle() instead
> 
> Yes. I don't understand why it compiled for me. Has it been removed?

usage_count is only there when CONFIG_PM_RUNTIME is enabled.
Building with CONFIG_PM_RUNTIME disabled produces a build error.


> 	Regards
> 		Oliver
> 
> PS: patch about to follow

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
