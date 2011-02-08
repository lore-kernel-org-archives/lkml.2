Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1BHJcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:32:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44024 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1BHJcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:32:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BDXjWPzUz77x7exi7hLe0hL5NazrMLK4zf2mons1VIMFbAtMCbwZwa6VdmO5ZNAO2m
         p9gyUSrFBSml4vRrG2fMPA9WT317p0XDW6rduMCuPALnoeIxOnnmS3zxCzRrbvyyyUu9
         0WVzWxacDs7j7uT96MOgrTFuP+oGFY6OSKbgQ=
Date: Tue, 8 Feb 2011 10:32:12 +0100
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Len Brown <len.brown@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] thermal: Use freezable workqueue
Message-ID: <20110208093212.GA6558@htj.dyndns.org>
References: <201102080029.57195.rjw@sisk.pl>
 <20110208044712.GA906@core.coreip.homeip.net>
 <201102081020.25646.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102081020.25646.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dmitry, Rafael.

On Tue, Feb 08, 2011 at 10:20:25AM +0100, Rafael J. Wysocki wrote:
> > > +	thermal_wq = alloc_workqueue("thermal", WQ_FREEZEABLE, 0);
> > 
> > Should probably be unbound as well.
> 
> Yup, thanks.

Hmm.. why should it be unbound?  Unbound wqs are primarily useful for
very long running (system daemon type) works which may also consume
considerable amount of cpu cycles.

> > FWIW, I would not mind if we had a global freezeable workqueue already
> > predefined. I could switch input_polldev and vmw_balloon to it and there
> > probably could be more users...
> 
> Hmm, OK.
> 
> Do you think we should add system_freezeable_wq to the set of predefined
> workqueues?

Oh, yeah, definitely.  I'll write up a patch.

Thanks.

-- 
tejun
