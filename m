Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408Ab0JISd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 14:33:29 -0400
Received: from kroah.org ([198.145.64.141]:45289 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760330Ab0JISd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 14:33:28 -0400
Date: Sat, 9 Oct 2010 11:32:31 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Roman Tereshonkov <roman.tereshonkov@nokia.com>,
        linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] kobject: name reference should not be lost when lack
	of memory error happens
Message-ID: <20101009183231.GA10094@kroah.com>
References: <1286447573-12579-1-git-send-email-roman.tereshonkov@nokia.com> <20101007175303.GB31639@kroah.com> <AANLkTikmWqc6-jYWr5G7OdboA+TSgCM4qKVfJBNMjPZ=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikmWqc6-jYWr5G7OdboA+TSgCM4qKVfJBNMjPZ=@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 04:32:44PM +0200, Kay Sievers wrote:
> On Thu, Oct 7, 2010 at 19:53, Greg KH <greg@kroah.com> wrote:
> > On Thu, Oct 07, 2010 at 01:32:53PM +0300, Roman Tereshonkov wrote:
> >> If lack of memory error happens we must restore the old kobject name reference
> >
> > No, we can't do that, as the caller will not be expecting that to have
> > happened, right Kay?
> >
> > I think the code as-is is correct, your kobject is in an unknown state
> > and can't be used anymore.
> 
> Yeah, we've been there several times already with no clear decision so far.
> 
> Trying to set a kobject name twice seems like a serious bug.
> 
> We should kill the old_name logic, and add a WARN() when kobj->name is
> already set when the function is called, I think.

Agreed, it will be interesting to see what is trying to do this :)

thanks,

greg k-h
