Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1LLTEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:04:32 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46805 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753365Ab1LLTE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:04:29 -0500
X-Sasl-enc: CWzeuTgNHr8HglBEl1bYtuSArVtmN8u7y19deO87I3Bw 1323716661
Date: Mon, 12 Dec 2011 10:33:17 -0800
From: Greg KH <greg@kroah.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, adobriyan@gmail.com
Subject: Re: [PATCH] kref: add function for reading kref value
Message-ID: <20111212183317.GA11486@kroah.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
 <20111212150255.GA7506@kroah.com>
 <CAEnQRZBiVDAHH+uZ=Ugk=UP5qSvvMViGTM-bRWr+E27zivOUug@mail.gmail.com>
 <1323703934.1765.15.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CAEnQRZCZdPw9eWVmdvhtF7KCQkYpLMrkhv5qd5xYckxWksN+0w@mail.gmail.com>
 <1323704494.1765.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CAEnQRZAt0X6cxGLgLUVTB9rzLKVYLEnh=azS9WOyKAkUZEpj4g@mail.gmail.com>
 <20111212173344.GA10162@kroah.com>
 <CAEnQRZDFvD3BTJs45hvP8LVCF_SNrYZyxxiiGXXP+koFfaYAdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEnQRZDFvD3BTJs45hvP8LVCF_SNrYZyxxiiGXXP+koFfaYAdQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 07:46:33PM +0200, Daniel Baluta wrote:
> On Mon, Dec 12, 2011 at 7:33 PM, Greg KH <greg@kroah.com> wrote:
> > On Mon, Dec 12, 2011 at 06:42:59PM +0200, Daniel Baluta wrote:
> >> On Mon, Dec 12, 2011 at 5:41 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >> > Le lundi 12 décembre 2011 ŕ 17:39 +0200, Daniel Baluta a écrit :
> >> >
> >> >> Ok, for the moment it seems to be a bad idea. But my intention is
> >> >> to integrate kref to networking code, and then to write a general
> >> >> debugging tool for refs.
> >> >>
> >> >> Tracking down reference count problems is hard, and this tool can
> >> >> really help everyone.
> >> >
> >> > I dont think kref will help you that much, because its used everywhere.
> >> >
> >> > Adding a general debugging tool will provide too much noise.
> >> >
> >> > Instead, we (network dev) add debugging points where we want.
> >>
> >> Yes, but you have to do this each time you start debugging, for a
> >> particular referenced counted object.
> >>
> >> We must find a clever solution to avoid the noise. (e.g use
> >> /proc, /sysfs, /debugfs options to trigger dumping info for
> >> some/all objects with a certain state).
> >
> > Then use the dynamic debug infrastructure, which is there to help you
> > try to handle this type of debugging on-the-fly.
> >
> > But again, it's not a kref issue, sorry.
> 
> I see. Thanks.
> 
> One last remark: Should we encourage people
> to use kref implementation, instead of making
> their own ?

Yes, where possible.

But, as the network developers keep pointing out, this is not a place
for a kref.

thanks,

greg k-h
