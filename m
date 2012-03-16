Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161820Ab2CPAlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:41:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54307 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1032511Ab2CPAlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:41:13 -0400
Message-ID: <1331858472.5406.21.camel@joe2Laptop>
Subject: Re: [PATCH] ti-st: Enhange logging for Shared Transport - TI driver
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mircea Gherzan <mgherzan@gmail.com>, alexandrasava18@gmail.com,
        pavan_savoy@ti.com, daniel.baluta@gmail.com,
        linux-kernel@vger.kernel.org
Date: Thu, 15 Mar 2012 17:41:12 -0700
In-Reply-To: <20120316003523.GA25149@kroah.com>
References: <y> <4f623469.634cb40a.5d79.ffff841d@mx.google.com>
	 <4F6289B3.2060204@gmail.com> <20120316003523.GA25149@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 17:35 -0700, Greg KH wrote:
> On Fri, Mar 16, 2012 at 01:30:43AM +0100, Mircea Gherzan wrote:
> > This is what I get now (with no debug) when loading the btwilink module
> > that uses ti-st:
> > [  129.567382] (stk) :change remote baud rate command in firmware
> > [  129.573577] (stk) :skipping the wait event of change remote baud
> > This is:
> >  1. too "verbose" => these 2 prints should belong to debug
> >  2. poorly formated
> >  3. not telling me which driver generated this output
> >  4. not giving me the version of the firmware that was loaded.
> > To address 2 and 3, please remove the the "(stc)" / "(stk)" prefixes and
> > use instead the quite widespread prefix KBUILD_MODNAME ": "
> No, just use the proper dev_*() functions instead, it will tell you
> exactly what driver and device emitted the message, that is what it is
> there for.

I generally concur though there might be instances where
no struct device * is available and pr_<level> is a good
alternative for those cases.

